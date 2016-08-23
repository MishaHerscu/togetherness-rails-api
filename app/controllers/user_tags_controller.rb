#
class UserTagsController < ProtectedController
  before_action :set_user_tag, only: [:show, :update, :destroy]

  # GET /user_tags
  # GET /user_tags.json
  def index
    @user_tags = UserTag.where 'user_id = ?',
                               @current_user.id

    render json: @user_tags
  end

  # GET /user_tags/1
  # GET /user_tags/1.json
  def show
    render json: @user_tag if @user_tag.user_id == @current_user.id
  end

  # POST /user_tags
  # POST /user_tags.json
  def create
    begin
      @user_tag = UserTag.new(user_tag_params)
    rescue ActiveRecord::RecordNotUnique
      p 'attempted duplicate record creation'
    end
    if @user_tag.save
      render json: @user_tag, status: :created, location: @user_tag
    else
      render json: @user_tag.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /user_tags/1
  # PATCH/PUT /user_tags/1.json
  def update
    @user_tag = UserTag.find(params[:id])

    if @user_tag.user_id == @current_user.id
      if @user_tag.update(user_tag_params)
        head :no_content
      else
        render json: @user_tag.errors, status: :unprocessable_entity
      end
    end
  end

  # DELETE /user_tags/1
  # DELETE /user_tags/1.json
  def destroy
    @user_tag.destroy if @user_tag.user_id == @current_user.id

    head :no_content
  end

  private

  def set_user_tag
    @user_tag = UserTag.find(params[:id])
  end

  def user_tag_params
    params.require(:user_tag).permit(:tag_id, :user_id, :like)
  end
end
