class AddUserListTable < ActiveRecord::Migration[7.0]
  def change
    create_table :user_lists do |t|
      t.string :evaluation, default: 'neutral'
      t.boolean :wished, default: false
      t.references :user, null: false, foreign_key: true
      t.references :movie, null: false, foreign_key: true

      t.index %i[movie_id user_id], unique: true

      t.timestamps
    end
  end
end
