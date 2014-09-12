class WorkoutPeriod
  GRAPH_DATE_FORMAT = '%m/%d/%y'

  def initialize user, since_date
    @user = user
    @since_date = since_date
  end

  def graph_data
    graph_data = [graph_header_row]

    workouts.each do |workout|
      graph_data << graph_row_for_workout(workout)
    end

    graph_data
  end

  private

  def graph_header_row
    exercises.inject(['Date']) { |header_row, exercise| header_row << exercise.name }
  end

  def graph_row_for_exercise_sets exercise_sets
    if exercise_sets
      total_weight = exercise_sets.collect { |set| set.repetitions * set.weight }.sum
      total_repetitions = exercise_sets.to_a.sum(&:repetitions)
      total_weight.to_f / total_repetitions.to_f
    end
  end

  def graph_row_for_workout workout
    graph_row = [workout.date.strftime(GRAPH_DATE_FORMAT)]

    exercises.each do |exercise|
      exercise_sets = workout.workout_sets.where(exercise_id: exercise)
      graph_row << graph_row_for_exercise_sets(exercise_sets)
    end

    graph_row
  end

  def exercises
    @exercises ||= workouts.collect { |workout| workout.exercises }.flatten.uniq
  end

  def workouts
    @workouts ||= Workout.joins(workout_sets: :exercise).where('date >= ?', @since_date)
  end
end