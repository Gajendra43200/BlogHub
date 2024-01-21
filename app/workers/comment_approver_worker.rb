class CommentApproverWorker
    include Sidekiq::Worker
  
    def perform
      Comment.where(status: 'approved').update_all(status: 'super_admin_approved')
    end
  end