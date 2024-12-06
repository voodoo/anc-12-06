class PostsController < ApplicationController
  #before_action :authenticate_user!, except: [:index, :show]
  #allow_unauthenticated_access only: [:index, :show]
  before_action :set_post, except: [:index, :new, :create]

  def index
    @posts = Post.left_joins(:votes)
                 .select('posts.*, COUNT(votes.id) as vote_count')
                 .group('posts.id')
                 .order('vote_count DESC, posts.created_at DESC')
                 .includes(:user)
  end

  def show
  end

  def new
    @post = Post.new
  end

  def create
    @post = Current.user.posts.build(post_params)

    if @post.save
      respond_to do |format|
        format.html { redirect_to @post, notice: 'Post was successfully created.' }
        #format.turbo_stream { flash.now[:notice] = 'Post was successfully created.' }
      end
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def set_post
    @post = Post.find(params[:id])
  end

  def post_params
    params.require(:post).permit(:title, :content)
  end
end
