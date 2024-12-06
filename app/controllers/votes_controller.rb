class VotesController < ApplicationController
  before_action :set_post
  include ActionView::RecordIdentifier

  def create
    @vote = Current.user.votes.build(post: @post)

    if @vote.save
      respond_to do |format|
        format.html { redirect_to @post }
        format.turbo_stream { render turbo_stream: turbo_stream.replace("#{dom_id(@post)}_votes", partial: "posts/vote_buttons", locals: { post: @post }) }
      end
    else
      redirect_to @post, alert: @vote.errors.full_messages.to_sentence
    end
  end

  def destroy
    @vote = Current.user.votes.find_by!(post: @post)
    @vote.destroy

    respond_to do |format|
      format.html { redirect_to @post }
      format.turbo_stream { render turbo_stream: turbo_stream.replace("#{dom_id(@post)}_votes", partial: "posts/vote_buttons", locals: { post: @post }) }
    end
  end

  private

  def set_post
    @post = Post.find(params[:post_id])
  end
end
