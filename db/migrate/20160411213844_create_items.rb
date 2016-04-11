class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.string :description
      t.string :name
      t.integer :collection_id
      t.string :picture 
      t.boolean :collected
      t.timestamps null: false
    end
  end
end
