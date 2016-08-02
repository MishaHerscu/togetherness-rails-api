#
class TagsController < ProtectedController
  before_action :set_tag, only: [:show, :update, :destroy]

  # GET /tags
  # GET /tags.json
  def index
    # return false if @current_user.admin == false
    @tags = Tag.all

    render json: @tags
  end

  # GET /tags/1
  # GET /tags/1.json
  def show
    # return false if @current_user.admin == false
    render json: @tag
  end

  # POST /tags
  # POST /tags.json
  def create
    # return false if @current_user.admin == false
    @tag = Tag.new(tag_params)

    if @tag.save
      render json: @tag, status: :created, location: @tag
    else
      render json: @tag.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /tags/1
  # PATCH/PUT /tags/1.json
  def update
    return false if @current_user.admin == false
    @tag = Tag.find(params[:id])

    if @tag.update(tag_params)
      head :no_content
    else
      render json: @tag.errors, status: :unprocessable_entity
    end
  end

  # DELETE /tags/1
  # DELETE /tags/1.json
  def destroy
    return false if @current_user.admin == false
    @tag.destroy

    head :no_content
  end

  private

  def set_tag
    @tag = Tag.find(params[:id])
  end

  def tag_params
    params.require(:tag).permit(:tag, :usages, :relative_usage)
  end
end
