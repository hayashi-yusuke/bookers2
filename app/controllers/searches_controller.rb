class SearchesController < ApplicationController

  def search
    @model = params[:model]
    @content = params[:content]
    @method = params[:method]

    if @model == "User"
      @records = search_model(User, :name)
    elsif @model == "Book"
      @records = search_model(Book, :title)
    elsif params[:category] == "tag"
      @records = Tag.where(name: params[:search_word])
                    .first&.books || []
    end
  end

  private

  def search_model(model, column)
    case @method
    when "perfect"
      model.where(column => @content)
    when "forward"
      model.where("#{column} LIKE ?", "#{@content}%")
    when "backward"
      model.where("#{column} LIKE ?", "%#{@content}")
    when "partial"
      model.where("#{column} LIKE ?", "%#{@content}%")
    end
  end

end