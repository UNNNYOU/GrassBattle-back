require 'github_client'

module CreateUserStatus
  def set_contributions(user)
    week_contribution_data = 0
    response = GitHubClient::Client.query(Api::V1::GraphqlController::Query,
                                          variables: { name: user.github_uid,
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
    user.user_status.week_contribution_histories.create!(week_contributions: week_contribution_data)
  end

  def set_experience_points(user)
    UserStatus.create!(user_id: user.id)

    response = GitHubClient::Client.query(Api::V1::GraphqlController::Query,
                                          variables: { name: user.github_uid,
                                                       to: Time.current.yesterday.end_of_day.iso8601,
                                                       from: Time.current.ago(30.days).beginning_of_day.iso8601 })

    latest_date_contributions = response.original_hash.dig('data', 'user', 'contributionsCollection',
                                                           'contributionCalendar', 'weeks', -1, 'contributionDays', -1, 'contributionCount')

    oldest_date_contributions = response.original_hash.dig('data', 'user', 'contributionsCollection', 'contributionCalendar',
                                                           'weeks', 0, 'contributionDays', 0, 'contributionCount')

    all_contributions = response.original_hash.dig('data', 'user', 'contributionsCollection', 'contributionCalendar',
                                                   'totalContributions')

    return if all_contributions.blank?

    experience_point_data = latest_date_contributions

    temporal_contributions = all_contributions - oldest_date_contributions

    user.user_status.experience_histories.create!(earned_experience_points: experience_point_data)

    level_data = user.user_status.level

    if experience_point_data >= 10
      experience_point_data %= 10
      level_data += (experience_point_data / 10).ceil
      user.user_status.update!(level: level_data, contribution_diff: temporal_contributions,
                               experience_points: experience_point_data)
    else
      user.user_status.update!(contribution_diff: temporal_contributions,
                               experience_points: experience_point_data)
    end
  end
end
