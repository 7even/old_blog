class GeneratePreviewForAllPosts < ActiveRecord::Migration
  def self.up
    Post.all.each(&:save)
  end
  
  def self.down
    # irreversible migration
  end
end
