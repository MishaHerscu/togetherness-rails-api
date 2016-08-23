#
class FriendRequestsController < ProtectedController
  before_action :set_friend_request, only: [:show, :update, :destroy]

  def involved(user, friend_request)
    true if friend_request.requested_user == user || friend_request.user == user
    false
  end

  # GET /friend_requests
  # GET /friend_requests.json
  def index
    @friend_requests = FriendRequest.where 'user = ?',
                                           @current_user ||
                                           'requested_user = ?',
                                           @current_user
    render json: @friend_requests
  end

  # GET /friend_requests/1
  # GET /friend_requests/1.json
  def show
    render json: @friendship if involved(@current_user, @friend_request)
  end

  # POST /friend_requests
  # POST /friend_requests.json
  def create
    return false if friend_request_params.requested_user ==
                    friend_request_params.user
    begin
      @friend_request = FriendRequest.new(friend_request_params)
      @friend_request.user_id = @current_user.id
    rescue ActiveRecord::RecordNotUnique
      p 'attempted duplicate record creation'
    end
    if @friend_request.save
      render json: @friend_request, status: :created, location: @friend_request
    else
      render json: @friend_request.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /friend_requests/1
  # PATCH/PUT /friend_requests/1.json

  # THERE IS NO UPDATE
  # def update
  #   @friend_request = FriendRequest.find(params[:id])
  #   if involved(@current_user, @friend_request)
  #     if @friend_request.update(friend_request_params)
  #       head :no_content
  #     else
  #       render json: @friend_request.errors, status: :unprocessable_entity
  #     end
  #   end
  # end

  # DELETE /friend_requests/1
  # DELETE /friend_requests/1.json
  def destroy
    @friend_request.destroy if involved(@current_user, @friend_request)

    head :no_content
  end

  private

  def set_friend_request
    @friend_request = FriendRequest.find(params[:id])
  end

  def friend_request_params
    params.require(:friend_request).permit(:user_id, :requested_user_id)
  end
end
