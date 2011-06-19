require 'spec_helper'

describe Post do
  it { should validate_presence_of(:title).with_message   error_for(:post, :title) }
  it { should validate_presence_of(:body).with_message    error_for(:post, :body) }
  
  describe ".create" do
    context "with a cut" do
      it "creates a preview equal to first part of the body" do
        post = Post.create do |p|
          p.title = 'title'
          p.body  = 'preview<cut>body'
        end
        
        post.body.should    == 'preview<cut>body'
        post.preview.should == 'preview'
      end
    end
    
    context "without a cut" do
      it "creates a preview equal to the full body" do
        post = Post.create do |p|
          p.title = 'title'
          p.body  = 'just body'
        end
        
        post.body.should    == 'just body'
        post.preview.should == post.body
      end
    end
  end
  
  describe ".update_attributes" do
    context "changing just a title" do
      it "doesn't touch the preview" do
        post = Post.create(title: 'title', body: 'preview<cut>body')
        
        expect {
          post.update_attributes(title: 'another title')
        }.not_to change { post.preview }
      end
    end
  end
end
