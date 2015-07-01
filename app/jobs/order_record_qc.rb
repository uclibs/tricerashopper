class OrderRecordQc
  @queue = :order_qc

  def self.perform(record_num)
    unless deleted?(record_num)
      if problem_exist?(record_num)
        problem_review(record_num)
      else
        blank_r_date(record_num)
      end 
      update_index_date(record_num)
    end
  end

  private

  def self.blank_r_date(record_num)
      BlankRdate.create(record_num: record_num)
  end
  
  def self.problem_exist?(record_num)
    if Problem.where(record_num: record_num).presence
      true
    else
      false
    end
  end
 
  def self.problem_review(record_num)
    records = Problem.where(record_num: record_num)
    records.each do |problem| 
      problem.destroy unless problem.valid? 
    end
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
