require 'sidekiq-cron'

Sidekiq::Cron::Job.create(
  name: 'ApprovePendingComments',
  cron: '*/15 * * * *',  
  class: 'CommentApproverWorker'
)
