class Problem < ActiveRecord::Base
  validates :title, presence: true
  validates :description, presence: true
  validates :record_num, presence: true
  validates :record_type, presence: true
end
