class Comment < ApplicationRecord
  belongs_to :commentable, polymorphic: true
  belongs_to :user
  enum status: {pending: "pending",approved: "approved", super_admin_approved: "super_admin_approved"}
end
