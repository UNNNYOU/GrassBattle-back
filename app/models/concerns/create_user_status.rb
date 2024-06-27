require 'github_client'

module CreateUserStatus
  def set_contributions(user)
    week_contribution_data = 0
    response = GitHubClient::Client.query(Api::V1::GraphqlController::Query,
                                          variables: { name: user.github_id,
                                                       to: Time.current.yesterday.end_of_day.iso8601,
                                                       from: Time.current.ago(7.days).beginning_of_day.iso8601 })
    contribution_week = response.original_hash.dig('data', 'user', 'contributionsCollection', 'contributionCalendar',
                                                   'weeks')

    return unless contribution_week.presence

    contribution_week.each do |contributions|
      contributions['contributionDays'].each do |day|
        week_contribution_data += day['contributionCount']
      end
    end
    user.user_status.update(week_contributions: week_contribution_data)
  end

  def set_experience_points(user)
    # ユーザーが登録した際にプロフィールを作成
    UserStatus.create!(user_id: user.id)


    # githubに対してgraphqlリクエストを送信
    response = GitHubClient::Client.query(Api::V1::GraphqlController::Query,
                                          variables: { name: user.github_id,
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
    return if all_contributions.blank?

    # 経験値の計算
    experience_point_data = latest_date_contributions

    # 次回の経験値の計算の際、前日のコントリビューション数を保存するためのデータ
    temporal_contributions = all_contributions - oldest_date_contributions

    # 経験値の保存
    user.user_status.experience_logs.create!(earned_experience_points: experience_point_data)

    # レベルの計算
    level_data = user.user_status.level

    # 経験値が10以上の場合、レベルアップする
    if experience_point_data >= 10
      experience_point_data %= 10
      level_data += (experience_point_data / 10).ceil
      user.user_status.update!(level: level_data, temporal_contribution_data: temporal_contributions,
                               experience_points: experience_point_data)
    else
      user.user_status.update!(temporal_contribution_data: temporal_contributions,
                               experience_points: experience_point_data)
    end
  end
end
