class RelationshipsController < ApplicationController
  def create#フォローする
    current_user.follow(params[:user_id])
    redirect_to request.referer#元いたページにredirect
  end

  def destroy#フォロー外す
    current_user.unfollow(params[:user_id])
    redirect_to request.referer
  end
  
  def followings#フォロー一覧
    user = User.find(params[:user_id])#params[:user_id]に対応するユーザーオブジェクトをデータベースから取得
    @users = user.followings#取得したユーザーオブジェクトがフォローしている他のユーザーの一覧を取得し、@usersインスタンス変数に代入
  end
  
  def followers#フォロワー一覧
    user = User.find(params[:user_id])#params[:user_id]に対応するユーザーオブジェクトをデータベースから取得
    @users = user.followers#取得したユーザーオブジェクトをフォローしている他のユーザーの一覧を取得し、@usersインスタンス変数に代入
  end
end
