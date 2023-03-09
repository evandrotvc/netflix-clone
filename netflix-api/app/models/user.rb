# frozen_string_literal: true

require 'bcrypt'

class User < ApplicationRecord
  include BCrypt
  include ActiveModel::SecurePassword

  has_many :movie_likeds

  has_secure_password

  validates :email, :password_digest, presence: true
end
