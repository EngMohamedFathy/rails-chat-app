class ApplicationController < ActionController::API

  # for success response API
  def json_response_success(message,data,status_code= :ok)
     { json: {status: 'SUCCESS', message: message, data:data}, status: status_code }
  end

  # for error response API
  def json_response_error(message,data,status_code= :unprocessable_entity)
     { json: {status: 'Error', message: message, data:data}, status: status_code }
  end
end
