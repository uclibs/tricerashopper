require 'spec_helper'

describe CancelledByVendor do

  class CancelledOrderRecord < Struct.new(:order_status_code, :received_date_gmt, :bib_view, :order_record_edifact_responses, :record_type_code)
  end

  class EdiResponse < Struct.new(:code)
  end

  class CancelledBibMetadata < Struct.new(:title)
  end
 
  it "is valid if record matches query" do
    order_records = [CancelledOrderRecord.new('o', nil, CancelledBibMetadata.new('test title'), [EdiResponse.new('2'), EdiResponse.new('1')], 'o')]
    OrderView.stub(:where).and_return(order_records)
    record = CancelledByVendor.new(record_num: 999999)
    record.should be_valid
  end

  it "is not valid if record does not match query" do
    order_records = [CancelledOrderRecord.new('o', nil, CancelledBibMetadata.new('test title'), [EdiResponse.new('1')], 'o')]
    OrderView.stub(:where).and_return(order_records)
    record = CancelledByVendor.new(record_num: 999999)
    record.should_not be_valid
  end

  it "is not valid if duplicate" do
    order_records = [CancelledOrderRecord.new('o', nil, CancelledBibMetadata.new('test title'), [EdiResponse.new('2')], 'o')]
    OrderView.stub(:where).and_return(order_records)
    record1 = CancelledByVendor.create(record_num: 999999)
    record2 = CancelledByVendor.create(record_num: 999999)
    record2.should_not be_valid
  end
end
