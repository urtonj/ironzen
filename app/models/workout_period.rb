class WorkoutPeriod
  GRAPH_DATE_FORMAT = '%m/%d/%y'

  def initialize user, since_date
    @user = user
    @since_date = since_date
  end

  def graph_data
    graph_data = []

    workouts.each do |workout|
      graph_data << graph_row_for_workout(workout)
    end

    graph_data.sort_by! { |row| row[0] }
    graph_data.insert(0, graph_header_row)
  end

  private

  def graph_header_row
    exercises.inject(['Date']) { |header_row, exercise| header_row << exercise.name }
  end

  def graph_row_for_exercise_sets exercise_sets
    if exercise_sets
      weights = exercise_sets.collect(&:weight)
      weights.sum.to_f / weights.count.to_f
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
    @workouts ||= Workout.joins(workout_sets: :exercise).where('date >= ?', @since_date).uniq
  end
end