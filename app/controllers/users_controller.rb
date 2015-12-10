class UsersController < ApplicationController
	before_action :set_user, only: [:edit, :update, :public_profile, :join_group, :destroy]
	before_action :authorize_read, only: [:update, :edit, :destroy]

	def show
		@user_show = User.friendly.find(params[:id])
		authorize! :read, @user_show
	end

	def public_profile
		authorize! :public_profile, @user
		@user = UserPublicProfile.new(@user, current_user, params[:page])
	end

	def edit
		respond_to do |format|
		  format.html
		  format.js
		end
	end

	def update
		if @user.update(user_params)
			redirect_to user_path(@user)
		else
			render :edit
		end
	end

	def new
		beta_code = BetaCode.find_by(auth_token: params[:code])
		return redirect_to root_path, notice: "Please sign up for the beta." unless beta_code && !beta_code.used

		@user = User.new

		respond_to do |format|
			format.html
			format.js
		end
	end

	def create
		@user = User.new(user_params)

		if @user.save
			BetaCode.find_by(auth_token: params[:code]).update_column(:used, true)
			log_in(@user)
			redirect_to user_path(@user)
		else
			render :new
		end
	end

	def join_group
	  if @user.under_group_limit?
	  	new_group = @user.find_or_create_group
			redirect_to group_path(new_group)
	  end
	end

	def destroy
		group = @user.degree_groups(1).take
		@user.destroy
		group.users_empty? ? group.destroy : group.check_space(@user)
		redirect_to new_survey_path(params: { email: @user.email })
	end

	private
	def set_user
		@user = User.friendly.find(params[:id])
	end

	def authorize_read
	  authorize! :read, @user
	end

	def user_params
		params.require(:user).permit(:name, :email, :address, :password, :password_confirmation, :address, :category, :age_group, :gender_group, :latitude, :longitude, :code, notification_settings: [:join, :proposal, :mention, :personal])
	end
end
