class MarcUploadsController < ApplicationController
 def create
     redirect_to '/marc_uploads' and flash[:notice] = 'Include file!' and return if params[:upload].nil?
     name = params[:upload][:file].original_filename
     redirect_to '/marc_uploads' and flash[:notice] = 'Input only .xlsx format files!' and return if File.extname(name) != '.xlsx' 
     directory = "public/tmp/records"
     @path = File.join(directory, name)
   
     File.open(@path, "wb") { |f| f.write(params[:upload][:file].read) }
     s = Roo::Excelx.new(@path)
     redirect_to '/marc_uploads' and flash[:notice] = 'Columns must be in order: Label, Catalog, Title, UPC, Format, Order#, Price' and return if s.row(1) != ['Label', 'Catalog', 'Title', 'UPC', 'Format', 'Order #', 'Price']

     writer = MARC::Writer.new("#{directory}/#{name.gsub('xlsx', 'mrc')}")
       s.drop(1).each do |row|
       record = MARC::Record.new()
       record.append(MARC::DataField.new('024', '0', '0', ['a', row[3].to_s]))
       record.append(MARC::DataField.new('245', '0', '0', ['a', row[2]]))
       record.append(MARC::DataField.new('260', ' ', ' ', ['b', row[0]]))
       record.append(MARC::DataField.new('300', ' ', ' ', ['a', row[4].to_s]))
       record.append(MARC::DataField.new('960', ' ', ' ', ['g', 'c'], ['o', '1'], ['s', row[6].to_s], ['t', 'ucm'], ['u', 'vcnfi'], ['v', 'uarkm'], ['z', 'USD'], ['m', '1']))
       record.append(MARC::DataField.new('961', ' ', ' ', ['d', "Invoice # #{row[5].to_i.to_s}"]))
       record.append(MARC::DataField.new('949', ' ', ' ', ['a', 'bn=bucm']))
       writer.write(record)
     end
     writer.close()
     flash[:notice] = "Records Processed" 
     redirect_to "/marc_downloads"
    end
   end
