class Topic < ActiveRecord::Base
  belongs_to :group
  has_many :messages, as: :messageable
  has_many :notifications, as: :notifiable
  delegate :names_data, :users, to: :group

  validates_presence_of :name
end
