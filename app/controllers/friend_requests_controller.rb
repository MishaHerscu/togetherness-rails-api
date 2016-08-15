#
class FriendRequestsController < ProtectedController
  before_action :set_friend_request, only: [:show, :update, :destroy]

  # GET /friend_requests
  # GET /friend_requests.json
  def index
    @friend_requests = FriendRequest.where 'requesting_user = ?',
                                           @current_user.id

    render json: @friend_requests
  end

  # GET /friend_requests/1
  # GET /friend_requests/1.json
  def show
    return false if @friend_request.requesting_user.id != @current_user.id
    render json: @friend_request
  end

  # POST /friend_requests
  # POST /friend_requests.json
  def create
    @friend_request = FriendRequest.new(friend_request_params)

    if @friend_request.save
      render json: @friend_request, status: :created, location: @friend_request
    else
      render json: @friend_request.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /friend_requests/1
  # PATCH/PUT /friend_requests/1.json
  def update
    return false if @friend_request.requesting_user.id != @current_user.id
    @friend_request = FriendRequest.find(params[:id])

    if @friend_request.update(friend_request_params)
      head :no_content
    else
      render json: @friend_request.errors, status: :unprocessable_entity
    end
  end

  # DELETE /friend_requests/1
  # DELETE /friend_requests/1.json
  def destroy
    return false if @friend_request.requesting_user.id != @current_user.id
    @friend_request.destroy

    head :no_content
  end

  private

  def set_friend_request
    @friend_request = FriendRequest.find(params[:id])
  end

  def friend_request_params
    params.require(:friend_request).permit(:requested_user, :requesting_user)
  end
end
