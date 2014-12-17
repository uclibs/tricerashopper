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
        isbn: filter_delims(bibview.varfield_views.where(marc_tag: '020').collect {|r| r.field_content}.join(', ')),
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
end 

@minus3months = Time.now - 3.months
@minus1year = Time.now - 1.year

namespace :reports do

  namespace :losts do
    desc "reset losts table"
    task:reset => :environment do
      Lost.destroy_all
    end
  
    desc "Get status'p' records"
    task:get_status_p => :environment do
      
      p = ItemView.where("item_status_code = 'p'")
      p.each do |i|
        unless i.record_metadata.record_last_updated_gmt > @minus3months || i.bib_views.first.cataloging_date_gmt.nil? || i.bib_views.first.bcode3 == 's'
          lmlo_create(i) 
        end
      end
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
  
    desc "Get status 'x' item records"
    task:get_status_x => :environment do
      x = ItemView.where("item_status_code = 'x'")
      x.each do |i|
        lmlo_create(i)
      end
    end 

    desc "Notify Users of new materials"
    task:notify_users =>  :environment do
      @users = User.all
      @users.each do |user|
        LmloUpdate.new_report(user).deliver
      end
    end

  
    desc "run all losts"
    task :run_all => [
      #:get_status_p, 
      :reset,
      :get_status_l, 
      :get_status_dollar, 
      :get_status_z, 
      :get_status_x] do
    end
  end
end
