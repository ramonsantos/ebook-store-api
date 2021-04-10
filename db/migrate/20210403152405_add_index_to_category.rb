class AddIndexToCategory < ActiveRecord::Migration[6.1]
  def change
    add_index :categories, :code, unique: true
    add_index :categories, :name, unique: true
  end
end
