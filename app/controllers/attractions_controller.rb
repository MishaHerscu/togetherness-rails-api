#
class AttractionsController < ApplicationController
  before_action :set_attraction, only: [:show, :update, :destroy]

  # GET /attractions
  # GET /attractions.json
  def index
    @attractions = Attraction.all

    render json: @attractions
  end

  # GET /attractions/1
  # GET /attractions/1.json
  def show
    render json: @attraction
  end

  # POST /attractions
  # POST /attractions.json
  def create
    @attraction = Attraction.new(attraction_params)

    if @attraction.save
      render json: @attraction, status: :created, location: @attraction
    else
      render json: @attraction.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /attractions/1
  # PATCH/PUT /attractions/1.json
  def update
    @attraction = Attraction.find(params[:id])

    if @attraction.update(attraction_params)
      head :no_content
    else
      render json: @attraction.errors, status: :unprocessable_entity
    end
  end

  # DELETE /attractions/1
  # DELETE /attractions/1.json
  def destroy
    @attraction.destroy

    head :no_content
  end

  private

  def set_attraction
    @attraction = Attraction.find(params[:id])
  end

  def attraction_params
    params.require(:attraction).permit(:city_name, :country_name, :title,
                                       :description, :owner, :start_time,
                                       :stop_time, :all_day, :venue_name,
                                       :venue_address, :venue_url)
  end
end
