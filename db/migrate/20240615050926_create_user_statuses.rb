class CreateUserStatuses < ActiveRecord::Migration[7.0]
  def change
    create_table :user_statuses do |t|
      t.integer :level, default: 1, null: false
      t.integer :experience_points, default: 0, null: false
      t.integer :week_contributions, default: 0, null: false
      t.integer :contribution_diff, default: 0, null: false
      t.references :user, null: false, foreign_key: true
      t.timestamps
    end
  end
end
