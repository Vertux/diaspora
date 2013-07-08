//= require ./content_view
app.views.Comment = app.views.Content.extend({
  templateName: "comment",
  className : "comment media",

  events : function() {
    return _.extend({}, app.views.Content.prototype.events, {
      "click .comment_delete": "destroyModel",
      "click .like_comment" : "toggleLike",
    });
  },

  initialize : function(options){
    this.templateName = options.templateName || this.templateName
    this.model.on("change", this.render, this)
  },

  presenter : function() {
    return _.extend(this.defaultPresenter(), {
      likes: this.model.get("likes_count"),
      userLike: this.model.userLike(),
      canLike: this.canLike(),
      canRemove: this.canRemove(),
      text : app.helpers.textFormatter(this.model.get("text"), this.model)
    })
  },

  ownComment : function() {
    return app.currentUser.authenticated() && this.model.get("author").diaspora_id == app.currentUser.get("diaspora_id")
  },

  postOwner : function() {
    return  app.currentUser.authenticated() && this.model.get("parent").author.diaspora_id == app.currentUser.get("diaspora_id")
  },

  canRemove : function() {
    return app.currentUser.authenticated() && (this.ownComment() || this.postOwner())
  },

  canLike : function() {
    return app.currentUser.authenticated() && !this.ownComment()
  },

  toggleLike : function(evt) {
    if (evt) { evt.preventDefault(); }

    this.model.toggleLike();
  }

});
