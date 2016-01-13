module ApplicationHelper
  def human_readable_record_number(record_type, record_num)
    "#{record_type}#{record_num}a"
  end
end
