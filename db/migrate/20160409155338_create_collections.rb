class CreateCollections < ActiveRecord::Migration
  def change
    create_table :collections do |t|
      t.string :description
      t.string :name
      t.integer :user_id
      t.timestamps null: false
    end
  end
end
