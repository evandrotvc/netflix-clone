# frozen_string_literal: true

require 'bcrypt'

class User < ApplicationRecord
  include BCrypt

  validates :email, :password_digest, presence: true

  def password
    @password ||= Password.new(password_hash)
  end

  def password=(new_password)
    @password = Password.create(new_password)
    self.password_digest = @password
  end
end
