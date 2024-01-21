class UpdateCommentJob < ApplicationJob
  queue_as :default
  def perform(comment_params,current_user, commentable)
    @comment = current_user.comments.build(comment_params)
    @comment.commentable = commentable
    begin
      @comment.save!
    rescue ActiveRecord::RecordInvalid => e
      Rails.logger.error("Failed to save comment: #{e.message}") 
    end
  end
end
