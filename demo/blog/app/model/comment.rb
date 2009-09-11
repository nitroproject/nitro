class Comment

  is Timestamped
  
  attr_accessor :body, String
  attr_accessor :author, String

  belongs_to :post
  
private

  include Sweeper
    
  def sweep_affected(action = :all)
    expire_output(post) # post page
    expire_output(Post) # posts index page
  end
      
end
