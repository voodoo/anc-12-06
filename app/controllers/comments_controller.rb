class CommentsController < ApplicationController
  before_action :set_post

  def create
    @comment = @post.comments.build(comment_params)
    @comment.user = Current.user

    respond_to do |format|
      if @comment.save
        format.turbo_stream
        format.html { redirect_to @post, notice: 'Comment was successfully created.' }
      else
        format.html { redirect_to @post, alert: @comment.errors.full_messages.to_sentence }
        format.turbo_stream { 
          render turbo_stream: turbo_stream.update("flash", partial: "shared/flash", locals: { message: @comment.errors.full_messages.to_sentence, type: :error })
        }
      end
    end
  end

  private

  def set_post
    @post = Post.find(params[:post_id])
  end

  def comment_params
    params.require(:comment).permit(:content)
  end
end
