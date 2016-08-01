#
class AttractionSuggestionsController < ProtectedController
  before_action :set_attraction_suggestion, only: [:show, :update, :destroy]

  # GET /attraction_suggestions
  # GET /attraction_suggestions.json
  def index
    @attraction_suggestions = AttractionSuggestion.all

    render json: @attraction_suggestions
  end

  # GET /attraction_suggestions/1
  # GET /attraction_suggestions/1.json
  def show
    render json: @attraction_suggestion
  end

  # POST /attraction_suggestions
  # POST /attraction_suggestions.json
  def create
    @attraction_suggestion = AttractionSuggestion.new(attraction_suggestion_params)

    if @attraction_suggestion.save
      render json: @attraction_suggestion, status: :created, location: @attraction_suggestion
    else
      render json: @attraction_suggestion.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /attraction_suggestions/1
  # PATCH/PUT /attraction_suggestions/1.json
  def update
    @attraction_suggestion = AttractionSuggestion.find(params[:id])

    if @attraction_suggestion.update(attraction_suggestion_params)
      head :no_content
    else
      render json: @attraction_suggestion.errors, status: :unprocessable_entity
    end
  end

  # DELETE /attraction_suggestions/1
  # DELETE /attraction_suggestions/1.json
  def destroy
    @attraction_suggestion.destroy

    head :no_content
  end

  private

  def set_attraction_suggestion
    @attraction_suggestion = AttractionSuggestion.find(params[:id])
  end

  def attraction_suggestion_params
    params.require(:attraction_suggestion).permit(:user_id, :attraction_id)
  end
end
