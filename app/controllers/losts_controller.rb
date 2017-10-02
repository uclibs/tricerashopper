class LostsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_lost, only: [:show, :edit, :update, :destroy, :toggle_reviewed_status]

  # GET /losts
  # GET /losts.json
  def index
    @search = Lost.search do 
      paginate(per_page: 20, page: params[:page])
      fulltext params[:search]
      with(:title)
      with(:call_number)

      facet(:class_trunc, sort: :index)
      with(:class_trunc, params[:trunc]) if params[:trunc].present? 

      facet(:class_full, sort: :index)
      with(:class_full, params[:full]) if params[:full].present?

      with(:reviewed, to_bool(params[:reviewed])) if params[:reviewed].present?

      with(:location)
      locations = with(:loc_trunc, params[:loc]) if params[:loc].present?

      if params[:loc].present?
        facet :loc_trunc, exclude: [locations]
      else
        facet :loc_trunc
      end  
      order_by(params[:sort], :asc) if params[:sort].present?
      order_by(:id, :asc) unless params[:sort].present?
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

  def toggle_reviewed_status
    @lost.toggle!(:reviewed)
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_lost
      @lost = Lost.find(params[:id])
    end

    #catch string in param and convert to bool
    def to_bool(i)
      i.downcase == "true"
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def lost_params
      params.require(:lost).permit(:item_number, :bib_number, :title, :imprint, :isbn, :status, :checkouts, :location, :note, :call_number, :volume, :barcode, :due_date, :last_checkout, :author, :reviewed)
    end
end
