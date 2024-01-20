class Author < ApplicationRecord
    has_many :blogs, dependent: :destroy
    has_many :comments, as: :commentable
end
