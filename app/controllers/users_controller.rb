class UsersController < ApplicationController
	def new
		@user = User.new
	end

	def create
		password_confirmation = user_params[:password]
	  @user = User.new(user_params.merge(provider: "email", password_confirmation: password_confirmation))

		if @user.save
			log_in(@user)
			redirect_to verify_email_users_path
		else
			render :new
		end
	end

	def show
		@user_show = current_user
		return redirect_to get_started_path unless current_user
		return redirect_to complete_sign_up_users_path unless current_user.sign_up_complete?
	end

	def personal_messages
		user = User.friendly.find(params[:id])
		authorize! :personal_messages, user
		@user = UserPersonalMessageShow.new(user, current_user, params[:page])
	end

	def edit
		respond_to do |format|
		  format.html
		  format.js
		end
	end

	def complete_sign_up
		return redirect_to(verify_email_users_path) if current_user.email_needs_verification?
		authorize! :read, current_user
	end

	def verify_email
		return redirect_to root_path if current_user.sign_up_complete?
	end

	def email_confirmed
		@user = User.friendly.find(params[:id])

		if @user.password_reset_token == params[:code]
			log_in(@user)
			@user.update_column(:email_verified, true)
			redirect_to complete_sign_up_users_path, notice: "Thanks. Your email address has been confirmed. You can now finish signing up."
		else
			redirect_to root_path
		end
	end

	def update_email
	  if UpdateEmail.new(current_user, new_email_params[:email]).update
			redirect_to verify_email_users_path, notice: "We sent you an email."
		else
			render :verify_email
		end
	end

	def update
		sign_up_complete = current_user.sign_up_complete?

		if current_user.update(user_params)
			flash[:welcome] = current_user.sign_up_complete? != sign_up_complete
			redirect_to root_path
		elsif current_user.sign_up_complete?
			render :edit
		else
			render :complete_sign_up
		end
	end

	def join_group
	  if current_user.under_group_limit?
	  	new_group = FindGroup.new(current_user).find_or_create
			redirect_to group_path(new_group)
	  end
	end

	def destroy
		group = current_user.degree_groups(1).take
		current_user.destroy
		if group
			group.users_empty? ? group.destroy : Groups::GroupSpaceCheck.new(group, current_user).check_space
		end
		redirect_to new_survey_path(params: { email: current_user.email })
	end

	private
	def new_email_params
	  params.require(:user).permit(:email)
	end

	def user_params
		params.require(:user).permit(:name, :address, :email, :password, :category, :age_group, :latitude, :longitude, :sign_up_complete, notification_settings: [:proposal, :mention, :personal, :expand])
	end
end
