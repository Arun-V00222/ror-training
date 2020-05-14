class UserController < ApplicationController

  def login
    if(User.current_user)
      render json: {'message': 'Valid User'}, status: :ok
    else
      render json: {'error': 'Not Authenticated'}, status: :unprocessable_entity
    end
  end

  def update_password
    if(params[:password] == params[:password_confirmation])
      begin
        if (User.update_password = params[:password])
          @user = User.current_user
          payload = { user_id: @user.id }
          token = JsonWebToken.encode(payload)
          response.set_header('Authorization', token)
          render json: {'message': 'Password Updated successfully'}, status: :ok
        else
          render json: {'error': 'Unable to update password at the moment. Please try again later.'}, status: :unprocessable_entity
        end
      rescue
        render json: {'error': 'Password Validation checks failed'}, status: :unprocessable_entity
      end
    else
      render json: {'error': 'Passwords did not match'}, status: :unprocessable_entity
    end
  end

end
