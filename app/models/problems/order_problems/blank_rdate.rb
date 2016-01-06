class BlankRdate < OrderProblem
  
  DESCRIPTION = 'Order rdate is blank but status is marked paid'

  def query
    load_order_view
    order_status_code_is_a and
    order_is_more_than_4_months_old and
    order_received_date_is_nil and
    order_cataloging_date_is_not_nil and
    order_acq_type_is_p
  end
end
