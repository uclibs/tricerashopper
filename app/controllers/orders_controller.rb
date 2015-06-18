class OrdersController < ApplicationController

  before_filter :authenticate_user!
  before_action :set_order, only: [:show, :edit, :update, :destroy]

  respond_to :html

 def index
      @search = Order.search do
        @user = current_user
        paginate(per_page: 20, page: params[:page])
        fulltext params[:search]
        with(:user_id, @user.assistants.pluck(:id) << @user.id) unless @user.instance_of? Admin
        with(:title)
        order_by(:id, :desc)
        facet(:workflow_state)
        with(:workflow_state, params[:state]) if params[:state].present?
     end
  
    @orders = @search.results    
  end

  def show
    respond_with(@order)
  end

  def new
    @order = Order.new(author: params[:author], title: params[:title], publisher: params[:publisher], isbn: params[:isbn], oclc: params[:oclc], location_code: params[:location])
    respond_with(@order)
  end

  def edit
  end

  def create
    attributes = convert_cost_to_int(order_params)
    @order = Order.new(attributes)
    @user = current_user
    @order.user_id = @user.id
    if @order.save
      OrderMailer.new_order(@user, @order).deliver
    unless @user.instance_of? Assistant
      @order.approve_selection!
      @order.save
    end
    end
    respond_with(@order)
  end

  def update
   
    attributes = convert_cost_to_int(order_params)
    @order.update(attributes)
    
    respond_with(@order)
  end

  def destroy
    @order.destroy
    respond_with(@order)
  end

  def marc_yes_po
    @order = Order.find(params[:id])
    @order.marc_yes_po!
    @order.save
    respond_with(@order)
  end

  def marc_no_po
    @order = Order.find(params[:id])
    @order.marc_no_po!
    @order.save
    respond_with(@order)
  end

  def ordered
    @order = Order.find(params[:id])
    @order.ordered!
    @order.save
    respond_with(@order)
  end

  def temporary_hold
    @order = Order.find(params[:id])
    @order.temporary_hold!
    @order.save
    respond_with(@order)
  end

  def reject 
    @order = Order.find(params[:id])
    @order.reject!
    @order.save
    respond_with(@order)
  end

  def approve_selection
    @order = Order.find(params[:id])
    @order.approve_selection!
    @order.save
    respond_with(@order)
  end

  def provisional
  end

  def export_to_marc
    
    def create_marc(order)
      record = MARC::Record.new()
      record.append(MARC::DataField.new('020', ' ', ' ', ['a', order.isbn.to_s]))
      record.append(MARC::DataField.new('100', '0', ' ', ['a', order.author]))
      record.append(MARC::DataField.new('245', '1', '0', ['a', order.title]))
      record.append(MARC::DataField.new('260', ' ', ' ', ['b', order.publisher], ['c', order.publication_date.to_s]))
 
      f960 = MARC::DataField.new('960', ' ', ' ', ['o', '1'], ['t', order.location_code], ['u', order.fund], ['v', order.vendor_code])
      f960.append(MARC::Subfield.new('h', 'r')) unless order.rush_order.blank?
      f960.append(MARC::Subfield.new('s', order.cost.to_s)) unless order.cost.blank?
      f960.append(MARC::Subfield.new('j', 'n')) unless order.notify.blank?
      f960.append(MARC::Subfield.new('m', '2')) unless order.not_yet_published.blank?
      f960.append(MARC::Subfield.new('a', 'b')) unless order.credit_card_order.blank?
      
      record.append(f960)

      f961 = MARC::DataField.new('961', ' ', ' ', ['f', order.selector])
      f961.append(MARC::Subfield.new('d', order.other_notes)) unless order.other_notes.blank?
      f961.append(MARC::Subfield.new('h', order.vendor_note)) unless order.vendor_note.blank?
      f961.append(MARC::Subfield.new('c', "Notify #{order.notification_contact}")) unless order.notification_contact.blank?
      f961.append(MARC::Subfield.new('x', "NYP Order$#{order.not_yet_published_date.strftime('%Y%m%d')}$moenads@ucmail.uc.edu$NYP- Expected date #{order.not_yet_published_date.strftime('%m/%d/%Y')}")) unless order.not_yet_published.blank?
      f961.append(MARC::Subfield.new('j', order.processing_note)) unless order.processing_note.blank?
      f961.append(MARC::Subfield.new('d', order.internal_note)) unless order.internal_note.blank?
      f961.append(MARC::Subfield.new('q', order.vendor_address)) unless order.vendor_address.blank?
      record.append(f961)
      @record = record
    end 
   
    @orders = Order.where("workflow_state = 'marc_yes_po' OR workflow_state = 'marc_no_po'") 

    if @orders.any? {|i| i.vendor_code.blank? }
      @blank_vendor_codes = Array.new
      @orders.each {|i| @blank_vendor_codes << view_context.link_to( i.id, order_path(i.id.to_s), target: '_blank') if i.vendor_code.blank?}
      
      flash[:notice] = "Vendor codes can\'t be blank for MARC export, check: "+  @blank_vendor_codes.join(", ")
      redirect_to orders_path and return
    end 
 
    directory = "public/tmp/records"
    if  @orders.any? {|i| i.workflow_state == 'marc_yes_po' }
      pofile = true
      writerPrintPO = MARC::Writer.new("#{directory}/#{DateTime.now.strftime('%Y%m%d')}export_YesPO.mrc")
    else 
      poFile = false
    end

    if @orders.any? {|i| i.workflow_state == 'marc_no_po' }
      nopofile = true
      writerNoPO = MARC::Writer.new("#{directory}/#{DateTime.now.strftime('%Y%m%d')}export_NoPO.mrc")
    else
      nopoFile = false
    end
    
    if @orders.count > 0
      
      @orders.each do |order|
        create_marc(order)
        if order.workflow_state == 'marc_yes_po'
          writerPrintPO.write(@record)
          order.ordered! #transition to ordered state
        elsif order.workflow_state == 'marc_no_po'
          writerNoPO.write(@record)
          order.ordered! #transition to ordered state
        else
        flash[:notice] = "Some records not processed"
        end
        order.save
        end 
      writerNoPO.close() unless nopoFile == false
      writerPrintPO.close() unless poFile == false

      flash[:notice] = "Records Processed"
      redirect_to marc_downloads_path

    else
      flash[:notice] = "No records to process"
      redirect_to orders_path

    end
    end
 
      private

    def convert_cost_to_int(order_params)
      attributes = order_params.clone 
      attributes[:cost] = order_params[:cost].gsub(/[^\d\.]+/, '').to_d*100
      return attributes
    end

    def set_order
      @order = Order.find(params[:id])
    end

    def order_params
      params.require(:order).permit(:title, :author, :format, :publication_date, :isbn, :publisher, :series, :oclc, :edition, :selector, :requestor, :location_code, :fund, :cost, :currency, :added_edition, :added_copy, :added_copy_call_number, :rush_order, :notify, :reserve, :notification_contact, :relevant_url, :other_notes, :vendor_note, :vendor_code, :not_yet_published, :not_yet_published_date, :vendor_address, :credit_card_order, :internal_note, :processing_note)
    end
end
