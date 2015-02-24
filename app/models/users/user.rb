class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  
  has_many :assistants, class_name: 'Assistant',
                       foreign_key: 'selector_id'
  belongs_to :selector, class_name: 'Selector',
                       foreign_key: 'selector_id'
  has_many :orders

  devise :database_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable
end
