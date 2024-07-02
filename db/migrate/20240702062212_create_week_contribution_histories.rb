class CreateWeekContributionHistories < ActiveRecord::Migration[7.0]
  def change
    create_table :week_contribution_histories do |t|
      t.references :user_status, null: false, foreign_key: true
      t.integer :week_contribution, null: false, default: 0

      t.timestamps
    end
  end
end
