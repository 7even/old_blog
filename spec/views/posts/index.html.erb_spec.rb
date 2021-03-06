require 'spec_helper'

describe "posts/index.html.erb" do
  before(:each) do
    admin = User.create! email: 'admin@7vn.ru',
                      password: 'secret',
                          name: 'admin',
                     confirmed: true,
                         admin: true
    controller.stub(:current_user).and_return(admin)
    
    @user = stub_model(User)
    assign(:posts, [
      stub_model(Post,
             title: 'Title',
           preview: 'MyText',
            author: @user,
        created_at: Date.new(2011, 3, 1)
      ),
      stub_model(Post,
             title: 'Title',
           preview: 'MyText',
            author: @user,
        created_at: Date.new(2011, 4, 16)
      )
    ])
    
    assign(:years, 2011 => [3, 4, 5])
  end
  
  it "renders a list of posts" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select 'article.post > header > h2', :text => "Title".to_s, :count => 2
    assert_select 'article.post > header > p > a', :text => @user.name
    assert_select 'article.post', :text => /MyText/, :count => 2
  end
end
