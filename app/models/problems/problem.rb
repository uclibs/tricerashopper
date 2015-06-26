class Problem < ActiveRecord::Base
  validates :title, presence: true
  validates :record_num, presence: true
  validates :record_type, presence: true

  has_many :blank_rdates, class_name: 'BlankRdate',
                         foreign_key: 'id'

end
