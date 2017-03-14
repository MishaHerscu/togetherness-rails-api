require 'json'

# Base for all API controllers.
class ApplicationController < ActionController::API
  # Force to wants JSON for API
  before_action :api_request_settings
  def api_request_settings
    request.format = :json
  end

  AUTH_BLOCK = proc do |signed_token, _opts|
    token = begin
      Rails.application.message_verifier(:signed_token).verify(signed_token)
    rescue ActiveSupport::MessageVerifier::InvalidSignature
      false
    end
    User.find_by token: token
  end

  # Use Token Authentication
  include ActionController::HttpAuthentication::Token::ControllerMethods
  def authenticate
    @current_user =
      authenticate_or_request_with_http_token(&AUTH_BLOCK)
  end

  # call from actions to get authenticated user (or nil)
  attr_reader :current_user

  # call from unauthenticated actions that want current_user if available
  def set_current_user
    # for access to authenticate method
    t = ActionController::HttpAuthentication::Token
    @current_user = t.authenticate(self, &AUTH_BLOCK)
  end

  # Require SSL for deployed applications
  force_ssl if: :ssl_configured?
  def ssl_configured?
    Rails.env.production?
  end

  # Use enhanced JSON serialization
  include ActionController::Serialization

  # return 404 for failed search by id
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  def record_not_found
    render json: { error: { message: 'Not Found' } }, status: :not_found
  end

  def overlap(word_array_1, word_array_2)
    result = 0
    word_array_1.each do |word|
      result += 1 if word_array_2.include?(word)
    end
    result / word_array_1.length.to_f
  end

  def correlate_strings(string_1, string_2)
    filtered_array_1 = string_1.split(' ').uniq.compact
    filtered_array_2 = string_2.split(' ').uniq.compact
    first_comparison = overlap(filtered_array_1, filtered_array_2)
    second_comparison = overlap(filtered_array_2, filtered_array_1)
    (first_comparison + second_comparison) / 2.to_f
  end

  def get_attraction_suggestions(correlation_cutoff, current_user_words_hash)
    attraction_suggestions = []
    Attraction.all.each do |attraction|
      attraction_words = attraction[:keywords_string]
      attraction.attraction_categories.each do |a_cat|
        current_user_words = current_user_words_hash[a_cat.category_id.to_s]
        next unless current_user_words
        average_correlation = correlate_strings(attraction_words,
                                                current_user_words)
        if average_correlation > correlation_cutoff
          attraction_suggestions << attraction
        end
      end
    end
    attraction_suggestions
  end

  def create_new_attraction_suggestions(attraction_suggestions)
    attraction_suggestions.each do |attraction|
      attraction_suggestion_params = {
        user_id: @current_user[:id],
        attraction_id: attraction[:id]
      }
      begin
        AttractionSuggestion.create(attraction_suggestion_params)
      rescue
        p 'attempted duplicate record creation'
      end
    end
  end

  def refresh_user_events(user)
    correlation_cutoff = 0.25
    AttractionSuggestion.where(user_id: user[:id]).delete_all
    return false if [nil, '', ' ', '{}'].include? @current_user[:keywords_string]
    current_user_words_hash = JSON.parse(@current_user[:keywords_string])
    return false if current_user_words_hash.empty?
    attraction_suggestions = get_attraction_suggestions(correlation_cutoff,
                                                        current_user_words_hash)
    return false unless attraction_suggestions
    create_new_attraction_suggestions(attraction_suggestions)
  end

  # Restrict visibility of these methods
  private :authenticate, :current_user, :set_current_user, :record_not_found
  private :ssl_configured?, :api_request_settings
end
