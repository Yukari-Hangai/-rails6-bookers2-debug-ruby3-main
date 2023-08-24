class BooksController < ApplicationController

  def show
    @book_new = Book.new
    @book = Book.find(params[:id])
    current_user.view_counts.create(book_id: @book.id) #新しいViewCountレコードを作成
    @user = @book.user
    @book_comment = BookComment.new
    @currentUserEntry = Entry.where(user_id: current_user.id)#ログインしているユーザー
    @userEntry = Entry.where(user_id: @user.id)#相手ユーザー
    unless @user.id == current_user.id#@user.idがログインユーザーか
      @currentUserEntry.each do |cu|
        @userEntry.each do |u|
          if cu.room_id == u.room_id then#自分のroom_idと相手のroom_idが一致しているか
            @isRoom = true
            @roomId = cu.room_id
          end
        end
      end
      if @isRoom#isRoomがfalseのとき
      else
        @room = Room.new
        @entry = Entry.new
      end
    end
  end

  def index
    if params[:latest]
      @books = Book.latest
    elsif params[:old]
      @books = Book.old
    elsif params[:star_count]
      @books = Book.star_count
    else
      to = Time.current.at_end_of_day #今現在の日の23：59をtoに代入
      from = (to - 6.day).at_beginning_of_day #今現在から6日前の0：00をfromに代入
      @books = Book.includes(:favorites).
        sort_by {|x|
          x.favorites.where(created_at: from...to).count
        }.reverse
    end
    @book = Book.new
  end

  def create
    @book = Book.new(book_params)
    @book.user_id = current_user.id
    if @book.save
      redirect_to book_path(@book), notice: "You have created book successfully."
    else
      @books = Book.all
      render 'index'
    end
  end

  def edit
    @book = Book.find(params[:id])
    unless @book.user == current_user
      redirect_to books_path
    end
  end

  def update
    @book = Book.find(params[:id])
    if @book.update(book_params)
      redirect_to book_path(@book), notice: "You have updated book successfully."
    else
      render "edit"
    end
  end

  def destroy
    @book = Book.find(params[:id])
    @book.destroy
    redirect_to books_path
  end

  private

  def book_params
    params.require(:book).permit(:title, :body, :star)
  end

end
