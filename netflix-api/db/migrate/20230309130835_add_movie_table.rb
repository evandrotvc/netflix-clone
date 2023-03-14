class AddMovieTable < ActiveRecord::Migration[7.0]
  def change
    create_table :movies do |t|
      t.string :name, null: false, unique: true
      t.string :image, null: false
      t.string :movie_id, null: false
      t.string :genres, null: false
      # t.references :user, null: false, foreign_key: true
      # t.index %i[movie_id user_id], unique: true

      t.timestamps
    end
  end
end
