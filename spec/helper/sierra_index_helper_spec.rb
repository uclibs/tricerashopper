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
      Record.new('b', '100001', DateTime.parse('2001-01-01'), RecordMetadata.new(nil)),
      Record.new('b', '100002', DateTime.parse('2001-01-02'), RecordMetadata.new(DateTime.parse('2001-01-03'))),
      Record.new('b', '100003', DateTime.parse('2001-01-03'), RecordMetadata.new(nil)),
      Record.new('b', '100004', DateTime.parse('2001-01-04'), RecordMetadata.new(nil)),
      Record.new('b', '100005', DateTime.parse('2001-01-05'), RecordMetadata.new(nil)),
      Record.new('b', '100006', DateTime.parse('2001-01-06'), RecordMetadata.new(nil))
    ]
    BibView.stub(:find_in_batches).and_yield(bib_records)
  end

  it "deletes all index records of a given type" do
    SierraIndexHelper.build_index('b') 
    expect { SierraIndexHelper.delete_all('b') }.to change {SierraIndex.count }.by(-5)
  end

  it "adds all of the index records of a given type" do
    expect { SierraIndexHelper.build_index('b') }.to change { SierraIndex.count }.by(5)
  end

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
