class UsersController < ApplicationController
    rescue_from ActiveRecord::RecordInvalid, with: :render_unprocessable_entity

    def create 
        user = User.create!(user_params)
        session[:user_id] = user.id
        render json: user, status: :created   
    end

    def show
        if session[:user_id] == nil
            render json: { error: "No current session stored"}, status: :unauthorized
        else
            user = User.find(session[:user_id])
            if user 
                render json: user, status: :ok
            else
                render json: { error: "No current session stored"}, status: :unauthorized    
            end
        end    
    end

    private

    def user_params
        params.permit(:username, :password, :password_confirmation)
    end

    def render_unprocessable_entity(invalid)
        render json: { error: invalid.record.errors.full_messages}, status: :unprocessable_entity 
    end

end
