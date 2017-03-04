# This is the controller where the important recommendation engine is
class UserAttractionsController < ProtectedController
  before_action :set_user_attraction, only: [:show, :update, :destroy]

  # GET /user_attractions
  # GET /user_attractions.json
  def index
    @user_attractions = UserAttraction.where 'user_id = ?',
                                             @current_user.id

    render json: @user_attractions
  end

  # GET /user_attractions/1
  # GET /user_attractions/1.json
  def show
    if @user_attractions.user_id == @current_user.id
      render json: @user_attraction
    end
  end

  # def filter_to_key_words(array)
  #   key_word_tags = Tag.where('relative_usage < ?', 70)
  #   array.keep_if { |tag| key_word_tags.include?(tag) }
  # end

  def overlap(tag_array_1, tag_array_2)
    result = 0
    tag_array_1.each do |tag|
      result += 1 if tag_array_2.include?(tag)
    end
    result / tag_array_1.length.to_f
  end

  def correlate_arrays(tag_array_1, tag_array_2)
    # filtered_array_1 = filter_to_key_words(tag_array_1.uniq.compact)
    # filtered_array_2 = filter_to_key_words(tag_array_2.uniq.compact)
    filtered_array_1 = tag_array_1.uniq.compact # temporary
    filtered_array_2 = tag_array_2.uniq.compact # temporary
    first_comparison = overlap(filtered_array_1, filtered_array_2)
    second_comparison = overlap(filtered_array_2, filtered_array_1)
    (first_comparison + second_comparison) / 2.to_f
  end

  def refresh_user_events(user)
    # Clear old attraction suggestions
    AttractionSuggestion.where(user_id: user[:id]).delete_all

    #
    # get all AttractionSuggestions attractions
    #

    # first step: get current user tags
    current_user_tags = UserTag.select('tag_id').where(
      user_id: user[:id],
      like: true
    )
    current_user_tag_ids = []
    correlation_cutoff = 0.2
    current_user_tags.each do |tag|
      current_user_tag_ids << tag[:tag_id]
    end

    # second step: get attractions that match
    attraction_suggestions = []
    Attraction.all.each do |attraction|
      attraction_tags = AttractionTag.where(attraction_id: attraction[:id])
      attraction_tag_ids = []
      attraction_tags.each do |attraction_tag|
        attraction_tag_ids << attraction_tag[:tag_id]
      end
      average_correlation = correlate_arrays(current_user_tag_ids,
                                             attraction_tag_ids)
      if average_correlation > correlation_cutoff
        attraction_suggestions << attraction
      end
    end

    # make new AttractionSuggestions
    attraction_suggestions.each do |attraction|
      attraction_suggestion_params = {
        user_id: user[:id],
        attraction_id: attraction[:id]
      }
      AttractionSuggestion.create(attraction_suggestion_params)
    end
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
      begin
        UserTag.create(tag_params)
      rescue
        p 'duplicate user_tag creation attempt attempted and aborted'
      end
    end
    refresh_user_events(@current_user)
  end

  # POST /user_attractions
  # POST /user_attractions.json
  def create
    begin
      @user_attraction = UserAttraction.new(user_attraction_params)
    rescue ActiveRecord::RecordNotUnique
      p 'attempted duplicate record creation'
    end
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

    if @user_attraction.user_id == @current_user.id
      if @user_attraction.update(user_attraction_params)
        head :no_content
      else
        render json: @user_attraction.errors, status: :unprocessable_entity
      end
    end
  end

  # DELETE /user_attractions/1
  # DELETE /user_attractions/1.json
  def destroy
    @user_attraction.destroy if @user_attraction.user_id == @current_user.id

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
