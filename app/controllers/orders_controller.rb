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
    
        facet(:workflow_state)
        with(:workflow_state, params[:state]) if params[:state].present?
     end
  
    @orders = @search.results    
  end

  def show
    respond_with(@order)
  end

  def new
    @order = Order.new
    respond_with(@order)
  end

  def edit
  end

  def create
    @order = Order.new(order_params)
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
    @order.update(order_params)
    respond_with(@order)
  end

  def destroy
    @order.destroy
    respond_with(@order)
  end

  def accept_print
    @order = Order.find(params[:id])
    @order.accept_print!
    @order.save
    respond_with(@order)
  end

  def accept_noprint
    @order = Order.find(params[:id])
    @order.accept_noprint!
    @order.save
    respond_with(@order)
  end

  def accept_not_yet_published
    @order = Order.find(params[:id])
    @order.accept_not_yet_published!
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
    @orders = Order.where("workflow_state = 'print_queue'")
    
    if @orders.any? {|i| i.vendor_code.blank? }
      @blank_vendor_codes = Array.new
      @orders.each {|i| @blank_vendor_codes << view_context.link_to( i.id, order_path(i.id.to_s), target: '_blank') if i.vendor_code.blank?}
      
      flash[:notice] = "Vendor codes can\'t be blank for MARC export, check: "+  @blank_vendor_codes.join(", ")
      redirect_to orders_path and return
    end 
    
    if @orders.count > 0
      directory = "public/tmp/records"
      writer = MARC::Writer.new("#{directory}/#{DateTime.now.strftime('%Y%m%d')}export.mrc")
      @orders.each do |i|
      record = MARC::Record.new()
      record.append(MARC::DataField.new('020', ' ', ' ', ['a', i.isbn.to_s]))
      record.append(MARC::DataField.new('100', '0', '0', ['a', i.author]))
      record.append(MARC::DataField.new('245', '1', '0', ['a', i.title]))
      record.append(MARC::DataField.new('260', ' ', ' ', ['b', i.publisher], ['c', i.publication_date.to_s]))
      record.append(MARC::DataField.new('960', ' ', ' ', ['h', i.notify.presence ? 'r' : '-'], ['j', i.rush_order.presence ? 'n' : '-'], ['o', '1'], ['s', i.cost.to_s], ['t', i.location_code], ['u', i.fund], ['v', i.vendor_code]))
       f961 = MARC::DataField.new('961', ' ', ' ', ['f', i.selector])
      if i.other_notes.length > 0
         f961.append(MARC::Subfield.new('d', i.other_notes))
      end
      if i.vendor_note.length > 0
        f961.append(MARC::Subfield.new('h', i.vendor_note))
      end
      if i.notification_contact.length > 0
        f961.append(MARC::Subfield.new('c', i.notification_contact))
      end
      record.append(f961)
      writer.write(record)
      i.export_to_marc!
      i.save
      end
      writer.close()
      flash[:notice] = "Records Processed"
      redirect_to marc_downloads_path
    else
      flash[:notice] = "No records to process"
      redirect_to orders_path
    end
  end

  private
    def set_order
      @order = Order.find(params[:id])
    end

    def order_params
      params.require(:order).permit(:title, :author, :format, :publication_date, :isbn, :publisher, :oclc, :edition, :selector, :requestor, :location_code, :fund, :cost, :added_edition, :added_copy, :added_copy_call_number, :rush_order, :rush_process, :notify, :reserve, :notification_contact, :relevant_url, :other_notes, :vendor_note, :vendor_code)
    end
end
