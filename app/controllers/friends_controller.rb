#
class FriendsController < ProtectedController
  before_action :set_friend, only: [:show, :update, :destroy]

  def involved(user, friendship)
    if friendship.requested_user == user || friendship.requesting_user == user
      return true
    else
      return false
    end
  end

  # GET /friends
  # GET /friends.json
  def index
    @friends = Friend.where 'requested_user = ?',
                            @current_user.id ||
                            'requesting_user = ?',
                            @current_user.id

    render json: @friends
  end

  # GET /friends/1
  # GET /friends/1.json
  def show
    render json: @friend if involved(@current_user, @friend)
  end

  # POST /friends
  # POST /friends.json
  def create
    return false if friend_params.requested_user ==
                    friend_params.requesting_user
    @friend = Friend.new(friend_params)

    if @friend.save
      render json: @friend, status: :created, location: @friend
    else
      render json: @friend.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /friends/1
  # PATCH/PUT /friends/1.json

  # THERE IS NO UPDATE
  # def update
  #   @friend = Friend.find(params[:id])
  #
  #   if @friend.user_id == @current_user.id
  #     if @friend.update(friend_params)
  #       head :no_content
  #     else
  #       render json: @friend.errors, status: :unprocessable_entity
  #     end
  #   end
  # end

  # DELETE /friends/1
  # DELETE /friends/1.json
  def destroy
    @friend.destroy if involved(@current_user, @friend)

    head :no_content
  end

  private

  def set_friend
    @friend = Friend.find(params[:id])
  end

  def friend_params
    params.require(:friend).permit(:requested_user, :requesting_user)
  end
end
