class BooksController < ApplicationController
   before_action :is_matching_login_user, only: [:edit, :update, :destroy]

  def show
    @book = Book.find(params[:id])
    @new = Book.new
    @user = @book.user
    @post_comment = PostComment.new
  end

  def index
    @book = Book.new
    #@books = Book.all
    @post_comment = PostComment.new
    #@books = Book.all.order(created_at: :desc)
    
    #タグ機能
    @tags = BookTag.all
    #リストの切り替え
    if params[:latest]
      @books = Book.latest
    elsif params[:old]
      @books = Book.old
    elsif params[:star_count]
      @books = Book.star_count
    else
      @books = Book.all
      
    end
  end

  def create
    @book = Book.new(book_params)
    @book.user_id = current_user.id
    if @book.save
      redirect_to book_path(@book), notice: "You have created book successfully."
    else
      @books = Book.all
      #render :index
    end
  end

  def edit
    @book = Book.find(params[:id])
  end

  def update
    @book = Book.find(params[:id])
    if @book.update(book_params)
      redirect_to book_path(@book), notice: "You have updated book successfully."
    else
      render :edit
    end
  end

  def destroy
    
    @book = Book.find(params[:id])
    @book.destroy
    redirect_to '/books'
  end

  private

  def book_params
    params.require(:book).permit(:title, :body, :image, :star)
  end
  
  def is_matching_login_user
    book = Book.find(params[:id])
    unless book.user.id == current_user.id
      redirect_to books_path
    end
  end
  
end
