class AddWorkoutSets < ActiveRecord::Migration
  def change
    create_table :workout_sets do |t|
      t.integer :exercise_id
      t.integer :repetitions
      t.integer :weight
      t.integer :workout_id

      t.timestamps
    end
  end
end
