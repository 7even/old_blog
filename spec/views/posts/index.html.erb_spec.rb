require 'spec_helper'

describe "posts/index.html.erb" do
  before(:each) do
    assign(:posts, [
      stub_model(Post,
        :title      => 'Title',
        :body       => 'MyText',
        :created_at => Date.new(2011, 3, 1)
      ),
      stub_model(Post,
        :title      => 'Title',
        :body       => 'MyText',
        :created_at => Date.new(2011, 4, 16)
      )
    ])
  end
  
  it "renders a list of posts" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "article.post>header>h2", :text => "Title".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "article.post", :text => /MyText/, :count => 2
  end
end
