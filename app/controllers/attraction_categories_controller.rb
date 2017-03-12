#
class AttractionCategoriesController < ProtectedController
  before_action :set_attraction_category, only: [:show, :update, :destroy]

  # GET /attraction_categories
  # GET /attraction_categories.json
  def index
    @attraction_categories = AttractionCategory.all

    render json: @attraction_categories
  end

  # GET /attraction_categories/1
  # GET /attraction_categories/1.json
  def show
    render json: @attraction_category
  end

  # POST /attraction_categories
  # POST /attraction_categories.json
  def create
    @attraction_category = AttractionCategory.new(attraction_category_params)

    if @attraction_category.save
      render json: @attraction_category, status: :created, location: @attraction_category
    else
      render json: @attraction_category.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /attraction_categories/1
  # PATCH/PUT /attraction_categories/1.json

  # THERE IS NO UPDATE
  # def update
  #   @attraction_category = AttractionCategory.find(params[:id])
  #
  #   if @attraction_category.update(attraction_category_params)
  #     head :no_content
  #   else
  #     render json: @attraction_category.errors, status: :unprocessable_entity
  #   end
  # end

  # DELETE /attraction_categories/1
  # DELETE /attraction_categories/1.json
  def destroy
    return false if @current_user.admin == false
    @attraction_category.destroy

    head :no_content
  end

  private

  def set_attraction_category
    @attraction_category = AttractionCategory.find(params[:id])
  end

  def attraction_category_params
    params.require(:attraction_category).permit(:attraction_id, :category_id)
  end
end
