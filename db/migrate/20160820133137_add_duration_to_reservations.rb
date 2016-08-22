class AddDurationToReservations < ActiveRecord::Migration
  def change
    add_column :reservations, :duration, :datetime
  end
end
