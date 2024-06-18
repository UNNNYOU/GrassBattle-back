class Api::V1::GraphqlController < ApplicationController
  Query = GitHubClient::Client.parse <<~GRAPHQL
    query ($name: String!, $from: DateTime!, $to: DateTime!) {
      user(login: $name) {
        contributionsCollection(from: $from, to: $to) {
          contributionCalendar {
            totalContributions
            weeks {
              contributionDays {
                contributionCount
              }
            }
          }
        }
      }
    }
  GRAPHQL
end
