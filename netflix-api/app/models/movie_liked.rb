# frozen_string_literal: true

class MovieLiked < ApplicationRecord
  belongs_to :user

  validates :name, :image, :movie_id, :genres, presence: true
end
