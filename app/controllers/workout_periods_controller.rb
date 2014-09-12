class WorkoutPeriodsController < ApplicationController
  ROOT_USER_ID = 1

  def show
    current_user = User.find(ROOT_USER_ID)

    workout_period = WorkoutPeriod.new(current_user, 3.months.ago)
    @workout_graph_data = workout_period.graph_data
  end
end
