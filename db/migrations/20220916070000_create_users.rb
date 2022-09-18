# frozen_string_literal: true
                                 
class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.bigint :user_id, null: false
      t.text :username
      t.text :first_name
      t.text :last_name
      t.timestamps
    end
    add_index(:users, :user_id, unique: true)
  end
end
