class CreateReservations < ActiveRecord::Migration
  def change
    create_table :reservations do |t|
      t.integer :place_id
      t.integer :group_id
      t.datetime :schedule

      t.timestamps null: false
    end
  end
end
