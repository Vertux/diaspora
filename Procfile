web: bin/bundle exec puma -b unix:///var/run/diaspora/diaspora.sock -e $RAILS_ENV
sidekiq: bin/bundle exec sidekiq
xmpp: bin/bundle exec vines start
