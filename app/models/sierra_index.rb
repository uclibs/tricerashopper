class SierraIndex < ActiveRecord::Base
  validates :record_type, presence: true
  validates :record_type, inclusion: { in: %w(o b c i) }
  validates :record_num, presence: true
end
