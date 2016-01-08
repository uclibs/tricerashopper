require 'spec_helper'

describe OrderRecordQc do
  describe "#perform" do
    Resque.inline = true

    context "Problem already exists" do 
      let(:problem) { FactoryGirl.create(:problem) }

      before do
        OrderView.stub_chain(:where, :first, :record_metadata, :deletion_date_gmt).and_return(nil)
        BlankRdate.stub(:where).and_return([problem])
      end  

      it "should handle duplicate problems appropriately" do
        ## skipping duplicate
        BlankRdate.should_not receive(:create)

        ## checking problem is valid
        problem.should receive(:valid?)

        ## creating another for the same record
        CancelledByVendor.should receive(:create)
        Resque.enqueue(OrderRecordQc, 100001)
      end
    end

    context "Problem does not exist" do
      context "order record has not been deleted" do
        before do
          OrderView.stub_chain(:where, :first, :record_metadata, :deletion_date_gmt).and_return(nil)
          BlankRdate.stub(:create).and_return(true)
        end

        it "should run problem tests and update the index" do
          ## should update the SierraIndex.last_checked date
          SierraIndexHelper.should receive(:update_date).with(100001, 'o')
        
          ## should run the BlankRdate test
          BlankRdate.should receive(:create)

          ## should run the CancelledByVendor test
          CancelledByVendor.should receive(:create)
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

        it "should not run a problem test" do
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
end
