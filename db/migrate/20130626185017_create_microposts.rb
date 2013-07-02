class CreateMicroposts < ActiveRecord::Migration
  def change
    create_table :microposts do |t|
      t.string :content
      t.integer :user_id

      t.timestamps
    end
    #arrange for Rails to create a multiple key index, which means that Active Record uses both keys at the same time. 
    add_index :microposts, [:user_id, :created_at]
  end
end
