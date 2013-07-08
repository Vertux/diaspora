class CommentPresenter < BasePresenter
  def initialize(comment)
    @comment = comment
  end

  def as_json(opts={})
    {
      :id => @comment.id,
      :guid => @comment.guid,
      :text  => @comment.text,
      :author => @comment.author.as_api_response(:backbone),
      :likes => as_api(@comment.likes),
      :likes_count => @comment.likes_count,
      :created_at => @comment.created_at
    }
  end

  private

  def as_api(collection)
    collection.includes(:author => :profile).all.map do |element|
      element.as_api_response(:backbone)
    end
  end
end
