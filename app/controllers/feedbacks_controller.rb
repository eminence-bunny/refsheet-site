class FeedbacksController < ApplicationController
  def create
    @feedback = Feedback.new feedback_params

    if @feedback.save
      render json: @feedback
    else
      render json: { errors: @feedback.errors }, status: :bad_request
    end
  end

  private

  def feedback_params
    params.require(:feedback).permit(:name, :email, :comment, :source_url).
            merge(user: current_user, visit: current_visit)
  end
end
