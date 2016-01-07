class CancelledByVendor < OrderProblem
  
  DESCRIPTION = 'Edifact response from vendor indicates cancellation'

  def query
    load_order_view
    order_status_code_is_o and
    order_received_date_is_nil and
    order_edi_response_is_2
  end

end
