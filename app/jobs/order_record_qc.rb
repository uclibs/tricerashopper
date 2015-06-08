class OrderRecordQc
  @queue = :order_qc

  def self.perform(record_num)
    deleted = deleted?(record_num) 
    blank_r_date(record_num) unless deleted
    update_index_date(record_num) unless deleted
  end

  private

  def self.blank_r_date(record_num)
    BlankRdate.create(record_num: record_num)
  end

  def self.deleted?(record_num, record_type = 'o')
    if SierraIndexHelper.record_deleted?(record_num, record_type)
      SierraIndexHelper.destroy_index_entry(record_num, record_type)
      true
    else
      false
    end
  end

  def self.update_index_date(record_num, record_type = 'o')
    SierraIndexHelper.update_date(record_num, record_type)
  end
end
