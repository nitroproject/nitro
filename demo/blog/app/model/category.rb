
# A post category, used for organising posts.

class Category

  attr_accessor :title, String
  attr_accessor :description, String, :control => :textarea

  has_many :posts

end
