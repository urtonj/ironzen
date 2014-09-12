class Workout < ActiveRecord::Base
  has_many :workout_sets
  has_many :exercises, through: :workout_sets
end
