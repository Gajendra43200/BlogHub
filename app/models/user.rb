class User < ApplicationRecord
    validates :type, inclusion: { in: %w[User Admin SuperAdmin] }
    enum status: { block: "block", unblock: "unblock"}
    has_many :comments,  dependent: :destroy
    # validates_format_of :phone, with: /\A91\d{10}\z/, message: "should start with '91' and have 10 digits"
end
