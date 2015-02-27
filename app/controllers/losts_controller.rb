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
    if current_user.sign_in_count < 3
      flash[:notice] = "Mouse over ISBN for link to search for item in GOBI (you can select it if available)." 
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_lost
      @lost = Lost.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def lost_params
      params.require(:lost).permit(:item_number, :bib_number, :title, :imprint, :isbn, :status, :checkouts, :location, :note, :call_number, :volume, :barcode, :due_date, :last_checkout, :author)
    end
end
