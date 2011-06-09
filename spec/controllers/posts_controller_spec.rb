# encoding: utf-8
require 'spec_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator.  If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails.  There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.
#
# Compared to earlier versions of this generator, there is very limited use of
# stubs and message expectations in this spec.  Stubs are only used when there
# is no simpler way to get a handle on the object needed for the example.
# Message expectations are only used when there is no simpler way to specify
# that an instance is receiving a specific message.

describe PostsController do
  # This should return the minimal set of attributes required to create a valid
  # Post. As you add validations to Post, be sure to
  # update the return value of this method accordingly.
  def valid_attributes
    author = stub_model(User)
    {title: 'Hello', body: 'world!', author: author}
  end
  
  def comment_attributes
    author = stub_model(User)
    {content: 'первонах', author: @confirmed_user}
  end
  
  shared_examples_for "restricted actions" do
    it "redirects to root_path with alert" do
      response.should redirect_to(root_path)
      flash[:alert].should == I18n.t('layout.access_restricted')
    end
  end
  
  before(:each) do
    @admin = User.create! email: 'admin@7vn.ru',
                       password: 'secret',
                           name: 'admin',
                      confirmed: true,
                          admin: true
    
    @confirmed_user = User.create! email: 'user@7vn.ru',
                                password: 'secret',
                                    name: 'user',
                               confirmed: true
  end
  
  def login_admin
    session[:user_id] = @admin.id
  end
  
  describe "GET index" do
    it "assigns all posts as @posts" do
      post = Post.create! valid_attributes
      get :index
      assigns(:posts).should eq([post])
    end
  end
  
  describe "GET show" do
    it "assigns the requested post as @post" do
      post = Post.create! valid_attributes
      get :show, id: post.id.to_s
      assigns(:post).should eq(post)
    end
  end
  
  describe "GET new" do
    context "by admin" do
      before(:each) do
        login_admin
      end
      
      it "assigns a new post as @post" do
        get :new
        assigns(:post).should be_a_new(Post)
      end
    end
    
    context "by user/guest" do
      before(:each) do
        get :new
      end
      
      it_behaves_like "restricted actions"
    end
  end
  
  describe "GET edit" do
    before(:each) do
      @post = Post.create! valid_attributes
    end
    
    context "by admin" do
      before(:each) do
        login_admin
      end
      
      it "assigns the requested post as @post" do
        get :edit, id: @post.id
        assigns(:post).should == @post
      end
    end
    
    context "by user/guest" do
      before(:each) do
        get :edit, id: @post.id
      end
      
      it_behaves_like "restricted actions"
    end
  end
  
  describe "POST create" do
    context "by admin" do
      before(:each) do
        login_admin
      end
      
      describe "with valid params" do
        it "creates a new Post" do
          expect {
            post :create, post: valid_attributes
          }.to change(Post, :count).by(1)
        end
        
        it "sets current_user as an author" do
          post :create, post: valid_attributes
          assigns(:post).author.should == @admin
        end
        
        it "assigns a newly created post as @post" do
          post :create, post: valid_attributes
          assigns(:post).should be_a(Post)
          assigns(:post).should be_persisted
        end
        
        it "redirects to the created post" do
          post :create, post: valid_attributes
          response.should redirect_to(Post.last)
        end
      end
      
      describe "with invalid params" do
        it "assigns a newly created but unsaved post as @post" do
          # Trigger the behavior that occurs when invalid params are submitted
          Post.any_instance.stub(:save).and_return(false)
          post :create, post: {}
          assigns(:post).should be_a_new(Post)
        end
        
        it "re-renders the 'new' template" do
          # Trigger the behavior that occurs when invalid params are submitted
          Post.any_instance.stub(:save).and_return(false)
          post :create, post: {}
          response.should render_template("new")
        end
      end
    end
    
    context "by user/guest" do
      before(:each) do
        post :create, post: valid_attributes
      end
      
      it_behaves_like "restricted actions"
    end
  end
  
  describe "POST create_comment" do
    before(:each) do
      @post = Post.create! valid_attributes
    end
    
    context "by admin/user" do
      before(:each) do
        session[:user_id] = @confirmed_user.id
      end
      
      context "without parent_id" do
        it "creates a root comment" do
          post :create_comment, id: @post.id, comment: comment_attributes
          Comment.last.parent.should be_nil
        end
      end
      
      context "with parent_id" do
        it "creates a child comment" do
          parent_comment = Comment.create! comment_attributes
          post :create_comment, id: @post.id, comment: comment_attributes.merge(parent_id: parent_comment.id)
          Comment.last.parent.should == parent_comment
        end
      end
    end
    
    context "by guest" do
      before(:each) do
        post :create_comment, id: @post.id, comment: comment_attributes
      end
      
      it_behaves_like "restricted actions"
    end
  end
  
  describe "DELETE destroy_comment" do
    before(:each) do
      @post = Post.create! valid_attributes
      @comment = Comment.create! comment_attributes.merge(author_id: @confirmed_user.id, post_id: @post.id)
    end
    
    context "by admin" do
      before(:each) do
        login_admin
      end
      
      it "deletes the comment" do
        expect {
          delete :destroy_comment, id: @comment.id
        }.to change { Comment.count }.by(-1)
      end
      
      it "redirects back to post with a notice" do
        delete :destroy_comment, id: @comment.id
        response.should redirect_to(@post)
        flash[:notice].should == I18n.t('posts.show.comment_deleted')
      end
    end
    
    context "by author" do
      before(:each) do
        session[:user_id] = @confirmed_user.id
      end
      
      it "deletes the comment" do
        expect {
          delete :destroy_comment, id: @comment.id
        }.to change { Comment.count }.by(-1)
      end
      
      it "redirects back to post with a notice" do
        delete :destroy_comment, id: @comment.id
        response.should redirect_to(@post)
        flash[:notice].should == I18n.t('posts.show.comment_deleted')
      end
    end
    
    context "by user/guest" do
      before(:each) do
        delete :destroy_comment, id: @comment.id
      end
      
      it_behaves_like "restricted actions"
    end
  end
  
  describe "PUT update" do
    context "by admin" do
      before(:each) do
        login_admin
      end
      
      describe "with valid params" do
        it "updates the requested post" do
          post = Post.create! valid_attributes
          # Assuming there are no other posts in the database, this
          # specifies that the Post created on the previous line
          # receives the :update_attributes message with whatever params are
          # submitted in the request.
          Post.any_instance.should_receive(:update_attributes).with({'these' => 'params'})
          put :update, id: post.id, post: {'these' => 'params'}
        end
        
        it "assigns the requested post as @post" do
          post = Post.create! valid_attributes
          put :update, id: post.id, post: valid_attributes
          assigns(:post).should eq(post)
        end
        
        it "redirects to the post" do
          post = Post.create! valid_attributes
          put :update, id: post.id, post: valid_attributes
          response.should redirect_to(post)
        end
      end
      
      describe "with invalid params" do
        it "assigns the post as @post" do
          post = Post.create! valid_attributes
          # Trigger the behavior that occurs when invalid params are submitted
          Post.any_instance.stub(:save).and_return(false)
          put :update, id: post.id, post: {}
          assigns(:post).should eq(post)
        end
        
        it "re-renders the 'edit' template" do
          post = Post.create! valid_attributes
          # Trigger the behavior that occurs when invalid params are submitted
          Post.any_instance.stub(:save).and_return(false)
          put :update, id: post.id, post: {}
          response.should render_template("edit")
        end
      end
    end
    
    context "by user/guest" do
      before(:each) do
        post = Post.create! valid_attributes
        put :update, id: post.id, post: valid_attributes
      end
      
      it_behaves_like "restricted actions"
    end
  end
  
  describe "DELETE destroy" do
    context "by admin" do
      before(:each) do
        login_admin
      end
      
      it "destroys the requested post" do
        post = Post.create! valid_attributes
        expect {
          delete :destroy, id: post.id
        }.to change(Post, :count).by(-1)
      end
      
      it "redirects to the posts list" do
        post = Post.create! valid_attributes
        delete :destroy, id: post.id
        response.should redirect_to(posts_url)
      end
    end
    
    context "by user/guest" do
      before(:each) do
        post = Post.create! valid_attributes
        delete :destroy, id: post.id
      end
      
      it_behaves_like "restricted actions"
    end
  end
end
