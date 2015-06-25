class Assistant < User
  validates :selector_id, presence: true
  belongs_to :selector, foreign_key: :selector_id
end
