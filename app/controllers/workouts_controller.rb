class WorkoutsController < ActionController::Base
  ROOT_USER_ID = 1

  def index
    current_user = User.find(ROOT_USER_ID)

    @workout_graph_data = Workout.graph_data_for_user_since_date(current_user, 1.month.ago)
  end
end
