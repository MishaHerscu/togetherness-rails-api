#
class CitiesController < ProtectedController
  before_action :set_city, only: [:show, :update, :destroy]
  skip_before_action :authenticate, only: [:show, :index]

  # GET /cities
  # GET /cities.json
  def index
    @cities = City.all

    render json: @cities
  end

  # GET /cities/1
  # GET /cities/1.json
  def show
    render json: @city
  end

  # POST /cities
  # POST /cities.json
  def create
    @city = City.new(city_params)

    if @city.save
      render json: @city, status: :created, location: @city
    else
      render json: @city.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /cities/1
  # PATCH/PUT /cities/1.json
  def update
    return false if @current_user.admin == false
    @city = City.find(params[:id])

    if @city.update(city_params)
      head :no_content
    else
      render json: @city.errors, status: :unprocessable_entity
    end
  end

  # DELETE /cities/1
  # DELETE /cities/1.json
  def destroy
    return false if @current_user.admin == false
    @city.destroy

    head :no_content
  end

  private

  def set_city
    @city = City.find(params[:id])
  end

  def city_params
    params.require(:city).permit(:name)
  end
end
