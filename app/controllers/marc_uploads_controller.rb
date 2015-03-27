class MarcUploadsController < ApplicationController
before_filter :authenticate_user!
def create
     redirect_to marc_uploads_path and flash[:notice] = 'Include file!' and return if params[:upload].nil?
     name = params[:upload][:file].original_filename
     redirect_to marc_uploads_path and flash[:notice] = 'Input only .xlsx format files!' and return if File.extname(name) != '.xlsx' 
     directory = "public/tmp/records"
     @path = File.join(directory, name)
   
     File.open(@path, "wb") { |f| f.write(params[:upload][:file].read) }
     s = Roo::Excelx.new(@path)
     redirect_to marc_uploads_path and flash[:notice] = 'Columns must be in order: Label, Catalog, Title, UPC, Format, Invoice, Price' and return if s.row(1) != ['Label', 'Catalog', 'Title', 'UPC', 'Format', 'Invoice', 'Price']

     writer = MARC::Writer.new("#{directory}/#{name.gsub('xlsx', 'mrc')}")
       s.drop(1).each do |row|
       record = MARC::Record.new()
       record.append(MARC::DataField.new('024', '0', '0', ['a', row[3].to_s]))
       record.append(MARC::DataField.new('245', '0', '0', ['a', row[2]]))
       record.append(MARC::DataField.new('260', ' ', ' ', ['b', row[0]]))
       record.append(MARC::DataField.new('300', ' ', ' ', ['a', row[4].to_s]))
       record.append(MARC::DataField.new('961', ' ', ' ', ['d', "Invoice # #{row[5].to_i.to_s}"]))
       record.append(MARC::DataField.new('980', ' ', ' ', ['a', Time.now.strftime("%y%m%d")], ['b', row[6].to_s.gsub('.', '')], ['e', row[6].to_s.gsub('.', '')], ['f', row[5].to_i.to_s], ['g', '1']))
       record.append(MARC::DataField.new('981', ' ', ' ', ['b', 'vcnfi'], ['c', 'UCM']))
       writer.write(record)
     end
     writer.close()
     flash[:notice] = "Records Processed" 
     redirect_to marc_downloads_path
    end
   end
