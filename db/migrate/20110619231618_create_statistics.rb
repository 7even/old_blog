class CreateStatistics < ActiveRecord::Migration
  def self.up
    create_table :statistics do |t|
      t.integer :page_id
      t.integer :resource_id
      t.string :ip
      t.string :useragent
      t.string :referrer
      t.references :user
      
      t.timestamps
    end
  end
  
  def self.down
    drop_table :statistics
  end
end
