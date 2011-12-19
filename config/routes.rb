#   Copyright (c) 2010-2011, Diaspora Inc.  This file is
#   licensed under the Affero General Public License version 3 or later.  See
#   the COPYRIGHT file.

Diaspora::Application.routes.draw do


  # Posting and Reading

  resources :reshares

  resources :aspects do
    put :toggle_contact_visibility
  end

  resources :status_messages, :only => [:new, :create]

  resources :posts, :only => [:show, :destroy] do
    resources :likes, :only => [:create, :destroy, :index]
    resources :comments, :only => [:new, :create, :destroy, :index]
  end
  get 'p/:id' => 'posts#show', :as => 'short_post'
  get 'public_stream' => 'posts#index', :as => 'public_stream'
  # roll up likes into a nested resource above
  resources :comments, :only => [:create, :destroy] do
    resources :likes, :only => [:create, :destroy, :index]
  end


  get 'bookmarklet' => 'status_messages#bookmarklet'

  resources :photos, :except => [:index] do
    put :make_profile_photo
  end

  resources :conversations do
    resources :messages, :only => [:create, :show]
    delete 'visibility' => 'conversation_visibilities#destroy'
  end

  resources :notifications, :only => [:index, :update] do
    get :read_all, :on => :collection
  end

  resources :tags, :only => [:index]
  scope "tags/:name" do
    post   "tag_followings" => "tag_followings#create", :as => 'tag_tag_followings'
    delete "tag_followings" => "tag_followings#destroy"
  end

  post   "multiple_tag_followings" => "tag_followings#create_multiple", :as => 'multiple_tag_followings'

  get "tag_followings" => "tag_followings#index", :as => 'tag_followings'
  resources :mentions, :only => [:index]
  resources "tag_followings", :only => [:create]

  get 'comment_stream' => 'comment_stream#index', :as => 'comment_stream'

  get 'like_stream' => 'like_stream#index', :as => 'like_stream'

  get 'tags/:name' => 'tags#show', :as => 'tag'

  resources :apps, :only => [:show]

  # Users and people

  resource :user, :only => [:edit, :update, :destroy], :shallow => true do
    get :getting_started_completed
    get :export
    get :export_photos
  end

  controller :users do
    get 'public/:username'          => :public,           :as => 'users_public'
    match 'getting_started'         => :getting_started,  :as => 'getting_started'
    match 'privacy'                 => :privacy_settings, :as => 'privacy_settings'
    get 'getting_started_completed' => :getting_started_completed
    get 'confirm_email/:token'      => :confirm_email,    :as => 'confirm_email'
  end

  # This is a hack to overide a route created by devise.
  # I couldn't find anything in devise to skip that route, see Bug #961
  match 'users/edit' => redirect('/user/edit')

  devise_for :users, :controllers => {:registrations => "registrations",
                                      :password      => "devise/passwords",
                                      :sessions      => "sessions",
                                      :invitations   => "invitations"} do
    get 'invitations/resend/:id' => 'invitations#resend', :as => 'invitation_resend'
    get 'invitations/email' => 'invitations#email', :as => 'invite_email'
  end

  get 'login' => redirect('/users/sign_in')

  scope 'admins', :controller => :admins do
    match :user_search
    get   :admin_inviter
    get   :weekly_user_stats
    get   :correlations
    get   :stats, :as => 'pod_stats'
  end

  resource :profile, :only => [:edit, :update]

  resources :contacts,           :except => [:update, :create] do
    get :sharing, :on => :collection
  end
  resources :aspect_memberships, :only  => [:destroy, :create, :update]
  resources :share_visibilities,  :only => [:update]
  resources :blocks, :only => [:create, :destroy]

  get 'spotlight' => 'community_spotlight#index', :as => 'spotlight'

  get 'community_spotlight' => "contacts#spotlight", :as => 'community_spotlight'

  get 'stream' => "multis#index", :as => 'multi'

  resources :people, :except => [:edit, :update] do
    resources :status_messages
    resources :photos
    get  :contacts
    get "aspect_membership_button" => :aspect_membership_dropdown, :as => "aspect_membership_button"
    collection do
      post 'by_handle' => :retrieve_remote, :as => 'person_by_handle'
      get :tag_index
    end
  end
  get '/u/:username' => 'people#show', :as => 'user_profile'
  get '/u/:username/profile_photo' => 'users#user_photo'
  
  
  # Federation

  controller :publics do
    get 'webfinger'             => :webfinger
    get 'hcard/users/:guid'     => :hcard
    get '.well-known/host-meta' => :host_meta
    post 'receive/users/:guid'  => :receive
    post 'receive/public'       => :receive_public
    get 'hub'                   => :hub
  end



  # External

  resources :services, :only => [:index, :destroy]
  controller :services do
    scope "/auth", :as => "auth" do
      match ':provider/callback' => :create
      match :failure
    end
    scope 'services' do
      match 'inviter/:provider' => :inviter, :as => 'service_inviter'
      match 'finder/:provider'  => :finder,  :as => 'friend_finder'
    end
  end

  # APIs

  resources :authorizations, :only => [:index, :destroy]
  scope "/oauth", :controller => :authorizations, :as => "oauth" do
    get "authorize" => :new
    post "authorize" => :create
    post :token
    post :register
  end

  # ActivityStreams routes - backward compatibility
  scope "/activity_streams", :module => "api/v0/activity_streams", :as => "activity_streams" do
    resources :photos, :controller => "photos", :only => [:create]
  end

  namespace :api do
    namespace :v0 do
      # Backward compatibility
      get "/me" => "users#me"
      
      scope "/users", :controller => :users do
        get :me
        get ":username" => :show, :as => 'user'
      end
      
      controller :tags do
        get :followed_tags
        
        scope "/tags" do
          get ":name" => :show, :as => 'tag'
        end
      end
      
      resources :posts, :only => [:show] do
        resources :comments, :only => [:index]
        resources :likes, :only => [:index]
      end
      
      scope "/streams", :controller => :streams do
        get :main
        get :aspects
        get :commented
        get :liked
        get :mentions
        get :followed_tags
        get "tags/:name" => :tag
      end
      
      resources :people, :only => [:show] do
        collection do
          get ':pod/:username' => :show, :constraints => {:pod => /[^ ]+/ }
        end
      end
      
      resources :conversations, :only => [:index, :show]
      
      resources :aspects, :only => [:index]
      
      resources :contacts, :only => [:index]
      
      resources :notifications, :only => [:index]
      
      namespace :activity_streams do
        resources :photos, :only => [:create]
      end
    end
  end


  # Mobile site

  get 'mobile/toggle', :to => 'home#toggle_mobile', :as => 'toggle_mobile'

  #Protocol Url
  get 'protocol' => redirect("https://github.com/diaspora/diaspora/wiki/Diaspora%27s-federation-protocol")

  # Resque web
  if AppConfig[:mount_resque_web]
    mount Resque::Server.new, :at => '/resque-jobs', :as => "resque_web"
  end

  # Logout Page (go mobile)
  get 'logged_out' => 'users#logged_out', :as => 'logged_out'

  # Startpage
  root :to => 'home#show'
end
