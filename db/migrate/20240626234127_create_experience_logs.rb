class CreateExperienceLogs < ActiveRecord::Migration[7.0]
  def change
    create_table :experience_logs do |t|
      t.integer :earned_experience_points
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
