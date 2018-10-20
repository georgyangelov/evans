require 'sidekiq/web'

Trane::Application.routes.draw do
  resource :registration, only: %w(new create)
  resources :activations, constraints: {id: /.+/}, only: %w(show update)

  resources :vouchers, only: %w(index new create)

  resources :announcements, except: %w(destroy) if Features.news_enabled?

  resource :profile, only: %w(edit update)

  resource :leaderboard, only: :show if Features.leaderboard_enabled?
  resource :dashboard, only: :show if Features.dashboard_enabled?
  resources :voucher_claims, only: %w(new create)
  resources :quizzes, only: :show
  resources :lectures, only: :index if Features.lectures_enabled?

  if Features.tasks_enabled?
    resources :tasks, except: :destroy do
      get :guide, on: :collection

      get :export

      resources :solutions, only: %w(index show update) do
        get :unscored, on: :collection
      end
      resource :my_solution, only: %w(show update)
      resource :check, controller: :task_checks, only: :create
    end

    resources :revisions, only: [] do
      resources :comments, only: %w(create edit update)
    end
  end

  if Features.challenges_enabled?
    resources :challenges, except: :destroy do
      resource :my_solution, only: %w(show update), controller: :my_challenge_solutions
      resource :check, controller: :challenge_checks, only: :create
    end
  end

  if Features.forums_enabled?
    resources :topics, except: :destroy do
      get :last_reply, on: :member
      resources :replies, except: %w(index new destroy)
    end

    resources :posts, only: :show do
      resource :star, only: %w(create destroy)
    end
  end

  resources :polls, except: %w(show destroy) do
    resource :my_answer, only: %w(show update)
  end

  resources :tips, except: :destroy if Features.tips_enabled?

  devise_for :users
  resources :users, only: %w(index show) do
    resources :attributions, only: %w(new create edit update)
  end
  resources :sign_ups, only: %w(index create)
  resources :activities, only: :index
  resources :points_breakdowns, only: :index

  resource :team, only: :show if Features.team_enabled?
  resource :preview, only: :create

  if Rails.env.test?
    get '/backdoor/login',  to: 'backdoor#login'
    get '/backdoor/logout', to: 'backdoor#logout'
  end

  get   '/hooks',                      to: 'hooks#index',           as: :hooks
  match '/hooks/homework/:key',        to: 'hooks#homework',        as: :homework_hook,        via: [:get, :post]
  match '/hooks/public_homework/:key', to: 'hooks#public_homework', as: :public_homework_hook, via: [:get, :post]
  match '/hooks/lectures/:key',        to: 'hooks#lectures',        as: :lectures_hook,        via: [:get, :post]

  mount Sidekiq::Web => '/queue', constraints: AdminConstraint.new

  root to: "home#index"
end
