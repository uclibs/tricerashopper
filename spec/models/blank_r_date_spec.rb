require 'spec_helper'

describe BlankRdate do

  class OrderRecord < Struct.new(:order_status_code, :order_date_gmt, :received_date_gmt, :bib_view, :acq_type_code, :record_type_code)
  end

  class OrderRecordMetadata < Struct.new(:cataloging_date_gmt, :title)
  end
  
  it "is valid if record matches query" do
    order_records = [OrderRecord.new('a', DateTime.parse('2001-01-01'), nil, OrderRecordMetadata.new(DateTime.parse('2001-01-01'), 'test title'), 'p', 'o')]
    OrderView.stub(:where).and_return(order_records)
    record = BlankRdate.new(record_num: 907215)
    record.should be_valid
  end

  it "is invalid if record doesn't match query" do
    order_records = [OrderRecord.new('m', DateTime.parse('2001-01-01'), DateTime.parse('2001-01-01'), OrderRecordMetadata.new(DateTime.parse('2001-01-01'), 'test title'), 'p', 'o')]
    OrderView.stub(:where).and_return(order_records)
    record = BlankRdate.new(record_num: 907215)
    record.should_not be_valid
  end

  it "is invalid if duplicate" do
    order_records = [OrderRecord.new('a', DateTime.parse('2001-01-01'), nil, OrderRecordMetadata.new(DateTime.parse('2001-01-01'), 'test title'), 'p', 'o')]
    OrderView.stub(:where).and_return(order_records)
    record1 = BlankRdate.create(record_num: 907215)
    record2 = BlankRdate.create(record_num: 907215)
    record2.should_not be_valid
  end
end
