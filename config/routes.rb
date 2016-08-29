Rails.application.routes.draw do
  root 'home#index'
  
  get '/intro' => 'redirection#intro'
  get '/how_to' => 'redirection#instructions'
  # get 'home/index'
  # get 'home/user_main'
  # get 'home/owner_main'
  
  # 그룹, 장소 생성
  get '/create/group' => 'home#create_group'
  post '/create/group' => 'home#create_group_exec'
  get '/create/place' => 'home#create_place'
  post '/create/place' => 'home#create_place_exec'
  
  # 그룹 모집 및 검색
  get '/find/group' => 'home#group'
  
  # 그룹 활동 장소 검색
  get '/find/place' => 'home#place'
  
  # 장소 좋아요
  post '/find/place/like' => 'home#likes'
  
  # 그룹, 장소 검색
  post '/find/place/search' => 'home#place_search'
  post '/find/group/search' => 'home#group_search'
  
  # 그룹 및 장소 상세확인 페이지
  get '/find/group/detail/:group_id' => 'home#group_detail'
  get '/find/place/detail/:place_id' => 'home#place_detail'
  
  # 그룹 및 장소 신청 및 삭제, 수정, 탈퇴
  get '/find/group/apply/:group_id' => 'home#group_apply'
  post '/find/place/apply/before' => 'home#place_apply_before'
  post '/find/place/apply/before/cautions' => 'home#place_apply_before_confirm'
  post '/find/place/apply' => 'home#place_apply'
  post '/find/group/apply/:place_id' => 'home#group_apply_exec'
  post '/find/place/apply/:place_id' => 'home#place_apply_exec'
  post '/find/group/destroy/:group_id' => 'home#group_destroy_exec'
  post '/find/place/destroy/:place_id' => 'home#place_destroy_exec'
  
  get '/find/group/edit/:group_id' => 'home#group_edit'
  get '/find/place/edit/:place_id' => 'home#place_edit'
  post '/find/place/edit/:place_id' => 'home#place_edit_exec'
  post '/find/group/edit/:group_id' => 'home#group_edit_exec'
  
  delete '/find/group/cancel/:group_id' => 'home#group_cancel'
  delete '/find/place/cancel/:place_id' => 'home#place_cancel'
  
  post '/find/group/member_out' => 'home#member_out'
  
  # 장소 예약 정보
  get '/mypage/reservations/:resv_id' => 'home#reservations'
  post '/mypage/reservations/cancel' => 'home#reservations_cancel'
  post '/mypage/reservations/confirm' => 'home#reservations_confirm'
  
  # 장소 예약 가능 여부 확인
  post '/find/place/reservation/search' => 'home#resv_search'
  
  
  # 로그인 시 계정 타입 선택
  get '/login' => 'redirection#login_user_type'
  post '/login' => 'redirection#login_user_type'
  
  # 마이페이지
  get '/mypage'=>'home#mypage'
  
  # 마이페이지 시간표
  get '/mypage/timetable' => 'home#timetable'
  get '/mypage/timetable/edit' => 'home#timetable_edit'
  post '/mypage/timetable/edit' => 'home#timetable_edit_exec'
  
  # 세션 관리 - users : 학생 계정, owners : 카페 주인 계정
  devise_for :users, controllers: { sessions: 'users/sessions' , registrations: 'users/registrations' }
  devise_for :owners, controllers: { sessions: 'users/sessions' }
  
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
