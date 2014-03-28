class LostMissingLongOverduesController < ApplicationController
  before_action :set_lost_missing_long_overdue, only: [:show, :edit, :update, :destroy]

  # GET /lost_missing_long_overdues
  # GET /lost_missing_long_overdues.json
  def index
    @lost_missing_long_overdues = LostMissingLongOverdue.all
  end

  # GET /lost_missing_long_overdues/1
  # GET /lost_missing_long_overdues/1.json
  def show
  end

  # GET /lost_missing_long_overdues/new
  def new
    @lost_missing_long_overdue = LostMissingLongOverdue.new
  end

  # GET /lost_missing_long_overdues/1/edit
  def edit
  end

  # POST /lost_missing_long_overdues
  # POST /lost_missing_long_overdues.json
  def create
    @lost_missing_long_overdue = LostMissingLongOverdue.new(lost_missing_long_overdue_params)

    respond_to do |format|
      if @lost_missing_long_overdue.save
        format.html { redirect_to @lost_missing_long_overdue, notice: 'Lost missing long overdue was successfully created.' }
        format.json { render action: 'show', status: :created, location: @lost_missing_long_overdue }
      else
        format.html { render action: 'new' }
        format.json { render json: @lost_missing_long_overdue.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /lost_missing_long_overdues/1
  # PATCH/PUT /lost_missing_long_overdues/1.json
  def update
    respond_to do |format|
      if @lost_missing_long_overdue.update(lost_missing_long_overdue_params)
        format.html { redirect_to @lost_missing_long_overdue, notice: 'Lost missing long overdue was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @lost_missing_long_overdue.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /lost_missing_long_overdues/1
  # DELETE /lost_missing_long_overdues/1.json
  def destroy
    @lost_missing_long_overdue.destroy
    respond_to do |format|
      format.html { redirect_to lost_missing_long_overdues_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_lost_missing_long_overdue
      @lost_missing_long_overdue = LostMissingLongOverdue.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def lost_missing_long_overdue_params
      params.require(:lost_missing_long_overdue).permit(:item_number, :bib_number, :title, :imprint, :isbn, :status, :checkouts, :location, :note, :call_number, :volume, :barcode, :due_date, :last_checkout)
    end
end
