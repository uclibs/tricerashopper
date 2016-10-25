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
        facet(:rush_order)
        facet(:reserve)
        facet(:format)
        with(:workflow_state, params[:state]) if params[:state].present?
          facet(:workflow_state)
        with(:rush_order, params[:rush]) if params[:rush].present?
        with(:reserve, params[:reserve]) if params[:reserve].present?
        with(:format, params[:format]) if params[:format].present?
     end
  
    @orders = @search.results    
  end

  def show
    respond_with(@order)
  end

  def new

    def get_selectors
      if current_user.type == 'Assistant'
       "#{current_user.email}, #{current_user.selector.email}"
      else
        current_user.email
      end
    end
    
    @order = Order.new(author: params[:author], title: params[:title], publisher: params[:publisher], isbn: params[:isbn], oclc: params[:oclc], edition: params[:edition], language: params[:language], location_code: params[:location], selector: get_selectors)
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
      
      #for creation of provisional rush and/or reserve orders and regular provisional orders
      if @user.instance_of? Assistant
        if @order.rush_order && @order.reserve
          @subj = "[tricerashopper] RUSH RESERVE Provisional Order Confirmation - " + @order.format
        elsif @order.rush_order
          @subj = "[tricerashopper] RUSH Provisional Order Confirmation - " + @order.format
        elsif @order.reserve
          @subj = "[tricerashopper] RESERVE Provisional Order Confirmation - " + @order.format
        else
          @subj = "[tricerashopper] Provisional Order Confirmation - " + @order.format
        end
        OrderMailer.provisional_order(@order, @subj).deliver
      
      #for creation of regular rush and/or reserve orders and regular selector orders    
      else    
        if @order.reserve && @order.rush_order
          @subj = "[tricerashopper] RUSH RESERVE Order Confirmation - " + @order.format
        elsif @order.reserve
          @subj = "[tricerashopper] RESERVE Order Confirmation - " + @order.format
        elsif @order.rush_order
          @subj = "[tricerashopper] RUSH Order Confirmation - " + @order.format 
        else
          @subj = "[tricerashopper] Order Confirmation - " + @order.format
        end
        @order.approve_selection!
        OrderMailer.new_order(@order, @subj).deliver
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
    OrderMailer.ordered_order(@order).deliver
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
    OrderMailer.rejected_order(@order).deliver
    respond_with(@order)
  end

  def approve_selection
    @order = Order.find(params[:id])
    @order.approve_selection!
    @order.save
    respond_with(@order)
    if @order.rush_order && @order.reserve
      @subj = "[tricerashopper] RUSH RESERVE Approved Provisional Order Confirmation - " + @order.format
    elsif @order.rush_order
      @subj = "[tricerashopper] RUSH Approved Provisional Order Confirmation - " + @order.format
    elsif @order.reserve
      @subj = "[tricerashopper] RESERVE Approved Provisional Order Confirmation - " + @order.format
    else
      @subj = "[tricerashopper] Approved Provisional Order Confirmation - " + @order.format
    end
    OrderMailer.new_order(@order, @subj).deliver
  end

  def export_to_marc
    
    def create_marc(order)
      record = MARC::Record.new()
      fl = '                                      '
      fl[35] = order.language
      record.append(MARC::ControlField.new('008', value = fl))
      record.append(MARC::DataField.new('020', ' ', ' ', ['a', order.isbn.to_s]))
      record.append(MARC::DataField.new('100', '0', ' ', ['a', order.author]))
      record.append(MARC::DataField.new('245', '1', '0', ['a', order.title]))
      record.append(MARC::DataField.new('260', ' ', ' ', ['b', order.publisher], ['c', order.publication_date.to_s]))
 
      f960 = MARC::DataField.new('960', ' ', ' ', ['o', '1'], ['t', order.location_code], ['u', order.fund], ['v', order.vendor_code])
      f960.append(MARC::Subfield.new('h', 'r')) unless order.rush_order.blank?
      f960.append(MARC::Subfield.new('s', order.cost.to_s)) unless order.cost.blank?
      f960.append(MARC::Subfield.new('j', 'n')) unless order.notify.blank?
      f960.append(MARC::Subfield.new('k', 'u'))
      f960.append(MARC::Subfield.new('l', 'u'))
      f960.append(MARC::Subfield.new('m', '2')) unless order.not_yet_published.blank?
      f960.append(MARC::Subfield.new('a', 'b')) unless order.credit_card_order.blank?
      f960.append(MARC::Subfield.new('z', order.currency)) unless order.currency == 'USD'
      f960.append(MARC::Subfield.new('w', order.language))
      
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
      redirect_to downloads_path

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
      params.require(:order).permit(:title, :author, :format, :publication_date, :isbn, :publisher, :series, :oclc, :edition, :language, :selector, :requestor, :location_code, :fund, :cost, :currency, :added_edition, :added_copy, :added_copy_call_number, :rush_order, :notify, :reserve, :notification_contact, :relevant_url, :other_notes, :vendor_note, :vendor_code, :not_yet_published, :not_yet_published_date, :vendor_address, :credit_card_order, :internal_note, :processing_note)
    end
end
