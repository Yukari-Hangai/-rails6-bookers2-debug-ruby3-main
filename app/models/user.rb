class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :books, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :book_comments, dependent: :destroy
  has_many :relationships, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy#フォローするアソシエーション
  has_many :reverse_of_relationships, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy#フォローされるアソシエーション
  has_many :followings, through: :relationships, source: :followed #一覧でフォローしている人を表示するためのアソシエーション
  has_many :followers, through: :reverse_of_relationships, source: :follower #一覧でフォローされている人を表示するためのアソシエーション
  has_one_attached :profile_image

  validates :name, length: { minimum: 2, maximum: 20 }, uniqueness: true
  validates :introduction, length: {maximum: 50 }

 def follow(user_id) #引数として渡されたユーザーIDをフォローするためのメソッド
   relationships.create(followed_id: user_id)#relationshipsテーブルに新しいレコードを作成し、フォローする側のユーザーID(user_id)と、フォローされる側のユーザーID()を紐付け
 end
  
 def unfollow(user_id)#引数として渡されたユーザーIDのフォローを外すためのメソッド
   relationships.find_by(followed_id: user_id).destroy#relationshipsテーブルからfollowed_idがuser_idに一致するレコードを見つけて、そのレコードを削除する
 end
 
 def following?(user)#数として渡されたユーザーがフォローしているかどうかを判定するためのメソッド
   followings.include?(user)#自分がフォローしているユーザーを示すfollowings配列に引数として渡されたユーザーが含まれているかどうかをチェック
 end
 #引数がuser_idではなくuserなのは、userを引数にすることでuser.nameやuser.emailなどの情報も扱うことができ、柔軟性と可読性を両立できるようにするため
 
 #検索方法による条件分岐の追記
 def self.looks(search, word)
    if search == "perfect_match"
      user = User.where("name LIKE?", "#{word}")
    elsif search == "forward_match"
      user = User.where("name LIKE?","#{word}%")
    elsif search == "backward_match"
      user = User.where("name LIKE?","%#{word}")
    elsif search == "partial_match"
      user = User.where("name LIKE?","%#{word}%")
    else
      user = User.all
    end
 end
 
 def self.guest
    find_or_create_by!(name: 'guestuser' ,email: 'guest@example.com') do |user|
      user.password = SecureRandom.urlsafe_base64
      user.name = "guestuser"
    end
 end
 
  def get_profile_image
    (profile_image.attached?) ? profile_image : 'no_image.jpg'
  end
end
