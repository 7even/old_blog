class PostsController < ApplicationController
  authorize_resource :except => [:create_comment, :destroy_comment, :archive, :full_archive]
  
  # GET /posts
  # GET /posts.xml
  def index
    @posts = Post.order('id DESC')
    @years = Post.archive_monthes
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @posts }
    end
  end
  
  def archive
    @posts = Post.created_on(params[:year], params[:month])
    @years = Post.archive_monthes
    authorize! :read, Post
    
    render 'index'
  end
  
  def full_archive
    @years = Post.archive_monthes
    authorize! :read, Post
  end
  
  # GET /posts/1
  # GET /posts/1.xml
  def show
    @post = Post.find(params[:id])
    
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @post }
    end
  end
  
  def create_comment
    authorize! :create, Comment
    @post = Post.find(params[:id])
    comment = Comment.create params[:comment].merge(author: current_user)
    @post.comments << comment
    redirect_to @post
  end
  
  def destroy_comment
    @comment = Comment.find(params[:id])
    authorize! :delete, @comment
    post = @comment.post
    @comment.destroy
    redirect_to post, notice: t('posts.show.comment_deleted')
  end
  
  # GET /posts/new
  # GET /posts/new.xml
  def new
    @post = Post.new
    
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @post }
    end
  end
  
  # GET /posts/1/edit
  def edit
    @post = Post.find(params[:id])
  end
  
  # POST /posts
  # POST /posts.xml
  def create
    @post = Post.new params[:post].merge(:author => current_user)
    
    respond_to do |format|
      if @post.save
        format.html { redirect_to(@post, :notice => t('posts.show.post_created')) }
        format.xml  { render :xml => @post, :status => :created, :location => @post }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @post.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  # PUT /posts/1
  # PUT /posts/1.xml
  def update
    @post = Post.find(params[:id])
    
    respond_to do |format|
      if @post.update_attributes(params[:post])
        format.html { redirect_to(@post, :notice => t('posts.show.post_updated')) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @post.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  # DELETE /posts/1
  # DELETE /posts/1.xml
  def destroy
    @post = Post.find(params[:id])
    @post.destroy
    
    respond_to do |format|
      format.html { redirect_to(posts_url, notice: t('posts.index.post_deleted')) }
      format.xml  { head :ok }
    end
  end
end
