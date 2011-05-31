class CreateComments < ActiveRecord::Migration
  def self.up
    create_table :comments do |t|
      t.text :content
      t.string :ancestry
      t.references :post
      
      t.timestamps
    end
    
    add_index :comments, :ancestry
  end
  
  def self.down
    drop_table :comments
  end
end
