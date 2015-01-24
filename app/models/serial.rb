class Serial < ActiveRecord::Base
  serialize :issns, Array
  serialize :payments, Hash
end
