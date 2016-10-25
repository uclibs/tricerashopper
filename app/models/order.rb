class Order < ActiveRecord::Base
  include Workflow
  validates :title, presence: true
  validates :author, presence: true
  validates :format, presence: true
  validates :publication_date, presence: true
  validates :publication_date, length: {is: 4, message: 'format must be YYYY'} 
  validates :vendor_code, length: { maximum: 5 }
  validates :publisher, presence: true
  validates :selector, presence: true
  validates :location_code, presence: true
  validates :fund, presence: true
  validates :cost, presence: true
  validates :currency, presence: true
  validates :currency, length: { is: 3, message: '3 letter currency code' }
  validates_presence_of :notification_contact, if: :notify?, message: 'can\'t be blank if notification requested'
  validates_presence_of :not_yet_published_date, if: :not_yet_published?, message: 'can\'t be blank if \'not yet published\' indicated'
  
  belongs_to :user

  searchable do 
    text :title, :workflow_state
    string :title
    string :workflow_state
    integer :user_id
    date :created_at
    integer :id
    string :rush_order
    string :reserve
	string :format
  end

  workflow do 
    state :provisional do
      event :approve_selection, :transitions_to => :new
      event :reject, :transitions_to => :rejected
    end
    state :new do
      event :marc_yes_po, :transitions_to => :marc_yes_po
      event :marc_no_po, :transitions_to => :marc_no_po
      event :ordered, :transitions_to => :ordered
      event :temporary_hold, :transitions_to => :temporary_hold
      event :reject, :transitions_to => :rejected
    end
    state :marc_yes_po do
      event :marc_no_po, :transitions_to => :marc_no_po
      event :ordered, :transitions_to => :ordered
      event :temporary_hold, :transitions_to => :temporary_hold
    end
    state :marc_no_po do
      event :marc_yes_po, :transitions_to => :marc_yes_po
      event :ordered, :transitions_to => :ordered
      event :temporary_hold, :transitions_to => :temporary_hold
    end
    state :temporary_hold do
      event :marc_yes_po, :transitions_to => :marc_yes_po
      event :marc_no_po, :transitions_to => :marc_no_po
      event :ordered, :transitions_to => :ordered
      event :reject, :transitions_to => :rejected
    end
    state :ordered do
      event :temporary_hold, :transitions_to => :temporary_hold
    end
    state :rejected do
      event :temporary_hold, :transitions_to => :temporary_hold
    end
  end 
end
