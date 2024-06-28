class CreateExperienceHistories < ActiveRecord::Migration[7.0]
  def change
    create_table :experience_histories do |t|
      t.references :user_status, null: false, foreign_key: true
      t.integer :earned_experience_points, null: false, default: 0

      t.timestamps
    end
  end
end
