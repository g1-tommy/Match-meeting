class CreateReservations < ActiveRecord::Migration
  def change
    create_table :reservations do |t|
      t.integer :place_id
      t.integer :group_id
      t.datetime :schedule
      t.integer :confirm, default: "0"  #wait:0, confirm:1

      t.timestamps null: false
    end
  end
end
