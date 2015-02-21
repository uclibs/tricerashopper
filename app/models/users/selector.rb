class Selector < User
  validates_inclusion_of :lmlo_receives_report, :in => [true, false]
  serialize :location
end
