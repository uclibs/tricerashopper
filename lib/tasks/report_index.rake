namespace :index do
  desc "Delete all index records"
  task :delete_all => [:delete_bib, :delete_item, :delete_checkin, :delete_order] do
  end

  desc "Update all index records"
  task :update_all => [:update_bib, :update_item, :update_checkin, :update_order] do
  end

  desc "Build all index records"
  task :build_all => [:build_bib, :build_item, :build_checkin, :build_order] do
  end



  desc "Delete all bib index records"
  task :delete_bib => :environment do
    delete_all('b')
  end

  desc "Retrieve new bib index records"
  task :update_bib => :environment do
    update_index('b')
  end

  desc "Retrieve all bib index records"
  task :build_bib => :environment do
    build_index('b')
  end



  desc "Delete all item index records"
  task :delete_item => :environment do
    delete_all('i')
  end

  desc "Retrieve new item index records"
  task :update_item => :environment do
    update_index('i')
  end

  desc "Retrieve all item index records"
  task :build_item => :environment do
    build_index('i')
  end



  desc "Delete all checkin index records"
  task :delete_checkin => :environment do
    delete_all('c')
  end

  desc "Retrieve new checkin index records"
  task :update_checkin => :environment do
    update_index('c')
  end

  desc "Retrieve all checkin index records"
  task :build_checkin => :environment do
    build_index('c')
  end



  desc "Delete all order index records"
  task :delete_order => :environment do
    delete_all('o')
  end

  desc "Retrieve new order index records"
  task :update_order => :environment do
    update_index('o')
  end

  desc "Retrieve all order index records"
  task :build_order => :environment do
    build_index('o')
  end



  def delete_all(record_type)
    records_to_delete = all_index_records_of_one_type(record_type)
    puts "Deleting #{records_to_delete.length} \"#{record_type}\" records."
    records_to_delete.destroy_all
  end

  def update_index(record_type)
    begin_date = identify_newest_record(record_type)
    create_with_batch(record_type, begin_date)
  end

  def build_index(record_type)
    create_with_batch(record_type)
  end

  def create_with_batch(record_type, begin_date = nil)
    batch_size = 1000
    active_sierra_class = { "b" => BibView, "i" => ItemView, "c" => HoldingView, "o" => OrderView }
    if begin_date.nil?
      active_sierra_class[record_type].find_in_batches(batch_size: batch_size) do |group| 
        group.each { |record| create_index(record) }
        echo_last_record_number(group, record_type)
      end
    else
      active_sierra_class[record_type].where(record_creation_date_gmt: (begin_date - 1).beginning_of_day..DateTime.tomorrow.end_of_day).find_in_batches(batch_size: batch_size) do |group| 
        group.each { |record| create_index(record) }
        echo_last_record_number(group, record_type)
      end
    end
  end

  def create_index(record)
    ## Record is an ActiveSierra *View record, such as BibView
    return unless record.record_metadata.deletion_date_gmt.nil?
    index_entry = SierraIndex.new(
      record_num: record.record_num,
      record_type: record.record_type_code
    )
    ## Saving without save! because we are expecting some validation failures
    index_entry.save
  end

  def echo_last_record_number(group, record_type)
    puts "#{group.last.record_num}"
  end
    

  def identify_newest_record(record_type)
    active_sierra_class = { "b" => BibView, "i" => ItemView, "c" => HoldingView, "o" => OrderView }
    record_num_of_last_record_harvested = SierraIndex.where(record_type: record_type).last.record_num
    active_sierra_class[record_type].find_by_record_num(record_num_of_last_record_harvested).record_creation_date_gmt
  end

  def all_index_records_of_one_type(record_type_scope)
    SierraIndex.all.where(record_type: record_type_scope)
  end
end
