class CommentsController < ApplicationController
  before_action :require_authentication

  def create
    @post = Post.find(params[:post_id])
    @comment = @post.comments.build(comment_params)
    @comment.user = Current.user

    respond_to do |format|
      if @comment.save
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.prepend("#{dom_id(@post)}_comments", partial: "comments/comment", locals: { comment: @comment }),
            turbo_stream.update("#{dom_id(@post)}_comment_count", "Comments (#{@post.comments.count})"),
            turbo_stream.update("flash", partial: "shared/flash", locals: { flash: { notice: "Comment posted successfully" } })
          ]
        end
        format.html { redirect_to @post, notice: "Comment posted successfully" }
      else
        format.turbo_stream do
          render turbo_stream: turbo_stream.update("flash", 
            partial: "shared/flash", 
            locals: { flash: { alert: @comment.errors.full_messages.to_sentence } }
          )
        end
        format.html { redirect_to @post, alert: @comment.errors.full_messages.to_sentence }
      end
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:content)
  end
end
