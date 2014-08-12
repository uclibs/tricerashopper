namespace :selector_reports do

  @minus3months = Time.now - 3.months
  @minus1year = Time.now - 1.year

  def filter_delims(field)
    unless field.nil?
      field = field.gsub(/\|[af]/, '')
      field.gsub(/\|[a]/, '')
      field.gsub(/\|[b-z]/, ' ')
    end
  end

  def lmlo_create(x)
      bibview = x.bib_views.first
      metadata = x.record_metadata
        Lost.create(
          item_number: x.record_num,
          bib_number: bibview.record_num,
          title: bibview.title,
          imprint: filter_delims(bibview.varfield_views.where(marc_tag: '260').first.try(:field_content) || nil),
          isbn: filter_delims((isbn = Array.new; bibview.varfield_views.where(marc_tag: '020').each {|r| isbn << r.field_content}; isbn = isbn.join(','))),
          status: x.item_status_code,
          checkouts: x.checkout_total,
          location: x.location_code,
          #note: x.varfields
          call_number: filter_delims(x.item_record_property.call_number),
          volume: x.varfield_views.where("varfield_type_code = 'v'").first.try(:field_content) || nil,
          barcode: x.barcode,
          due_date: x.checkout.try(:due_gmt) || nil,
          last_checkout: x.last_checkout_gmt,
          created_at: x.record_creation_date_gmt,
          updated_at: x.record_metadata.record_last_updated_gmt
          ) 
    puts bibview.title
  end 

  namespace :losts do
    desc "drop losts table"
    task:drop_losts => :environment do
      if ActiveRecord::Base.connection.table_exists? 'losts'
        DatabaseCleaner.clean_with(:truncation, :only => %w[losts])
        else
          Rake::Task['db:migrate'].execute
        end
    end
  
    desc "Get status'p' records"
    task:get_status_p => :drop_losts do
      
      p = ItemView.where("item_status_code = 'p'")
      p.each do |i|
        unless i.record_metadata.record_last_updated_gmt > @minus3months || i.bib_views.first.cataloging_date_gmt.nil? || i.bib_views.first.bcode3 == 's'
          lmlo_create(i) 
        end
      end
    end
  
    desc "Get status 'l' item records"
    task:get_status_l => :get_status_p do
      l = ItemView.where("item_status_code = 'l'")
      l.each do |i|
        unless i.record_metadata.record_last_updated_gmt > @minus1year
          lmlo_create(i)
        end
      end
    end
  
    desc "Get status '$' item records"
    task:get_status_dollar => :get_status_l do
      dollar = ItemView.where("item_status_code = '$'")
      dollar.each do |i|
        lmlo_create(i)
      end
    end
  
    desc "Get status 'z' item records"
    task:get_status_z => :get_status_dollar do
      z = ItemView.where("item_status_code = 'z'")
      z.each do |i|
        lmlo_create(i)
      end
    end
  
    desc "Get status 'x' item records"
    task:get_status_x => :get_status_z do
      x = ItemView.where("item_status_code = 'x'")
      x.each do |i|
        lmlo_create(i)
      end
    end 

    desc "Notify Users of new matierals"
    task:notify_users => :environment do#=> :run_all do
      @users = User.all
      @users.each do |user|
        LostNotify.new_report(user).deliver
      end
    end

  
    desc "run all losts"
    task :run_all => [
      :drop_losts,
      :get_status_p, 
      :get_status_l, 
      :get_status_dollar, 
      :get_status_z, 
      :get_status_x] do
    end
  end
end
