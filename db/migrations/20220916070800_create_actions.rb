# frozen_string_literal: true
                                 
class CreateActions < ActiveRecord::Migration[6.0]
  def change
    create_table :actions do |t|
      t.bigint :user_id, foreign_key: true, null: false
      t.text :type
      t.float :quantity
      t.timestamps
    end
    add_foreign_key :actions, :users
  end
end
