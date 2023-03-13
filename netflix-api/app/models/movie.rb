# frozen_string_literal: true

class Movie < ApplicationRecord
  has_many :user_lists, class_name: 'UserList'

  validates :name, :image, :movie_id, :genres, presence: true
end
