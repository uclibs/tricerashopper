class ProblemsController < ApplicationController
  before_filter :authenticate_user!
  before_action :set_problem, only: [:show, :edit, :update, :destroy, :audit]

  respond_to :html

  def index
    @problems = Problem.all
      .paginate(per_page: 25, page: params[:page])
    @problems = @problems.where(type: params[:type]) unless params[:type].blank?
    @problems = @problems.where(record_num: params[:record_num]) unless params[:record_num].blank?
    @problem_facets = Problem.group(:type).count
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

  def audit
    respond_to do |format|
      if @problem.valid?
        flash[:notice] = "QC Problem #{@problem.record_num} unresolved"
      else
        @problem.destroy
      end
      format.js
    end
  end

  private
    def set_problem
      @problem = Problem.find(params[:id])
    end

    def problem_params
      params.require(:problem).permit(:title, :record_num, :record_type, :note)
    end
end
