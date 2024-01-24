class User < ApplicationRecord
    validates :name, :password_digest, presence: true
    validates :email, presence: true, format: { with: /\A[^@\s]+@[^@\s]+\z/, message: 'Invalid email' }
    validates :phone, presence: true, format: { with: /\A\+91\d{10}\z/, message: 'Invalid phone no. start with +91 after that 10 digit only' }
    validates :type, inclusion: { in: %w[User Admin SuperAdmin] }
    enum status: { block: "block", unblock: "unblock"}
    has_many :comments,  dependent: :destroy
end
