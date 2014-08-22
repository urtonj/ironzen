class Workout < ActiveRecord::Base
  has_many :workout_sets
  has_many :exercises, through: :workout_sets

  def self.exercise_types_from_workouts(workouts)
    workouts.collect { |workout| workout.exercises }.flatten.uniq
  end

  def self.graph_data_for_user_since_date user, since_date
    workouts = Workout.joins(workout_sets: :exercise).where('date >= ?', since_date)
    exercises = Workout.exercise_types_from_workouts(workouts)

    graph_data = []
    graph_data << Workout.graph_header_row(exercises)

    workouts.each do |workout|
      graph_row = [workout.date.strftime("%m/%d/%y")]

      exercises.each do |exercise|
        exercise_sets = workout.workout_sets.where(exercise_id: exercise)
        graph_row << Workout.graph_row_for_exercise_sets(exercise_sets)
      end

      graph_data << graph_row
    end

    graph_data
  end

  def self.graph_header_row exercises
    exercises.inject(['Date']) { |header_row, exercise| header_row << exercise.name }
  end

  def self.graph_row_for_exercise_sets exercise_sets
    if exercise_sets
      total_weight = exercise_sets.collect { |set| set.repetitions * set.weight }.sum
      total_repetitions = exercise_sets.to_a.sum(&:repetitions)
      (total_weight.to_f / total_repetitions.to_f)
    else
      ''
    end
  end
end
