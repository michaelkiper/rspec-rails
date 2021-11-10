Rottenpotatoes::Application.routes.draw do
    resources :movies
    # map '/' to be a redirect to '/movies'
    root :to => redirect('/movies')
    # resources :to => redirect('/movies/search_tmdb.html.erb')
    # resources :search_tmdb
    get 'search_tmdb', to: 'movies#search_tmdb'
    #post 'search_tmdb', to: 'movies#search_tmdb'
    post "add_movie", to: 'movies#add_movie'
  end
