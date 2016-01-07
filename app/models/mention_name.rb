class MentionName
  include ApplicationHelper

  attr_reader :current_user, :group

  delegate :users, to: :group
  def initialize(group, current_user)
    @group = group
    @current_user = current_user
  end

  def names_data
		user_names_hash.to_json.html_safe
	end

  private
  def user_names_hash
		users.map do |user|
			Hash[:name, first_word(user.name), :slug, user.slug, :full_name, user.name] unless user == current_user
		end.compact << group_hash
	end

	def group_hash
	  Hash[:name, "Group", :slug, "group", :full_name, group.name]
	end
end
