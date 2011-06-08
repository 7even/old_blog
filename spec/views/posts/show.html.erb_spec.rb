require 'spec_helper'

describe "posts/show.html.erb" do
  before(:each) do
    admin = User.create! email: 'admin@7vn.ru',
                      password: 'secret',
                          name: 'admin',
                     confirmed: true,
                         admin: true
    controller.stub(:current_user).and_return(admin)
    
    @user = stub_model(User)
    assign(:post, stub_model(Post,
           title: "Title",
            body: "MyText",
          author: @user,
      created_at: Date.new(2011, 4, 16)
    ))
  end
  
  it "renders attributes" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Title/)
    rendered.should match(/MyText/)
    assert_select 'article > header > p > a', :text => @user.name
  end
end
