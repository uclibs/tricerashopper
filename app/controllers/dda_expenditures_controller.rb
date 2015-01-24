class DdaExpendituresController < ApplicationController
  before_filter :authenticate_user!
  before_action :set_dda_expenditure, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @search = DdaExpenditure.search do
      paginate(per_page: 25, page: params[:page])
        with(:fund)
          facet(:fund)
      order_by(params[:sort]) if params[:sort].present?
      end
    @dda_expenditures = @search.results
   @dda_all = DdaExpenditure.all 
    respond_with(@dda_expenditures)
  end

  def show
    respond_with(@dda_expenditure)
  end

  def new
    @dda_expenditure = DdaExpenditure.new
    respond_with(@dda_expenditure)
  end

  def edit
  end

  def create
    @dda_expenditure = DdaExpenditure.new(dda_expenditure_params)
    @dda_expenditure.save
    respond_with(@dda_expenditure)
  end

  def update
    @dda_expenditure.update(dda_expenditure_params)
    respond_with(@dda_expenditure)
  end

  def destroy
    @dda_expenditure.destroy
    respond_with(@dda_expenditure)
  end

  private
    def set_dda_expenditure
      @dda_expenditure = DdaExpenditure.find(params[:id])
    end

    def dda_expenditure_params
      params.require(:dda_expenditure).permit(:title, :paid, :fund, :paid_date)
    end
end
