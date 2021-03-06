module SierraIndexHelper
  ACTIVE_SIERRA_CLASS = { "b" => BibView, "i" => ItemView, "c" => HoldingView, "o" => OrderView }

  def self.destroy_index_entry(record_num, record_type)
    records_to_delete = SierraIndex.where(record_num: record_num, record_type: record_type)
    records_to_delete.destroy_all
  end

  def self.update_date(record_num, record_type)
    record = SierraIndex.where(record_num: record_num, record_type: record_type).last
    unless record.nil?
      record.last_checked = DateTime.now
      record.save
    end
  end

  def self.record_deleted?(record_num, record_type)
    return true unless ACTIVE_SIERRA_CLASS[record_type].where(record_num: record_num).first.record_metadata.deletion_date_gmt.nil?
    return false
  end

  def self.all_records(record_type)
    SierraIndex.where(record_type: record_type)
  end

  def self.oldest_10_percent(record_type)
      count = SierraIndex.where(record_type: 'o').count / 10
      SierraIndex.where(record_type: 'o').order(:last_checked).limit(count)
  end

  def self.delete_all(record_type)
    records_to_delete = all_index_records_of_one_type(record_type)
    puts "Deleting #{records_to_delete.length} \"#{record_type}\" records."
    records_to_delete.destroy_all
  end

  def self.update_index(record_type)
    begin_date = identify_newest_record(record_type)
    create_with_batch(record_type, begin_date)
  end

  def self.build_index(record_type)
    create_with_batch(record_type)
  end

  private

  def self.create_with_batch(record_type, begin_date = nil)
    if begin_date.nil?
      ACTIVE_SIERRA_CLASS[record_type].find_in_batches do |group| 
        group.each { |record| create_index(record) }
        echo_last_record_number(group, record_type)
      end
    else
      ACTIVE_SIERRA_CLASS[record_type].where(record_creation_date_gmt: (begin_date - 1).beginning_of_day..DateTime.tomorrow.end_of_day).find_in_batches do |group| 
        group.each { |record| create_index(record) }
        echo_last_record_number(group, record_type)
      end
    end
  end

  def self.create_index(record)
    ## Record is an ActiveSierra *View record, such as BibView
    return unless record.record_metadata.deletion_date_gmt.nil?
    index_entry = SierraIndex.new(
      record_num: record.record_num,
      record_type: record.record_type_code
    )
    ## Saving without save! because we are expecting some validation failures
    index_entry.save
  end

  def self.echo_last_record_number(group, record_type)
    puts "#{group.last.record_num}"
  end
    

  def self.identify_newest_record(record_type)
    record_num_of_last_record_harvested = SierraIndex.where(record_type: record_type).last.record_num
    ACTIVE_SIERRA_CLASS[record_type].find_by_record_num(record_num_of_last_record_harvested).record_creation_date_gmt
  end

  def self.all_index_records_of_one_type(record_type_scope)
    SierraIndex.all.where(record_type: record_type_scope)
  end
end
