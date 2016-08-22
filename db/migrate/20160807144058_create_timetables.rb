class CreateTimetables < ActiveRecord::Migration
  def change
    create_table :timetables do |t|
      t.string    :mon_time_09, array: true
      t.string    :mon_time_10, array: true
      t.string    :mon_time_11, array: true
      t.string    :mon_time_12, array: true
      t.string    :mon_time_13, array: true
      t.string    :mon_time_14, array: true
      t.string    :mon_time_15, array: true
      t.string    :mon_time_16, array: true
      t.string    :mon_time_17, array: true
      t.string    :mon_time_18, array: true
      t.string    :mon_time_19, array: true
      t.string    :tue_time_09, array: true
      t.string    :tue_time_10, array: true
      t.string    :tue_time_11, array: true
      t.string    :tue_time_12, array: true
      t.string    :tue_time_13, array: true
      t.string    :tue_time_14, array: true
      t.string    :tue_time_15, array: true
      t.string    :tue_time_16, array: true
      t.string    :tue_time_17, array: true
      t.string    :tue_time_18, array: true
      t.string    :tue_time_19, array: true
      t.string    :wed_time_09, array: true
      t.string    :wed_time_10, array: true
      t.string    :wed_time_11, array: true
      t.string    :wed_time_12, array: true
      t.string    :wed_time_13, array: true
      t.string    :wed_time_14, array: true
      t.string    :wed_time_15, array: true
      t.string    :wed_time_16, array: true
      t.string    :wed_time_17, array: true
      t.string    :wed_time_18, array: true
      t.string    :wed_time_19, array: true
      t.string    :thu_time_09, array: true
      t.string    :thu_time_10, array: true
      t.string    :thu_time_11, array: true
      t.string    :thu_time_12, array: true
      t.string    :thu_time_13, array: true
      t.string    :thu_time_14, array: true
      t.string    :thu_time_15, array: true
      t.string    :thu_time_16, array: true
      t.string    :thu_time_17, array: true
      t.string    :thu_time_18, array: true
      t.string    :thu_time_19, array: true
      t.string    :fri_time_09, array: true
      t.string    :fri_time_10, array: true
      t.string    :fri_time_11, array: true
      t.string    :fri_time_12, array: true
      t.string    :fri_time_13, array: true
      t.string    :fri_time_14, array: true
      t.string    :fri_time_15, array: true
      t.string    :fri_time_16, array: true
      t.string    :fri_time_17, array: true
      t.string    :fri_time_18, array: true
      t.string    :fri_time_19, array: true
      
      t.integer     :user_id
      
      t.timestamps null: false
    end
  end
end
