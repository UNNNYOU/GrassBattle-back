class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :name, null: false, default: 'GRASS BATTLE MEMBER'
      t.string :github_uid, null: false

      t.timestamps
    end
    add_index :users, :github_uid, unique: true
  end
end
