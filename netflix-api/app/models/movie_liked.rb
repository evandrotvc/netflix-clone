# frozen_string_literal: true

class MovieLiked < ApplicationRecord
  belongs_to :user

  validates :name, :image_url, :movie_id, :genres, presence: true
end
