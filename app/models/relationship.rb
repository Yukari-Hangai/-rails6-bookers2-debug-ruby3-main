class Relationship < ApplicationRecord
  
  belongs_to :follower, class_name: "User"#フォローしたユーザー
  belongs_to :followed, class_name: "User"#フォローされたユーザー

  #フォローしたユーザーとフォローされたユーザーは本来同じUserモデルから
  #.  持ってきたいがbelongs_to UserとするとどちらのUserかわからないので分けている
  #.  ただ、それだけだとfollowerテーブルとfollowedテーブルを探しに行ってしまうので
  #.  class: "User"でUserテーブルからデータをとってくるように指示している
end
