class CreatePlaces < ActiveRecord::Migration
  def change
    create_table :places do |t|
      t.string  :name
      t.text    :content
      t.string  :creator
      t.string  :location
      t.integer :open
      t.integer :close
      
      t.integer :likes
      t.string  :who_likes_it
      
      t.timestamps null: false
    end
  end
end
