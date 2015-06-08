require 'spec_helper'
require 'ostruct'

describe SierraIndexHelper do
  ## all examples use ActiveSierra::BibView
  
  class Record < Struct.new(:record_type_code, :record_num, :record_creation_date_gmt, :record_metadata)
  end

  class RecordMetadata < Struct.new(:deletion_date_gmt)
  end

  before(:each) do
    bib_records = [
      Record.new('b', 100001, DateTime.parse('2001-01-01'), RecordMetadata.new(nil)),
      Record.new('b', 100002, DateTime.parse('2001-01-02'), RecordMetadata.new(DateTime.parse('2001-01-03'))),
      Record.new('b', 100003, DateTime.parse('2001-01-03'), RecordMetadata.new(nil)),
      Record.new('b', 100004, DateTime.parse('2001-01-04'), RecordMetadata.new(nil)),
      Record.new('b', 100005, DateTime.parse('2001-01-05'), RecordMetadata.new(nil)),
      Record.new('b', 100006, DateTime.parse('2001-01-06'), RecordMetadata.new(nil))
    ]
    BibView.stub(:find_in_batches).and_yield(bib_records)
  end

  describe "#all_records" do
    it "returns all of the records of a given type" do
      SierraIndex.create(record_num: 100001, record_type: 'b')
      SierraIndex.create(record_num: 100002, record_type: 'b')
      SierraIndex.create(record_num: 100003, record_type: 'b')
      SierraIndex.create(record_num: 100001, record_type: 'o')
      SierraIndex.create(record_num: 100001, record_type: 'i')
      expect((SierraIndexHelper.all_records('b')).count).to eq(3)
    end
  end

  describe "#oldest_10_percent" do
    it "returns the ten percent of the record set with the oldest last_checked date" do
      30.times do |i|
        SierraIndex.create(record_num: 100001 + i, record_type: 'o', last_checked: DateTime.now + i)
      end
      expect(SierraIndexHelper.oldest_10_percent('o').collect { |record| record.record_num }).to eq([100001, 100002, 100003])
    end
  end

  describe "#destroy_index_entry" do
    it "deletes a given record" do
      SierraIndex.create(record_num: 100001, record_type: 'b')
      expect { SierraIndexHelper.destroy_index_entry(100001, 'b') }.to change { SierraIndex.count }.by(-1)
    end
  end

  describe "#record_deleted?" do
    it "should return true if the record has been deleted" do
      BibView.stub_chain(:where, :first, :record_metadata, :deletion_date_gmt).and_return(DateTime.yesterday)
      expect(SierraIndexHelper.record_deleted?(100001, 'b')).to eq(true)
    end

    it "should return false if the record has not been deleted" do
      BibView.stub_chain(:where, :first, :record_metadata, :deletion_date_gmt).and_return(nil)
      expect(SierraIndexHelper.record_deleted?(100001, 'b')).to eq(false)
    end
  end

  describe "#update_date" do
    it "updates the last_checked date" do
      index = SierraIndex.create(record_num: 100001, record_type: 'b', last_checked: DateTime.yesterday)
      SierraIndexHelper.update_date(100001, 'b')
      index.reload

      expect { index.last_checked.today? }.to be_true
    end
  end

  describe "#delete_all" do
    it "deletes all index records of a given type" do
      SierraIndexHelper.build_index('b') 
      expect { SierraIndexHelper.delete_all('b') }.to change { SierraIndex.count }.by(-5)
    end
  end

  describe "#build_index" do
    it "adds all of the index records of a given type" do
      expect { SierraIndexHelper.build_index('b') }.to change { SierraIndex.count }.by(5)
    end
  end

  describe "#update_index" do
    it "adds all records of a given type, starting with a date" do
      BibView.stub_chain(:find_by_record_num, :record_creation_date_gmt).and_return(DateTime.parse('2001-01-06'))

      SierraIndexHelper.build_index('b') 
      bib_records = [
        Record.new('b', '100005', DateTime.parse('2001-01-05'), RecordMetadata.new(nil)),
        Record.new('b', '100006', DateTime.parse('2001-01-06'), RecordMetadata.new(nil)),
        Record.new('b', '100007', DateTime.parse('2001-01-06'), RecordMetadata.new(nil)),
        Record.new('b', '100008', DateTime.parse('2001-01-07'), RecordMetadata.new(nil)),
        Record.new('b', '100009', DateTime.parse('2001-01-08'), RecordMetadata.new(nil))
      ]

      BibView.stub_chain(:where, :find_in_batches).and_yield(bib_records)
      expect { SierraIndexHelper.update_index('b') }.to change { SierraIndex.count }.by(3)
    end
  end
end
