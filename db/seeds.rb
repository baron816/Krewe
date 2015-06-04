require 'csv'

CSV.foreach(Rails.root.join('db', 'users.csv'), {headers: true, header_converters: :symbol}) do |row|
	User.create(row.to_hash)
end

CSV.foreach(Rails.root.join('db', 'messages.csv'), {headers: true, header_converters: :symbol}) do |row|
	Message.create(row.to_hash)
end

CSV.foreach(Rails.root.join('db', 'personal_messages.csv'), {headers: true, header_converters: :symbol}) do |row|
	PersonalMessage.create(row.to_hash)
end

CSV.foreach(Rails.root.join('db', 'activities.csv'), {headers: true, header_converters: :symbol}) do |row|
	Activity.create(row.to_hash)
end