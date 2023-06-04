class PostsController < ApplicationController
  def index
    @posts = Post.all

    # alternative responses to requests other than HTML
    respond_to do |format|
      format.html # implicitly renders posts/index.html.erb
      format.json do
        render :json => @posts
      end
    end
  end

  def new
    @post = Post.new
  end

  def create
    if @current_user
      @post = Post.new
      @post["body"] = params["post"]["body"]
      @post.uploaded_image.attach(params["post"]["uploaded_image"])
      @post["user_id"] = @current_user["id"]
      @post.save
    else
      flash["notice"] = "Login first."
    end
    redirect_to "/posts"
  end

  # removes security restrictions for API calls
  before_action :allow_cors
  def allow_cors
    response.headers['Access-Control-Allow-Origin'] = '*'
    response.headers['Access-Control-Allow-Methods'] = 'POST, GET, PUT, PATCH, DELETE, OPTIONS'
    response.headers['Access-Control-Allow-Headers'] = 'Origin, Content-Type, Accept, Authorization, Token, Auth-Token, Email, X-User-Token, X-User-Email'
    response.headers['Access-Control-Max-Age'] = '1728000'
  end
end