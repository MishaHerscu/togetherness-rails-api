#
class AttractionTagsController < ProtectedController
  before_action :set_attraction_tag, only: [:show, :update, :destroy]

  # GET /attraction_tags
  # GET /attraction_tags.json
  def index
    @attraction_tags = AttractionTag.all

    render json: @attraction_tags
  end

  # GET /attraction_tags/1
  # GET /attraction_tags/1.json
  def show
    render json: @attraction_tag
  end

  # POST /attraction_tags
  # POST /attraction_tags.json
  def create
    @attraction_tag = AttractionTag.new(attraction_tag_params)

    if @attraction_tag.save
      render json: @attraction_tag, status: :created, location: @attraction_tag
    else
      render json: @attraction_tag.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /attraction_tags/1
  # PATCH/PUT /attraction_tags/1.json
  def update
    @attraction_tag = AttractionTag.find(params[:id])

    if @attraction_tag.update(attraction_tag_params)
      head :no_content
    else
      render json: @attraction_tag.errors, status: :unprocessable_entity
    end
  end

  # DELETE /attraction_tags/1
  # DELETE /attraction_tags/1.json
  def destroy
    @attraction_tag.destroy

    head :no_content
  end

  private

  def set_attraction_tag
    @attraction_tag = AttractionTag.find(params[:id])
  end

  def attraction_tag_params
    params.require(:attraction_tag).permit(:tag_id, :attraction_id)
  end
end
