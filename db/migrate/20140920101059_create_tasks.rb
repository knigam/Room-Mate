class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.string :name
      t.integer :priority
      t.integer :num_users
      t.belongs_to :group

      t.timestamps
    end
    
    create_table :tasks_users, id: false do |t|
      t.belongs_to :task
      t.belongs_to :user
    end
  end
end
