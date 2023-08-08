class UsersController < ApplicationController
  before_action :ensure_correct_user, only: [:update]
  before_action :ensure_guest_user, only: [:edit]

  def show
    @user = User.find(params[:id])
    @currentUserEntry = Entry.where(user_id: current_user.id)#ログインしているユーザー
    @userEntry = Entry.where(user_id: @user.id)#相手ユーザー
    if @user.id == current_user.id#@user.idがログインユーザーか
    else
      @currentUserEntry.each do |cu|
        @userEntry.aech do |u|
          if cu.room_id == u.room_id then#自分のroom_idと相手のroom_idが一致しているか
            @isRoom = true
            @roomID = cu.room_id
          end
        end
      end
      if @isRoom#isRoomがtrueか
      else#isRoomがfalseのとき
        @room = Room.new
        @entry = Entry.new
      end
    end
    @books = @user.books
    @book = Book.new
  end

  def index
    @users = User.all
    @book = Book.new
  end
  
  def edit
    @user = User.find(params[:id])
    unless @user == current_user
      redirect_to user_path(current_user)
    end
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to user_path(@user), notice: "You have updated user successfully."
    else
      render "edit"
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :introduction, :profile_image)
  end

  def ensure_correct_user
    @user = User.find(params[:id])
    unless @user == current_user
      redirect_to user_path(current_user)
    end
  end

  def ensure_guest_user
    @user = User.find(params[:id])
    if @user.name == "guestuser"
      redirect_to user_path(current_user) , notice: 'ゲストユーザーはプロフィール編集画面へ遷移できません。'
    end
  end
end
