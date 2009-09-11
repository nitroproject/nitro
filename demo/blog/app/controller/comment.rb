
class Comment::Controller

  def create
    @comment = request.assign(Comment.new)
    save
  end

private

  def save    
    @comment.post_oid = request["post_oid"]
    @comment.save
    
    redirect_to_referer
  end

end
