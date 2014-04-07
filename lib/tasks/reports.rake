namespace :selector_reports do

  desc "get items with status p"
    task:get_status_p => :environment do
    @p = ItemView.where("item_status_code = 'p'")
    #puts p
  end

  desc "build LMLO:db"
    task:build_lmlo_db => :get_status_p do
    @minus3months = Time.now - 3.months
    @p.each do |x|
      bibview = x.bib_views.first
      bibrecord = bibview.bib_record
      metadata = x.record_metadata

      if metadata.record_last_updated_gmt < @minus3months and
       bibview.cataloging_date_gmt != 'nil' and 
       bibview.bcode3 != 's'
       
        isbn = []  #codeblock to isolate and group multi isbn
        bibrecord.varfield_views.where(marc_tag: '020').each {|r| isbn << r.field_content}
        isbn = isbn.to_s
        puts isbn
        LostMissingLongOverdue.create(
          item_number: x.record_num,
          bib_number: bibview.record_num,
          title: bibview.title,
          imprint: bibrecord.varfield_views.where(marc_tag: '260').first.try(:field_content) || nil,
          isbn: isbn,
          status: x.item_status_code,
          checkouts: x.checkout_total,
          location: x.location_code,
          #note: x.varfields,
          call_number: x.varfield_views.where("varfield_type_code = 'c'").first.try(:field_content) || nil,
          volume: x.varfield_views.where("varfield_type_code = 'v'").first.try(:field_content) || nil,
          barcode: x.barcode,
          #due_date: need model for for checkout table,
          last_checkout: x.last_checkout_gmt,
          created_at: x.record_creation_date_gmt,
          updated_at: x.record_metadata.record_last_updated_gmt
        )
        end
     end 
  end
end
