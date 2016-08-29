class CreateGroups < ActiveRecord::Migration
  def change
    create_table :groups do |t|
      t.string  :school
      t.string  :name
      t.text    :content
      t.integer :member
      t.text    :affiliation
      t.string  :creator
      
      t.timestamps null: false
    end
  end
end
