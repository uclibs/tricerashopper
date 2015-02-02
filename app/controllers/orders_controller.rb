class OrdersController < ApplicationController
  before_filter :authenticate_user!
  before_action :set_order, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @search = Order.search do
      paginate(per_page: 25, page: params[:page])
        fulltext params[:search]
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
    @order.save
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

  def export_to_marc
    @orders = Order.where("workflow_state = 'print_queue'")
    if @orders.count > 0
      directory = "public/tmp/records"
      writer = MARC::Writer.new("#{directory}/#{DateTime.now.strftime('%Y%m%d')}export.mrc")
      @orders.each do |i|
      record = MARC::Record.new()
      record.append(MARC::DataField.new('020', '0', '0', ['a', i.isbn.to_s]))
      record.append(MARC::DataField.new('100', '0', '0', ['a', i.author]))
      record.append(MARC::DataField.new('245', '1', '0', ['a', i.title]))
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
      params.require(:order).permit(:title, :author, :format, :publication_date, :isbn, :publisher, :oclc, :edition, :selector, :requestor, :location_code, :fund, :cost, :added_edition, :added_copy, :added_copy_call_number, :rush_order, :rush_process, :notify, :reserve, :notification_contact, :relevant_url, :other_notes)
    end
end
