require 'json'

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

  def finalize_user_words(category, u_words)
    final_string = ''
    return unless u_words[category]
    u_words[category].uniq.each { |w| final_string = final_string + ' ' + w }
    u_words[category] = final_string.strip
    @current_user[:keywords_string] = u_words.to_json
    @current_user.save
  end

  def update_user_words(category, word_array, user_words, adding_words)
    word_array.each do |word|
      if user_words[category]
        user_words[category] << word if adding_words
        user_words[category].delete(word) unless adding_words
      elsif adding_words
        user_words[category] = [word]
      end
      user_words.delete(category) unless user_words[category]
    end
    finalize_user_words(category, user_words)
  end

  def split_user_word_array(user)
    begin
      user_words = JSON.parse(user[:keywords_string])
    rescue
      user_words = {}
    end
    user_words
  end

  def make_categories_list(attraction_categories)
    categories = []
    attraction_categories.each do |a_cat|
      categories << Category.find(a_cat[:category_id])
    end
  end

  def update_user_word_strings(categories, user_words, a_keywords, params)
    categories.each do |category|
      if params[:like]
        update_user_words(category.category_id, a_keywords, user_words, true)
      else
        update_user_words(category.category_id, a_keywords, user_words, false)
      end
    end
  end

  def update_user_string(params)
    liked_attraction = Attraction.find(params[:attraction_id])
    a_keywords = liked_attraction[:keywords_string].split(' ')
    attraction_categories = AttractionCategory.where 'attraction_id = ?',
                                                     params[:attraction_id]
    categories = make_categories_list(attraction_categories)
    user_words = split_user_word_array(@current_user)
    update_user_word_strings(categories, user_words, a_keywords, params)
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
