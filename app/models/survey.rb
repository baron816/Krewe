class Survey < ActiveRecord::Base
  validates_presence_of :email
end
