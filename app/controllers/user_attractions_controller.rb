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

  def overlap(tag_array_1, tag_array_2)
    result = 0
    tag_array_1.each do |tag|
      result += 1 if tag_array_2.include?(tag)
    end
    result / tag_array_1.length.to_f
  end

  def correlate_arrays(tag_array_1, tag_array_2)
    filtered_array_1 = tag_array_1.uniq.compact
    filtered_array_2 = tag_array_2.uniq.compact
    first_comparison = overlap(filtered_array_1, filtered_array_2)
    second_comparison = overlap(filtered_array_2, filtered_array_1)
    (first_comparison + second_comparison) / 2.to_f
  end

  def get_attraction_suggestions(correlation_cutoff, current_user_words)
    attraction_suggestions = []
    Attraction.all.each do |attraction|
      attraction_words = attraction[:keywords_string].split(' ')
      average_correlation = correlate_arrays(attraction_words,
                                             current_user_words)
      if average_correlation > correlation_cutoff
        attraction_suggestions << attraction
      end
    end
  end

  def create_new_attraction_suggestions(attraction_suggestions)
    attraction_suggestions.each do |attraction|
      attraction_suggestion_params = {
        user_id: @current_user[:id],
        attraction_id: attraction[:id]
      }
      AttractionSuggestion.create(attraction_suggestion_params)
    end
  end

  def refresh_user_events(user)
    correlation_cutoff = 0.25
    AttractionSuggestion.where(user_id: user[:id]).delete_all
    current_user_words = @current_user[:keywords_string].split(' ')
    attraction_suggestions = get_attraction_suggestions(correlation_cutoff,
                                                        current_user_words)
    create_new_attraction_suggestions(attraction_suggestions)
  end

  def add_user_words(word_array, user_words)
    word_array.each do |word|
      user_words << word
    end
    final_string = ''
    user_words.uniq.each do |word|
      final_string << word << ' '
    end
    @current_user[:keywords_string] = final_string
    @current_user.save
  end

  def remove_user_words(word_array, user_words)
    word_array.each do |word|
      user_words.delete(word)
    end
    final_string = ''
    user_words.uniq.each do |word|
      final_string << word << ' '
    end
    @current_user[:keywords_string] = final_string
    @current_user.save
  end

  def split_user_word_array(user)
    begin
      user_words = user[:keywords_string].split(' ')
    rescue
      user_words = []
    end
    user_words
  end

  def update_user_string(params)
    liked_attraction = Attraction.find(params[:attraction_id])
    attraction_keywords = liked_attraction[:keywords_string].split(' ')
    user_words = split_user_word_array(@current_user)
    if params[:like]
      add_user_words(attraction_keywords, user_words)
    else
      remove_user_words(attraction_keywords, user_words)
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
      update_user_string(user_attraction_params)
      render json: @user_attraction, status: :created,
             location: @user_attraction
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
