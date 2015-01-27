class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  validates_inclusion_of :lmlo_receives_report, :in => [true, false]
serialize :location
  devise :database_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable
end
