class SignupController < ApplicationController

  def register
    if(existing_user?)
      render json: {'error': 'Already existing user'}, status: :unprocessable_entity
    else
      if(existing_role?)
        @role_id = Role.find_by(role_name: params[:role]).id
        @user = User.new(sign_up_params.merge(:role_id => @role_id))
        if(@user.save)
          payload = { user_id: @user.id }
          token = JsonWebToken.encode(payload)
          response.set_header('Authorization', token)
          render json: @user
        else
          render json: @user.errors, status: :unprocessable_entity
        end
      else
        render json: {'error': 'Role does not exist'}, status: :unprocessable_entity
      end
    end
  end

  def sign_up_params
    params.permit(:user_name, :password, :password_confirmation, :user_email)
  end

  def existing_role?
    Role.exists?(role_name: params[:role])
  end

  def existing_user?
    User.exists?(user_email: params[:user_email])
  end

end
