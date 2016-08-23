#
class AttendancesController < ProtectedController
  before_action :set_attendance, only: [:show, :update, :destroy]

  # GET /attendances
  # GET /attendances.json
  def index
    @attendances = Attendance.where 'user_id = ?',
                                    @current_user.id

    render json: @attendances
  end

  # GET /attendances/1
  # GET /attendances/1.json
  def show
    return false if @attendance.user_id != @current_user.id
    render json: @attendance
  end

  # POST /attendances
  # POST /attendances.json
  def create
    begin
      @attendance = Attendance.new(attendance_params)
    rescue ActiveRecord::RecordNotUnique
      p 'attempted duplicate record creation'
    end
    if @attendance.save
      render json: @attendance, status: :created, location: @attendance
    else
      render json: @attendance.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /attendances/1
  # PATCH/PUT /attendances/1.json
  def update
    @attendance = Attendance.find(params[:id])

    if @attendance.user_id == @current_user.id
      if @attendance.update(attendance_params)
        head :no_content
      else
        render json: @attendance.errors, status: :unprocessable_entity
      end
    end
  end

  # DELETE /attendances/1
  # DELETE /attendances/1.json
  def destroy
    return false if @attendance.user_id != @current_user.id
    @attendance.destroy

    head :no_content
  end

  private

  def set_attendance
    @attendance = Attendance.find(params[:id])
  end

  def attendance_params
    params.require(:attendance).permit(:user_id, :trip_id)
  end
end
