class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.string :name
      t.integer :number
      t.integer :priority
      t.integer :last_user
      t.belongs_to :group

      t.timestamps
    end
    
    create_table :items_users, id: false do |t|
      t.belongs_to :item
      t.belongs_to :user
    end
  end
end
