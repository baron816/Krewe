class Group < ActiveRecord::Base
	extend FriendlyId
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

	delegate :size, to: :expand_group_votes, prefix: true
	delegate :attended_activities_count, :future_activities, to: :activities
	delegate :count, :empty?, to: :users, prefix: true
	delegate :ids, to: :topics, prefix: true

	scope :open_groups, -> { where(can_join: true) }
	scope :category_groups, ->(category) { where(category: category) }
	scope :excluded_users, ->(friend_ids) { where.not(id: user_friend_group_ids(friend_ids)) }
	scope :non_former_groups, ->(group_ids) { where.not(id: group_ids) }
	scope :degree_groups, ->(degree) { where(degree: degree) }
	scope :ready_groups, -> { where(ready_to_expand: true) }

	def self.search(params)
		self.open_groups.category_groups(params[:category]).excluded_users(params[:friend_ids]).degree_groups(1).near([params[:latitude], params[:longitude]], 0.5).non_former_groups(params[:group_ids])[0]
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
		self.delete if users_empty?
	end

	def kick_user(user)
		drop_user(user) if user.group_drop_votes_count(self) >= 3
	end

	def ripe_for_expansion?
	  aged?(degree.month) && attended_activities_count >= 4 && can_join == false && has_expanded == false && ready_to_expand == false
	end

	def voted_to_expand?
		expand_group_votes_size == users_count
	end

	def includes_user?(user)
	  users.include?(user)
	end

	def primary_group?
	  degree == 1
	end

	def join_group_notifications(new_user)
		users.each do |user|
			unless user == new_user
				self.notifications.create(user: user, poster: new_user, notification_type: "Join")
				GroupMailer.join_group({user: user, group: self, poster: new_user}).deliver_now
			end
		end
	end

	def names_data
		user_names_hash.to_json.html_safe
	end

	private
	def user_names_hash
		users.map do |user|
			Hash[:name, user.first_name, :slug, user.slug, :full_name, user.name]
		end
	end

	def slug_candidates
		name_group
		[
			:name,
			:slug_hex
		]
	end

	def slug_hex
		slug = normalize_friendly_id(name)
		begin
			hexed = "#{slug}-#{SecureRandom.hex(6)}"
		end while Group.exists?(slug: hexed)
		hexed
	end

	def name_group
		self.name = GroupNameHelper.name.sample
	end

	def self.user_friend_group_ids(friend_ids)
		self.includes(:users).references(:users).where("users.id in (?)", friend_ids).ids.uniq
	end

	def aged?(period)
		(Time.now - created_at) > period
	end
end
