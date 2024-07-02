require 'github_client'

namespace :update_status_task do
  # 毎日、全ユーザーのステータスを更新する
  desc '初期データの作成'
  task create_status: :environment do
    User.all.each do |user|
      # ユーザーのプロフィールデータを作成
      UserStatus.create!(user_id: user.id)

      # githubに対してgraphqlリクエストを送信
      response = GitHubClient::Client.query(Api::V1::GraphqlController::Query,
                                            variables: { name: user.github_uid,
                                                         to: Time.current.yesterday.end_of_day.iso8601,
                                                         from: Time.current.ago(30.days).beginning_of_day.iso8601 })

      # 一番新しい日にちのコントリビューション数
      latest_date_contributions = response.original_hash.dig('data', 'user', 'contributionsCollection',
                                                             'contributionCalendar', 'weeks', -1, 'contributionDays', -1, 'contributionCount')

      # 一番古い日にちのコントリビューション数
      oldest_date_contributions = response.original_hash.dig('data', 'user', 'contributionsCollection', 'contributionCalendar',
                                                             'weeks', 0, 'contributionDays', 0, 'contributionCount')

      # 約１ヶ月分全てのコントリビューション数
      all_contributions = response.original_hash.dig('data', 'user', 'contributionsCollection', 'contributionCalendar',
                                                     'totalContributions')

      # データがない場合にはスキップ
      next if all_contributions.blank?

      # 経験値の計算
      experience_point_data = latest_date_contributions

      # 次回の経験値の計算の際、前日のコントリビューション数を保存するためのデータ
      temporal_contributions = all_contributions - oldest_date_contributions

      # ユーザーデータからlevelを取得
      level = user.user_status.level

      # 経験値が10以上の場合、レベルアップする
      if experience_point_data >= 10
        while experience_point_data >= 10
          experience_point_data -= 10
          level += 1
        end
        user.user_status.update!(level:, contribution_diff: temporal_contributions,
                                 experience_points: experience_point_data)
      else
        user.user_status.update!(contribution_diff: temporal_contributions,
                                 experience_points: experience_point_data)
      end
    end
  end

  # 毎日、全ユーザーのステータスを更新する
  desc '直近１週間のコントリビューション数の取得'
  task fetch_contributions: :environment do
    User.all.each do |user|
      # githubに対してgraphqlリクエストを送信
      response = GitHubClient::Client.query(Api::V1::GraphqlController::Query,
                                            variables: { name: user.github_uid,
                                                         to: Time.current.yesterday.end_of_day.iso8601,
                                                         from: Time.current.ago(7.days).beginning_of_day.iso8601 })

      # 一週間分のコントリビューション数
      contributions = response.original_hash.dig('data', 'user', 'contributionsCollection', 'contributionCalendar',
                                                 'totalContributions')
      next if contributions.blank?

      # ユーザーデータの更新
      user.user_status.update!(week_contributions: contributions)
      user.user_status.week_contribution_histories.create!(week_contributions: contributions)
    end
  end

  desc '毎日、全ユーザーに経験値を付与する'
  task update_status: :environment do
    User.all.each do |user|
      # githubに対してgraphqlリクエストを送信
      response = GitHubClient::Client.query(Api::V1::GraphqlController::Query,
                                            variables: { name: user.github_uid,
                                                         to: Time.current.yesterday.end_of_day.iso8601,
                                                         from: Time.current.ago(30.days).beginning_of_day.iso8601 })

      # 一番古い日にちのコントリビューション数
      oldest_date_contributions = response.original_hash.dig('data', 'user', 'contributionsCollection', 'contributionCalendar',
                                                             'weeks', 0, 'contributionDays', 0, 'contributionCount')

      # 約１ヶ月分全てのコントリビューション数
      all_contributions = response.original_hash.dig('data', 'user', 'contributionsCollection', 'contributionCalendar',
                                                     'totalContributions')

      next if all_contributions.blank?

      # 経験値の計算
      experience_point_data = all_contributions - user.user_status.contribution_diff

      # 次回の経験値の計算の際、前日のコントリビューション数を保存するためのデータ
      temporal_contributions = all_contributions - oldest_date_contributions

      user.user_status.experience_histories.create!(earned_experience_points: experience_point_data)

      # 経験値が1以上の場合、経験値を加算する
      if experience_point_data.positive?

        # ユーザーデータから経験値を取得し、加算する
        experience_point_data += user.user_status.experience_points

        # ユーザーデータからlevelを取得
        level_data = user.user_status.level

        # 経験値が10以上の場合、レベルアップする
        experience_point_data_temp = experience_point_data % 10
        level_data += (experience_point_data / 10).ceil
        user.user_status.update!(level: level_data, contribution_diff: temporal_contributions,
                                 experience_points: experience_point_data_temp)
      else
        user.user_status.update!(contribution_diff: temporal_contributions)
      end
    end
  end
end
