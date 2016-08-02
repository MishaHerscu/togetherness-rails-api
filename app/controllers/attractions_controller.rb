#
class AttractionsController < ProtectedController
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
    return false if @current_user.admin == false
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
    return false if @current_user.admin == false
    @attraction.destroy

    head :no_content
  end

  private

  def set_attraction
    @attraction = Attraction.find(params[:id])
  end

  def attraction_params
    params.require(:attraction).permit(:eventful_id, :city_name, :country_name,
                                       :title, :description, :owner,
                                       :db_start_time, :db_stop_time,
                                       :event_date, :event_time,
                                       :event_time_zone, :all_day, :venue_id,
                                       :venue_name, :venue_address,
                                       :postal_code, :venue_url, :geocode_type,
                                       :latitude, :longitude,
                                       :image_information, :medium_image_url)
  end
end
