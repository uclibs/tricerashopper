class SerialsController < ApplicationController
  before_action :set_serial, only: [:show, :edit, :update, :destroy]

  # GET /serials
  # GET /serials.json
  def index
    @search = Serial.search do
      fulltext params[:search]
      with :fund, params[:fund] unless params[:fund].nil?
      with :vendor, params[:vendor] unless params[:vendor].nil?
      with :format, params[:format] unless params[:format].nil?
      with :order_type, params[:order_type] unless params[:order_type].nil?
      with :acq_type, params[:acq_type] unless params[:acq_type].nil?

      facet :fund, :vendor, :format, :order_type, :acq_type

      paginate(per_page: 10)
    end

    @serials = @search.results
  end

  # GET /serials/1
  # GET /serials/1.json
  def show
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_serial
      @serial = Serial.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def serial_params
      params[:serial]
    end
end
