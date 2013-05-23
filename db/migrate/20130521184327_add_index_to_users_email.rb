class AddIndexToUsersEmail < ActiveRecord::Migration
  def change
  	add_index :users, :email, unique: true
  end
end

#Rails method called add_index adds an index on the email column of the users table. The index by itself doesn’t enforce uniqueness, but the option unique: true does.
