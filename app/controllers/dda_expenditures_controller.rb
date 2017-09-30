class DdaExpendituresController < ApplicationController
  before_action :authenticate_user!
  before_action :set_dda_expenditure, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @dda_expenditures = DdaExpenditure.all 
    if params[:current_month] == 'true'
      @dda_sum = DdaExpenditure.current_month.group(:fund).sum(:paid)
    else 
      @dda_sum = DdaExpenditure.all.group(:fund).sum(:paid)
    end
    respond_with(@dda_expenditures)
  end

  def show
    respond_with(@dda_expenditures)
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
      params.require(:dda_expenditure).permit(:title, :paid, :fund, :paid_date, :current_month)
    end
end
