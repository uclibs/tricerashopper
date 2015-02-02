class Order < ActiveRecord::Base
  include Workflow
  validates :title, presence: true
  validates :author, presence: true
  validates :publication_date, presence: true
  validates :isbn, presence: true
  validates :publisher, presence: true
  validates :selector, presence: true
  validates :location_code, presence: true
  validates :fund, presence: true
  validates :cost, presence: true
  validates :cost, format: { with: /\d{2}/, message: 'format X.XX' }

  searchable do 
    text :title, :workflow_state
    string :title
    string :workflow_state
  end

  def cost=(val)
        write_attribute :cost, val.to_s.gsub(/\D/, '').to_i
  end
  
  workflow do 
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
