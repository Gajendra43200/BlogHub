class BlogsController < ApplicationController
    before_action :set_author, only: [:new, :create,:edit, :update, :destroy]
    before_action :set_blog, only: [:show]
    before_action :set_user
  
    def index
      @blogs = Blog.all
    end
  
    def show
    end
  
    def new
      @blog = @author.blogs.new
    end
  
    def create
      @blog = @author.blogs.new(blog_params)
  
      if @blog.save
        redirect_to author_blogs_path(@author), notice: 'Blog was successfully created.'
      else
        render :new
      end
    end
  
    def edit
    end
  
    def update
      if @blog.update(blog_params)
        redirect_to author_blogs_path(@author), notice: 'Blog was successfully updated.'
      else
        render :edit
      end
    end
  
    def destroy
      @blog.destroy
      redirect_to author_blogs_path(@author), notice: 'Blog was successfully destroyed.'
    end
  
    private
  
    def set_author
      @author = Author.find(params[:author_id])
    end
  
    def set_blog
      # @blog = @author.blogs.find(params[:id])
      @blog = Blog.find(params[:id])
    end
    def set_user
      @user = current_user
    end
  
    def blog_params
      params.require(:blog).permit(:title, :content)
    end
  end
  