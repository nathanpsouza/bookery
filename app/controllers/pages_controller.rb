class PagesController < ApplicationController
  def index
    pages = book.pages
    pages_json = PageBlueprint.render(pages, root: :pages)
    render json: pages_json, status: :ok
  end

  def show
    render json: PageBlueprint.render(page, root: :page, format: params[:format]), status: :ok
  end

  def create
    page = book.pages.new(page_params)
    if page.save
      render json: PageBlueprint.render(page, root: :page), status: :created
    else
      render json: {errors: page.errors.messages}, status: :unprocessable_entity
    end
  end

  def update
    if page.update(page_params)
      render json: PageBlueprint.render(page, root: :page), status: :ok
    else
      render json: {errors: page.errors.messages}, status: :unprocessable_entity
    end
  end

  def destroy
    page.destroy!
    head :ok
  end

  private
    def page
      @page ||= book.pages.find_by!(page_number: params[:id])
    end

    def book
      @book ||= Book.friendly.find(params[:book_id])
    end

    def page_params
      params.require(:page).permit(:page_number, :content)
    end
end
