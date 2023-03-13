# frozen_string_literal: true

require 'bcrypt'

class User < ApplicationRecord
  include BCrypt
  include ActiveModel::SecurePassword

  has_many :user_lists, class_name: 'UserList'

  has_secure_password

  validates :email, :password_digest, presence: true
end
