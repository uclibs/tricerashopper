class Order < ActiveRecord::Base
  include Workflow
  validates :title, presence: true
  validates :author, presence: true
  validates :publication_date, presence: true
  validates :publication_date, length: {is: 4, message: 'format must be YYYY'} 
  validates :vendor_code, length: { maximum: 5 }
  validates :publisher, presence: true
  validates :selector, presence: true
  validates :location_code, presence: true
  validates :fund, presence: true
  validates :cost, presence: true
  validates :cost, format: { with: /\d{2}/, message: 'format X.XX' }
  validates_presence_of :notification_contact, if: :notify?, message: 'can\'t be blank if notification requested'
  validates_presence_of :not_yet_published_date, if: :not_yet_published?, message: 'can\'t be blank if \'not yet published\' indicated'
  
  belongs_to :user

  searchable do 
    text :title, :workflow_state
    string :title
    string :workflow_state
    integer :user_id
    date :created_at
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
      event :accept_no_print, :transitions_to => :print_queue_no_po
      event :temporary_hold, :transitions_to => :waiting
      event :accept_no_action, :transitions_to => :ordered
      event :reject, :transitions_to => :rejected
    end
    state :print_queue do
      event :accept_no_action, :transitions_to => :ordered
      event :temporary_hold, :transitions_to => :waiting
    end
    state :print_queue_no_po do
      event :accept_no_action, :transitions_to => :ordered
      event :temporary_hold, :transitions_to => :waiting
    end
    state :waiting do
      event :accept_print, :transitions_to => :print_queue
      event :accept_no_print, :transitions_to => :print_queue_no_po
      event :accept_no_action, :transitions_to => :ordered
      event :reject, :transitions_to => :rejected
    end
    state :ordered do
      event :temporary_hold, :transitions_to => :waiting
    end
    state :rejected do
      event :temporary_hold, :transitions_to => :waiting
    end
  end 
end
