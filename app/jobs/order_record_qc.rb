class OrderRecordQc < RecordQc
  @queue = :order_qc

  ORDER_RECORD_PROBLEMS = [ BlankRdate, CancelledByVendor ]
  def self.problem_types
    ORDER_RECORD_PROBLEMS
  end

  RECORD_TYPE = 'o'
  def self.record_type
    'o'
  end
end
