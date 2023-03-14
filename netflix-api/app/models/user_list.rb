# frozen_string_literal: true

class UserList < ApplicationRecord
  belongs_to :user
  belongs_to :movie

  enum evaluation: {
    neutral: 'neutral', like: 'like',
    dislike: 'dislike'
  }

  validates :evaluation, presence: true

end
