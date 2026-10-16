class User < ApplicationRecord
    has_secure_password

    has_many :tweets
    has_many :likes
    has_many :like_tweets, through: :likes, source: :tweet
    validates :uid, presence: true, uniqueness: true
end
