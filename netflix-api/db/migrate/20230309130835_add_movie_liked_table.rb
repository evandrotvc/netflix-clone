class AddMovieLikedTable < ActiveRecord::Migration[7.0]
  def change
    create_table :movie_likeds do |t|
      t.string :name, null: false
      t.string :image, null: false
      t.string :movie_id, null: false
      t.string :genres, null: false
      t.references :user, null: false, foreign_key: true, index: { unique: true }
      t.timestamps
    end
  end
end
