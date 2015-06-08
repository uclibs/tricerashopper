class ProblemsController < ApplicationController
  before_filter :authenticate_user!
  before_action :set_problem, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @search = Problem.search do
      paginate(per_page: 25, page: params[:page])
      fulltext params[:search]
      with(:title)
      facet(:type)
      with(:type, params[:type]) if params[:type].present?
    end

      @problems = @search.results
  end

  def show
    respond_with(@problem)
  end

  def new
    @problem = Problem.new
    respond_with(@problem)
  end

  def edit
  end

  def create
    @problem = Problem.new(problem_params)
    @problem.save
    respond_with(@problem)
  end

  def update
    @problem.update(problem_params)
    respond_with(@problem)
  end

  def destroy
    @problem.destroy
    respond_with(@problem)
  end

  private
    def set_problem
      @problem = Problem.find(params[:id])
    end

    def problem_params
      params.require(:problem).permit(:title, :record_num, :record_type, :description)
    end
end
