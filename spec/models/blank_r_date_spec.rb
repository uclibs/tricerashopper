require 'spec_helper'

describe BlankRdate do
  context 'record matches query' do
    before do
      order_records = [double('order_view',
       order_status_code: 'a',
       order_date_gmt: DateTime.parse('2001-01-01'),
       received_date_gmt: nil,
       bib_view: double('bib_view', cataloging_date_gmt: DateTime.parse('2001-01-01'), title: 'test title'),
       acq_type_code: 'p',
       record_type_code: 'o')]

      OrderView.stub(:where).and_return(order_records)
    end
    
    it "it is valid" do
      record = BlankRdate.new(record_num: 123456)
      record.should be_valid
    end
    
    it "should not create duplicates" do
      record1 = BlankRdate.create(record_num: 123456)
      record2 = BlankRdate.create(record_num: 123456)
      record2.should_not be_valid
    end
  end

  context 'record does not match query' do
    before do
      order_records = [double('order_view',
       order_status_code: 'a',
       order_date_gmt: DateTime.parse('2001-01-01'),
       received_date_gmt: DateTime.parse('2001-01-01'),
       bib_view: double('bib_view', cataloging_date_gmt: DateTime.parse('2001-01-01'), title: 'test title'),
       acq_type_code: 'p',
       record_type_code: 'o')]

      OrderView.stub(:where).and_return(order_records)
    end

    it "it is invalid" do
      record = BlankRdate.new(record_num: 123456)
      record.should_not be_valid
    end
  end
end
