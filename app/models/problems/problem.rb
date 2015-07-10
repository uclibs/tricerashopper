class Problem < ActiveRecord::Base
  validates :title, presence: true
  validates :record_num, presence: true
  validates :record_type, presence: true
  validate :subclass_validations

  def subclass_validations
    if self.class.descends_from_active_record?
      unless self.type.nil?
        subclass = self.becomes(self.type.classify.constantize)
        self.errors.add(:base, "subclass validations are failing.") unless subclass.valid?
      end
    end
  end

  has_many :blank_rdates, class_name: 'BlankRdate',
                         foreign_key: 'id'

end
