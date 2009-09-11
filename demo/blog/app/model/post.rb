# A Blog post (article).

class Post
  
  is Timestamped
  is Taggable
  
  attr_accessor :title, String
  attr_accessor :body, String, :control => :textarea
  attr_accessor :author, String

  belongs_to :category
  has_many :comments
  
  set_order "create_time DESC"

private

  include Sweeper
    
  def sweep_affected(action = :all)
    expire_output(self) unless action == :insert
    expire_output(category) # category view page
    expire_output(Post) # posts index page
  end
    
end
