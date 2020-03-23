class BooksController < ApplicationController
  def index
    books = Book.all
    books_json = BookBlueprint.render(books, root: :books)
    render json: books_json, status: :ok
  end

  def show
    render json: BookBlueprint.render(book, root: :book), status: :ok
  end

  def create
    book = Book.new(book_params)
    if book.save
      render json: BookBlueprint.render(book, root: :book), status: :created
    else
      render json: {errors: book.errors.messages}, status: :unprocessable_entity
    end
  end

  def update
    if book.update(book_params)
      render json: BookBlueprint.render(book, root: :book), status: :ok
    else
      render json: {errors: book.errors.messages}, status: :unprocessable_entity
    end
  end

  def destroy
    book.destroy!
    head :ok
  end

  private
    def book
      @book ||= Book.friendly.find(params[:id])
    end

    def book_params
      params.require(:book).permit(:title, :description)
    end
end
