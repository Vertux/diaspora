describe("app.views.Poll", function(){
  beforeEach(function() {
    loginAs({name: "alice", avatar : {small : "http://avatar.com/photo.jpg"}});
    this.view = new app.views.Poll({ model: factory.postWithPoll()});
    this.view.render();
  });

  describe("setProgressBar", function(){
    it("sets the progress bar according to the voting result", function(){
      var percentage = (this.view.poll.poll_answers[0].vote_count / this.view.poll.participation_count)*100;
      expect(this.view.$('.poll_progress_bar:first').css('width')).toBe(percentage+"%");
      expect(this.view.$(".percentage:first").text()).toBe(percentage + "%");
    })
  });

  describe("toggleResult", function(){
    it("toggles the progress bar and result", function(){
      expect(this.view.$('.poll_progress_bar_wrapper:first').css('display')).toBe("none");
      this.view.toggleResult(null);
      expect(this.view.$('.poll_progress_bar_wrapper:first').css('display')).toBe("block");
    })
  });

  describe("vote", function(){
    it("checks the ajax call for voting", function(){
      spyOn($, "ajax");
      var answer = this.view.poll.poll_answers[0];
      var poll = this.view.poll;

      this.view.vote(answer.id);

      var obj = JSON.parse($.ajax.mostRecentCall.args[0].data);
      expect(obj.poll_id).toBe(poll.poll_id);
      expect(obj.poll_answer_id).toBe(answer.id);
    })
  })
});
