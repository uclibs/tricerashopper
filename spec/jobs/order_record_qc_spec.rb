require 'spec_helper'

describe OrderRecordQc do
  describe "#perform" do
    Resque.inline = true

    context "BlankRdate already exists" do 
      before(:each) do
        prob = FactoryGirl.build_stubbed(:problem)
        OrderView.stub_chain(:where, :first, :record_metadata, :deletion_date_gmt).and_return(nil)
        Problem.stub(:where).and_return([prob])
      end  

        it "should not create" do
          BlankRdate.should_not receive(:create)
          Resque.enqueue(OrderRecordQc, 100001)
        end
      end

    context "order record has not been deleted" do
      before(:each) do
        OrderView.stub_chain(:where, :first, :record_metadata, :deletion_date_gmt).and_return(nil)
        BlankRdate.stub(:create).and_return(true)
      end

      it "should update the SierraIndex.last_checked date" do
        SierraIndexHelper.should receive(:update_date).with(100001, 'o')
        Resque.enqueue(OrderRecordQc, 100001)
      end

      it "should run the BlankRdate test" do
        BlankRdate.should receive(:create)
        Resque.enqueue(OrderRecordQc, 100001)
      end
    end

    context "order record has been deleted" do
      before(:each) do
        OrderView.stub_chain(:where, :first, :record_metadata, :deletion_date_gmt).and_return(DateTime.parse('2001-01-06'))
      end

      it "should delete the index entry" do
        SierraIndexHelper.should receive(:destroy_index_entry).with(100001, 'o')
        Resque.enqueue(OrderRecordQc, 100001)
      end

      it "should not run the BlankRdate test" do
        BlankRdate.should_not receive(:create)
        Resque.enqueue(OrderRecordQc, 100001)
      end
 
      it "should not run the Problem Review test" do
        Problem.should_not receive(:where)
        Resque.enqueue(OrderRecordQc, 100001)
      end
    end
  end
end
