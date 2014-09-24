class MarcUploadsController < ApplicationController
 def create
     redirect_to '/marc_uploads' and flash[:notice] = 'Include file!' and return if params[:upload].nil?
     name = params[:upload][:file].original_filename
     redirect_to '/marc_uploads' and flash[:notice] = 'Input only .xlsx format files!' and return if File.extname(name) != '.xlsx' 
     directory = "public/tmp/records"
     @path = File.join(directory, name)
   
     File.open(@path, "wb") { |f| f.write(params[:upload][:file].read) }
     s = Roo::Excelx.new(@path)
    
     writer = MARC::Writer.new("#{directory}/#{name.gsub('xlsx', 'mrc')}")
       s.drop(1).each do |row|
       record = MARC::Record.new()
       record.append(MARC::DataField.new('024', '0', '0', ['a', row[3]]))
       record.append(MARC::DataField.new('245', '0', '0', ['a', row[2]]))
       record.append(MARC::DataField.new('260', '0', '0', ['b', row[0]]))
       record.append(MARC::DataField.new('300', '0', '0', ['a', row[4]]))
       record.append(MARC::DataField.new('960', '', '', ['g', 'c'], ['o', '1'], ['s', row[6].to_s], ['t', 'ucm'], ['u', 'nccm'], ['v', 'uarkm'], ['z', 'USD']))
       record.append(MARC::DataField.new('961', '', '', ['d', "Invoice # #{row[5].to_s}"]))
       writer.write(record)
     end
     writer.close()
     flash[:notice] = "Records Processed" 
     redirect_to "/marc_downloads"
    end
   end
