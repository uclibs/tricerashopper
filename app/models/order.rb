class Order < ActiveRecord::Base
  include Workflow
  validates :title, presence: true
  validates :author, presence: true
  validates :publication_date, presence: true
  validates :publication_date, length: {is: 4, message: 'format must be YYYY'} 
  validates :isbn, presence: true
  validates :isbn, length: { in: 10..13 }
  validates :vendor_code, length: { maximum: 5 }
  validates :publisher, presence: true
  validates :selector, presence: true
  validates :location_code, presence: true
  validates :location_code, length: { maximum: 5 }
  validates :fund, presence: true
  validates :fund, length: { is: 5 }
  validates :cost, presence: true
  validates :cost, format: { with: /\d{2}/, message: 'format X.XX' }
  validates_presence_of :notification_contact, if: :notify?, message: 'can\'t be blank if notification requested'
  
  belongs_to :user

  searchable do 
    text :title, :workflow_state
    string :title
    string :workflow_state
    integer :user_id
  end

  def cost=(val)
        write_attribute :cost, val.to_s.gsub(/\D/, '').to_i
  end
  
  workflow do 
    state :provisional do
      event :approve_selection, :transitions_to => :new
      event :reject, :transitions_to => :rejected
    end
    state :new do
      event :accept_print, :transitions_to => :print_queue
      event :accept_noprint, :transitions_to => :ordered
      event :accept_not_yet_published, :transitions_to => :waiting
      event :reject, :transitions_to => :rejected
    end
    state :print_queue do
      event :export_to_marc, :transitions_to => :ordered
    end
    state :waiting do
      event :accept_print, :transitions_to => :print_queue
      event :accept_no_print, :transitions_to => :ordered
      event :reject, :transitions_to => :rejected
    end
    state :ordered do
    end
    state :rejected do
    end
  end 
end
