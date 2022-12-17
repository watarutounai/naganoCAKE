Rails.application.routes.draw do
  # 顧客用
  # URL /customers/sign_in ...
  devise_for :customers,skip: [:passwords], controllers: {
    registrations: "public/registrations",
    sessions: 'public/sessions'
  }

  # 管理者用
  # URL /admin/sign_in ...
  devise_for :admin, skip: [:registrations, :passwords], controllers: {
    sessions: "admin/sessions"
  }
  
  #管理者側
  namespace :admin do
    root to: 'homes#top'
    resources :items, except: [:destroy]
    resources :customers, except: [:new, :create, :destroy]
    resources :genres, except: [:show, :destroy, :new]
    resources :orders, only: [:index, :show, :update] do
     resources :order_details, only: [:index, :update]
    end
  end
  
    scope module: :public do
    root to: 'homes#top'
    #get 'search' => 'search#search'
    get 'about' => 'homes#about'
    resources :items,only:[:index,:show]
    resources :cart_items,except:[:show,:new,:edit]
    delete 'cart_items' => 'cart_items#destroy_all'
    post 'orders/confirm' => 'orders#confirm'
    get 'orders/thank' => 'orders#thank'
    resources :orders,except:[:edit] 
    resource :customers,only:[:edit,:update] do
      get 'mypage' => 'customers#mypage'
      get 'mypage/edit' => 'customers#edit'
      patch 'mypage/update' => 'customers#update'
      get 'unsubscribe' => 'customers#unsubscribe'
      patch 'withdraw' => 'customers#withdraw'
      resources :deliveries,except:[:show,:new]
    end
  end
  
  #devise_for :admins
  #devise_for :customers
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
