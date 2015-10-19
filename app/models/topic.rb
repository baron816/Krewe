class Topic < ActiveRecord::Base
  belongs_to :group
  has_many :messages, as: :messageable
  delegate :names_data, to: :group
  delegate :count, to: :messages, prefix: true
end
