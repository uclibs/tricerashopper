class Serial < ActiveRecord::Base
  serialize :issns, Array
  serialize :payments, Hash

  searchable do
    text :issns
    string :title
    string :vendor
    string :fund
    string :format
    string :order_type
    string :acq_type
  end
end
