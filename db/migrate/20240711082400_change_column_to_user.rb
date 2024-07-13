class ChangeColumnToUser < ActiveRecord::Migration[7.0]
  def up
    change_column :users, :name, :string, null: false, default: 'MEMBER'
  end

  def down
    change_column :users, :name, :string, null: false, default: 'GRASS BATTLE MEMBER'
  end
end
