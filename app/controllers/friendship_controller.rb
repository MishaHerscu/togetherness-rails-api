#
class FriendshipController < ProtectedController
  before_action :set_friendship, only: [:show, :update, :destroy]

  def involved(user, friendship)
    true if friendship.requested_user == user || friendship.user == user
    false
  end

  # GET /friendships
  # GET /friendships.json
  def index
    @friendships = Friendship.where 'user = ?',
                                    @current_user ||
                                    'requested_user = ?',
                                    @current_user

    render json: @friendships
  end

  # GET /friendships/1
  # GET /friendships/1.json
  def show
    render json: @friendship if involved(@current_user, @friendship)
  end

  # POST /friendships
  # POST /friendships.json
  def create
    return false if friendship_params.requested_user ==
                    friendship_params.user
    begin
      @friendship = Friendship.new(friendship_params)
    rescue ActiveRecord::RecordNotUnique
      p 'attempted duplicate record creation'
    end
    if @friendship.save
      render json: @friendship, status: :created, location: @friendship
    else
      render json: @friendship.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /friendships/1
  # PATCH/PUT /friendships/1.json

  # THERE IS NO UPDATE
  # def update
  #   @friendship = Friendship.find(params[:id])
  #
  #   if @friendship.user_id == @current_user.id
  #     if @friendship.update(friendship_params)
  #       head :no_content
  #     else
  #       render json: @friendship.errors, status: :unprocessable_entity
  #     end
  #   end
  # end

  # DELETE /friendships/1
  # DELETE /friendships/1.json
  def destroy
    @friendship.destroy if involved(@current_user, @friendship)

    head :no_content
  end

  private

  def set_friendship
    @friendship = Friendship.find(params[:id])
  end

  def friendship_params
    params.require(:friendship).permit(:user, :requested_user)
  end
end
