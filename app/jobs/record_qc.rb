class RecordQc
  def self.perform(record_num)
    unless deleted?(record_num)
      problem_types.each do |type|
        if problem_exist?(record_num, type)
          problem_review(record_num, type)
        else
          create_problem(record_num, type)
        end 
      end
      update_index_date(record_num)
    end
  end

  private

  def self.create_problem(record_num, type)
      type.create(record_num: record_num)
  end
  
  def self.problem_exist?(record_num, type)
    if type.where(record_num: record_num).presence
      true
    else
      false
    end
  end
 
  def self.problem_review(record_num, type)
    records = type.where(record_num: record_num)
    records.each do |problem| 
      problem.destroy unless problem.valid? 
    end
  end

  def self.deleted?(record_num, type = record_type)
    if SierraIndexHelper.record_deleted?(record_num, record_type)
      SierraIndexHelper.destroy_index_entry(record_num, record_type)
      true
    else
      false
    end
  end

  def self.update_index_date(record_num, type = record_type)
    SierraIndexHelper.update_date(record_num, record_type)
  end
end
