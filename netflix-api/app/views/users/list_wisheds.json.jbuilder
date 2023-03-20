# frozen_string_literal: true

json.movies @lists do |list|
    json.movie list.movie
    json.extract! list, :wished, :evaluation
end