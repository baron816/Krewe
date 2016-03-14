module ApplicationHelper
	def categories
		[
			"Professional",
			"Creative",
			"Blue Collar",
			"Doesn't Matter"
		]
	end

	def age_groups
	  [
			"Select Age Group",
			"18-24",
			"22-28",
			"27-33",
			"32-42",
			"38-55",
			"52-67",
			"65+",
			"Doesn't Matter"
		]
	end

	def reasons_for_leaving
	  [
			"Didn't form connection with others in group",
			"Interface was too confusing",
			"Too busy to meet people",
			"Too many email notifications"
		]
	end

	def mean(*args)
	  args.inject(:+) / args.length.to_f
	end

	def avatar_url(user)
	gravatar_id = Digest::MD5.hexdigest(user.email)
	"http://gravatar.com/avatar/#{gravatar_id}.png?s=48&d=mm"
end

	def first_word(phrase)
	  phrase.split.first
	end
end
