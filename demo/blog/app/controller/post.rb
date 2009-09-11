
class Post::Controller

  include PagerHelper

  def index
    @posts, @pager = paginate(Post.all)
  end
  ann :index, :cache => true
  
  def view(oid)
    @post = Post[oid]
  end
  ann :view, :cache => true
  
  def delete(oid)
    Post.delete(oid)
    redirect_to_referer
  end

end
