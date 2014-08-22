class User < ActiveRecord::Base
  has_many :workouts
  has_many :workout_sets, through: :workouts
end
