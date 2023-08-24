class TagSearchesController < ApplicationController
  
  def search
    @range = Book
    @word = params[:word]
    @books = Book.where("tag LIKE?","%#{@word}%")
    render "searches/search"
  end
  
end