class Group < ActiveRecord::Base
	extend FriendlyId
	include Sluggable
	friendly_id :slug_candidates, use: :slugged

	has_many :user_groups
	has_many :users, through: :user_groups, after_add: [:check_space, :join_group_notifications], after_remove: :check_space
	has_many :messages, as: :messageable
	has_many :topics
	has_many :notifications, as: :notifiable
	has_many :activities
	has_many :drop_user_votes
	has_many :expand_group_votes

	reverse_geocoded_by :latitude, :longitude

	after_create :create_general_topic

	delegate :size, to: :expand_group_votes, prefix: true
	delegate :attended_activities_count, :future_activities, to: :activities
	delegate :count, :empty?, to: :users, prefix: true
	delegate :ids, to: :topics, prefix: true

	scope :open_groups, -> { where(can_join: true) }
	scope :category_groups, ->(category) { where(category: category) }
	scope :non_former_groups, ->(group_ids) { where.not(id: group_ids) }
	scope :same_age, ->(age_group) { where(age_group: age_group) }
	scope :degree_groups, ->(degree) { where(degree: degree) }
	scope :ready_groups, -> { where(ready_to_expand: true) }

	def self.search(params)
		self.open_groups.category_groups(params[:category]).same_age(params[:age_group]).degree_groups(1).near([params[:latitude], params[:longitude]], 0.5).non_former_groups(params[:group_ids])[0]
	end

	def check_space(user)
		if users_count == user_limit - 1 && self.can_join != true
			self.can_join = true
			save
		elsif users_count == user_limit && self.can_join != false
			self.can_join = false
			save
		end
	end

	def drop_user(user)
		users.delete(user)
		user.add_dropped_group(id)

		user.votes_to_drop_delete_all
		user.dismiss_all_notifications
		self.delete if users_empty?
	end

	def kick_user(user)
		drop_user(user) if user.group_drop_votes_count(self) >= 3
	end


	def includes_user?(user)
	  users.include?(user)
	end

	def primary_group?
	  degree == 1
	end

	def join_group_notifications(new_user)
		users.each do |user|
			self.notifications.create(user: user, poster: new_user, notification_type: "Join").delay unless user == new_user
		end
		GroupMailer.delay.join_group({group: self, poster: new_user})
	end

	def names_data(current_user)
		user_names_hash(current_user).to_json.html_safe
	end

	def city
	  users.first.city
	end

	def name_group
		self.name = GroupNameHelper.name.sample
	end

	private
	def create_general_topic
	  self.topics.create(name: "General")
	end

	def user_names_hash(current_user)
		users.map do |user|
			Hash[:name, user.first_name, :slug, user.slug, :full_name, user.name] unless user == current_user
		end.compact << group_hash
	end

	def group_hash
	  Hash[:name, "Group", :slug, "group", :full_name, name]
	end
end
