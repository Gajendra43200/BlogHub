class AuthorsController < ApplicationController
  before_action :set_author, only: [:show, :edit, :update, :destroy]
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  def index
    @authors = Author.all
  end

  def show
  end

  def new
    @author = Author.new
  end

  def create
    author_params = params.require(:author).permit(:name)
    @author = Author.new(author_params)
    if @author.save
      redirect_to authors_path, alert: 'Author was successfully created.'
    else
      render :new
    end
  end

  def edit
  end

  def update
    author_params = params.require(:author).permit(:name)
    if @author.update(author_params)
      redirect_to authors_path, alert: 'Author was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @author.destroy
    redirect_to authors_path, alert: 'Author was successfully destroyed.'
  end

  private

  def set_user
    @user = current_user
  end

  def set_author
    @author = Author.find(params[:id])
  end
end
