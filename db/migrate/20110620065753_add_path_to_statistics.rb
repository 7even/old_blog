class AddPathToStatistics < ActiveRecord::Migration
  def self.up
    add_column :statistics, :path, :string
  end
  
  def self.down
    remove_column :statistics, :path
  end
end
