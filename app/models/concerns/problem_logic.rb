module ProblemLogic
  extend ActiveSupport::Concern

  private

  def order_acq_type_is_p
    @order_view.acq_type_code == 'p'
  end

  def order_cataloging_date_is_not_nil
    @order_view.bib_view.cataloging_date_gmt != nil 
  end

  def order_is_more_than_4_months_old
    @order_view.order_date_gmt < DateTime.now - 4.months
  end
  
  def order_received_date_is_nil
    @order_view.received_date_gmt == nil
  end

  def order_status_code_is_a
    @order_view.order_status_code == 'a' 
  end

  def order_status_code_is_o
    @order_view.order_status_code == 'o' 
  end

  def order_edi_response_is_2
    @order_view.order_record_edifact_responses.each do |response|
      if response.code == '2'
        return true
      end
    end
    false
  end

end
