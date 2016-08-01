#
class UserAttractionsController < ProtectedController
  before_action :set_user_attraction, only: [:show, :update, :destroy]

  # GET /user_attractions
  # GET /user_attractions.json
  def index
    @user_attractions = UserAttraction.all

    render json: @user_attractions
  end

  # GET /user_attractions/1
  # GET /user_attractions/1.json
  def show
    render json: @user_attraction
  end

  def refresh_user_events(user)
    AttractionSuggestions.where('user_id = ?', user[:id]).delete_all
  end

  def update_user_tags(params)
    attraction_tags = AttractionTag.where 'attraction_id = ?',
                                          params[:attraction_id]
    attraction_tags.each do |attraction_tag|
      tag_params = {
        tag_id: attraction_tag[:tag_id],
        user_id: @current_user.id,
        like: params[:like]
      }
      UserTag.create(tag_params)
    end
    refresh_user_events(@current_user)
  end

  # POST /user_attractions
  # POST /user_attractions.json
  def create
    @user_attraction = UserAttraction.new(user_attraction_params)

    if @user_attraction.save
      update_user_tags(user_attraction_params)
      render json: @user_attraction, status: :created, location: @user_attraction
    else
      render json: @user_attraction.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /user_attractions/1
  # PATCH/PUT /user_attractions/1.json
  def update
    @user_attraction = UserAttraction.find(params[:id])

    if @user_attraction.update(user_attraction_params)
      head :no_content
    else
      render json: @user_attraction.errors, status: :unprocessable_entity
    end
  end

  # DELETE /user_attractions/1
  # DELETE /user_attractions/1.json
  def destroy
    @user_attraction.destroy

    head :no_content
  end

  private

  def set_user_attraction
    @user_attraction = UserAttraction.find(params[:id])
  end

  def user_attraction_params
    params.require(:user_attraction).permit(:attraction_id, :user_id, :like)
  end
end
