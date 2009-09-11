
class Category::Controller

  include PagerHelper
  
  def view(oid)
    @category = Category[oid]
    @posts, @pager = paginate(@category.posts)
  end
  ann :view, :cache => true
  
end
