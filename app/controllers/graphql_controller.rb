class GraphqlController < ApplicationController
  include GraphqlHelper

  skip_before_action :verify_authenticity_token

  if Rails.env.development?
    rescue_from Exception do |e|
      Rails.logger.error(e)

      render json: {
          error: e.message,
          backtrace: e.backtrace
      }, status: :internal_server_error
    end
  end

  def execute
    variables = ensure_hash(params[:variables])
    query = params[:query]
    operation_name = params[:operationName]

    context = {
      current_user: method(:current_user),
      current_user_id: method(:current_user_id),
      sign_out: method(:sign_out),
      sign_in: method(:sign_in),
      session: method(:session),
      cookies: method(:cookies)
    }

    result = nil

    if defined? Google
      Google::Cloud::Trace.in_span(operation_name) do |_span|
        result = RefsheetSchema.execute(query,
                                        variables: variables,
                                        context: context,
                                        operation_name: operation_name)
      end
    else
      result = RefsheetSchema.execute(query,
                                      variables: variables,
                                      context: context,
                                      operation_name: operation_name)
    end

    # Rails.logger.debug("Result: #{result.to_json}")

    render json: result
  end
end
