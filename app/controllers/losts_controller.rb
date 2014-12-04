class LostsController < ApplicationController
  before_filter :authenticate_user!
  before_action :set_lost, only: [:show, :edit, :update, :destroy]

  # GET /losts
  # GET /losts.json
  def index
   
    @search = Lost.search do 
      paginate(per_page: 25, page: params[:page])
        fulltext params[:search]
          with(:title)
          with(:call_number)
            facet(:class_trunc, sort: :index)
         with(:class_trunc, params[:trunc]) if params[:trunc].present? 
         facet(:class_full, sort: :index)
           with(:class_full, params[:full]) if params[:full].present?

         with(:location)
           locations = with(:loc_trunc, params[:loc]) if params[:loc].present?
           if params[:loc].present?
             facet :loc_trunc, exclude: [locations]
           else
             facet :loc_trunc
           end  
    order_by(params[:sort]) if params[:sort].present?
    end

    @losts = @search.results
  
  end
  # GET /losts/1
  # GET /losts/1.json
  def show
  end

  # GET /losts/new
  def new
    @lost = Lost.new
  end

  # GET /losts/1/edit
  def edit
  end

  # POST /losts
  # POST /losts.json
  def create
    @lost = Lost.new(lost_params)

    respond_to do |format|
      if @lost.save
        format.html { redirect_to @lost, notice: 'Lost was successfully created.' }
        format.json { render action: 'show', status: :created, location: @lost }
      else
        format.html { render action: 'new' }
        format.json { render json: @lost.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /losts/1
  # PATCH/PUT /losts/1.json
  def update
    respond_to do |format|
      if @lost.update(lost_params)
        format.html { redirect_to @lost, notice: 'Lost was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @lost.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /losts/1
  # DELETE /losts/1.json
  def destroy
    @lost.destroy
    respond_to do |format|
      format.html { redirect_to losts_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_lost
      @lost = Lost.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def lost_params
      params.require(:lost).permit(:item_number, :bib_number, :title, :imprint, :isbn, :status, :checkouts, :location, :note, :call_number, :volume, :barcode, :due_date, :last_checkout)
    end
end
