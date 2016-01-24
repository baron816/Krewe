class Group < ActiveRecord::Base
	extend FriendlyId
	include Sluggable
	friendly_id :slug_candidates, use: :slugged

	has_many :user_groups
	has_many :users, through: :user_groups, after_add: [:check_space, :join_notification], after_remove: :check_space
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
	delegate :count, :empty?, :include?, to: :users, prefix: true
	delegate :ids, to: :topics, prefix: true

	scope :open_groups, -> { where(can_join: true) }
	scope :category_groups, ->(category) { where(category: category) }
	scope :non_former_groups, ->(group_ids) { where.not(id: group_ids) }
	scope :same_age, ->(age_group) { where(age_group: age_group) }
	scope :degree_groups, ->(degree) { where(degree: degree) }
	scope :ready_groups, -> { where(ready_to_expand: true) }

	def self.search(params)
		self.open_groups.category_groups(params[:category]).same_age(params[:age_group]).degree_groups(1).near([params[:latitude], params[:longitude]], 0.5).order(created_at: :asc).non_former_groups(params[:group_ids])[0]
	end

	def check_space(user)
		GroupSpaceCheck.new(self, user).check_space
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

	def join_notification(user)
	  JoinNotification.new(self, user).send_notifications if self.degree == 1
	end
end
