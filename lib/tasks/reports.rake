require 'resque/tasks'

def filter_delims(field)
  unless field.nil?
    field = field.gsub(/\|[af]/, '')
    field.gsub(/\|[a]/, '')
    field.gsub(/\|[b-z]/, ' ')
  end
end

@location_whitelist = ['u', 'h', 'tdp']

def lmlo_create(x)
  if((x.location_code[0] == 'u') || (x.location_code[0] == 'h') || (x.location_code =~ /tdp/)) && (x.location_code != 'tdpso')
    bibview = x.bib_views.first
    metadata = x.record_metadata
      Lost.create(
        item_number: x.record_num,
        bib_number: bibview.record_num,
        title: bibview.title,
        imprint: filter_delims(bibview.varfield_views.where(marc_tag: '260').first.try(:field_content) || nil),
        author: filter_delims(bibview.varfield_views.where(marc_tag: '100').first.try(:field_content) || nil),
        isbn: filter_delims(bibview.varfield_views.where(marc_tag: '020').collect {|r| r.field_content}.join(', ')),
        oclc: bibview.varfield_views.where("record_type_code = 'b' AND varfield_type_code = 'o'").first.try(:field_content) || nil, 
        status: x.item_status_code,
        checkouts: x.checkout_total,
        location: x.location_code,
        note: filter_delims(x.varfield_views.where("record_type_code = 'i' AND (varfield_type_code = 'x' OR varfield_type_code = 'm')").collect { |x| x.field_content }.join(', ')),
        call_number: filter_delims(x.item_record_property.call_number),
        volume: x.varfield_views.where("varfield_type_code = 'v'").first.try(:field_content) || nil,
        barcode: x.barcode,
        due_date: x.checkout.try(:due_gmt) || nil,
        last_checkout: x.last_checkout_gmt,
        created_at: x.record_creation_date_gmt,
        updated_at: x.record_metadata.record_last_updated_gmt
        ) 
  puts bibview.title
  puts x.location_code
  end
end 

@minus1month = Time.now - 1.months
@minus3months = Time.now - 3.months
@minus1year = Time.now - 1.year

def fiscal_year_beginning(x)
  if Time.now.month.to_i < 7
    Time.new((x - 1.year).year, 7, 1)
  else
    Time.new(x.year, 7, 1)
  end
end

namespace :reports do

  namespace :dda do
    
    def dda_create(x)
      if x.order_view.record_creation_date_gmt > fiscal_year_beginning(Time.now)
        DdaExpenditure.create(
          title: x.order_view.bib_view.title, 
          paid: x.paid_amt,
          fund: x.order_view.order_record_cmf.fund,
          paid_date: x.order_view.record_creation_date_gmt
      )
      end
    end


    desc "reset dda_expenditures table"
    task:reset => :environment do
      DdaExpenditure.destroy_all
    end  

    desc "get previous month's dda order/invoice items"
    task:get_dda => :reset do
      dda = InvoiceRecordLine.where("vendor_code = 'uypda'")
      dda.each do |i|
        dda_create(i)
      end
    end
  end

  namespace :losts do
   
    desc "reset losts table"
    task:reset => :environment do
      Lost.destroy_all
    end
  
    desc "Get status 'l' item records"
    task:get_status_l => :environment do
      l = ItemView.where("item_status_code = 'l'")
      l.each do |i|
        unless i.record_metadata.record_last_updated_gmt > @minus1year
          lmlo_create(i)
        end
      end
    end
  
    desc "Get status '$' item records"
    task:get_status_dollar => :environment do
      dollar = ItemView.where("item_status_code = '$'")
      dollar.each do |i|
        lmlo_create(i)
      end
    end
  
    desc "Get status 'z' item records"
    task:get_status_z => :environment do
      z = ItemView.where("item_status_code = 'z'")
      z.each do |i|
        lmlo_create(i)
      end
    end
  
    desc "Notify Users of new materials"
    task:notify_users =>  :environment do
      @users = Selector.all
      @users.each do |user|
        unless user.lmlo_receives_report == false 
          LmloUpdate.new_report(user).deliver
        end
      end
    end

  
    desc "run all losts"
    task :run_all => [
      :reset,
      :get_status_l, 
      :get_status_dollar, 
      :get_status_z] do
    end
  end
end
