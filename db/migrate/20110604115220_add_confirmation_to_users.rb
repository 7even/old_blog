class AddConfirmationToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :token, :string
    add_column :users, :confirmed, :boolean
  end
  
  def self.down
    remove_column :users, :confirmed
    remove_column :users, :token
  end
end
