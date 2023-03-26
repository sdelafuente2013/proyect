Rails.application.routes.draw do

  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?
  # CLOUDLIBRARY REQUESTS
  resources :user_relations, only: [:index]
  # END CLOUDLIBRARY REQUESTS

  scope '/:tolgeo' do
    resources :access_errors, only: [:index, :create]
    resources :access_error_types, only: [:index]
    resources :access_tokens, only: [:show, :create, :destroy]
    resources :access_types, only: [:index]
    resources :access_type_tablets, only: [:index]
    resources :ambits, only: [:index]
    resources :backoffice_logins, only: [:create]
    resources :backoffice_users
    resources :conecta_users, only: [:create, :destroy, :update, :show]
    get '/conecta_users/' => 'conecta_users#show'
    resources :countries, only: [:index]
    resources :deleted_users, only: [:index]
    resources :document_types, only: [:index]
    resources :groups
    resources :group_authentication_types, only: [:index]
    resources :group_permits, only: [:create, :show]
    resources :group_sent_emails, only: [:update, :show]
    resources :home_services , only: [:index]
    resources :lopd_users, only: [:index, :show, :create, :update]
    post :lopd_texts, to: "lopd_texts#index"
    resources :massive_users, only: [:create]
    resources :massive_subscriptions, only: [:create]
    resources :modulos, only: [:index]
    resources :move_users_from_groups, only: [:update, :show]
    resources :products, only: [:index]
    resources :roles
    resources :subjects, only: [:index]
    resources :subsystems, only: [:index, :show]
    resources :tolgeos
    resources :users do
      collection do
        get :validate
      end
    end
    resources :user_cloudlibraries
    resources :user_logins, only: [:create]
    resources :user_mailers, only: [:create]
    resources :send_mails, only: [:create]
    resources :user_type_groups, only: [:index]
    resources :user_presubscriptions, only: [:index, :create]
    resources :user_presubscription_mailers, only: [:create]
    resources :user_sessions, :only => [:index, :show, :update, :destroy, :create]
    resources :user_session_tokens, :only => [:show, :create, :update, :index]
    resources :user_stats, only: [:index]
    resources :user_subscriptions do
      collection do
        post :confirm_update_email
        post :request_recover_password
        post :change_password
        post :confirm_subscription
        post :change_email
        match :validate, via: [:get, :post]
      end
    end
    resources :user_subscription_assumptions
    resources :user_subscription_cases
    resources :user_subscription_searches
    resources :user_subscription_logins, only: [:create, :destroy]
    resources :user_subscription_mailers, only: [:create]
    resources :user_subscription_validations, only: [:index]
    resources :user_subscription_calendars
    resources :user_subscription_rfc_alerts do
      collection do
        post :subscriptions_alerts
        delete :delete_all
      end
    end
    resources :document_alerts
    resources :commercial_contacts, only: [:index, :show, :create, :update]
    resources :commercial_contact_origins, only: [:index]
    delete '/document_alerts' => 'document_alerts#destroy'
    resources :alerts
    delete '/alerts' => 'alerts#destroy'
  end

  #resources :tests, only: [:index]
  #match '/tests/diagnostic' => 'tests#diagnostic', via: [:get,:post]

  delete '/db' => 'db#destroy'
  delete '/db_clean' => 'db#delete'
  get '/:tolgeo/ping' => 'ping#pong'

  if defined? Sidekiq
    require 'sidekiq/web'
    mount Sidekiq::Web, at: '/sidekiq/jobs', as: :sidekiq
  end

end
