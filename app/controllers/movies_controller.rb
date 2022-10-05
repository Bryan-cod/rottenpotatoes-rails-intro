class MoviesController < ApplicationController


    def show
      id = params[:id] # retrieve movie ID from URI route
      @movie = Movie.find(id) # look up movie by unique ID
      # will render app/views/movies/show.<extension> by default
    end
  
    def index
        puts params
        @all_ratings = ['G','PG','PG-13','R']
        @title_ordered = false
        @date_ordered = false
        @ratings_to_show = @all_ratings
        session[:ratings_to_show] = @ratings_to_show
        session[:is_ordered_by_date] = @date_ordered
        session[:is_ordered_by_title] = @title_ordered
        @if_date_chosen = "hilite bg-transparent"
        @if_title_chosen = "hilite bg-transparent"
        session[:home] = false
        # Changed some ratings selection but not all are unchecked
        if (params[:ratings])
            @ratings_to_show = params[:ratings].keys
            @movies = Movie.with_ratings(@ratings_to_show)
            session[:ratings_to_show] = @ratings_to_show
            session[:home] = true
        end
        # Clicked to sort by title
        if (params[:title_ordered])
            @title_ordered = true
            @ratings_to_show = params[:title_ordered].keys
            session[:ratings_to_show] = @ratings_to_show
            session[:is_ordered_by_title] = @title_ordered
            session[:is_ordered_by_date] = false
            @movies = Movie.order(:title).with_ratings(@ratings_to_show)
            @if_title_chosen = "hilite bg-warning"
            session[:home] = true

        # Clicked to sort by date
        elsif (params[:date_ordered])
            @date_ordered = true
            @ratings_to_show = params[:date_ordered].keys
            session[:ratings_to_show] = @ratings_to_show
            session[:is_ordered_by_date] = @date_ordered
            session[:is_ordered_by_title] = false
            @movies = Movie.order(:release_date).with_ratings(@ratings_to_show)
            @if_date_chosen = "hilite bg-warning"
            session[:home] = true

        # Return back to home page
        elsif (params[:id] && (!(params[:ratings]) && !(params[:title_ordered]) && !(params[:date_ordered])))
            @ratings_to_show = session[:ratings_to_show]
            @title_ordered = session[:is_ordered_by_title]
            @date_ordered = session[:is_ordered_by_date]
            if (@title_ordered)
                @movies = Movie.order(:title).with_ratings(@ratings_to_show)
            elsif (@date_ordered)
                @movies = Movie.order(:release_date).with_ratings(@ratings_to_show)
            else
                @movies = Movie.with_ratings(@ratings_to_show) 
            end
        end
    end
  
    def new
      # default: render 'new' template
    end
  
    def create
      @movie = Movie.create!(movie_params)
      flash[:notice] = "#{@movie.title} was successfully created."
      redirect_to movies_path
    end
  
    def edit
      @movie = Movie.find params[:id]
    end
  
    def update
      @movie = Movie.find params[:id]
      @movie.update_attributes!(movie_params)
      flash[:notice] = "#{@movie.title} was successfully updated."
      redirect_to movie_path(@movie)
    end
  
    def destroy
      @movie = Movie.find(params[:id])
      @movie.destroy
      flash[:notice] = "Movie '#{@movie.title}' deleted."
      redirect_to movies_path
    end
  
    private
    # Making "internal" methods private is not required, but is a common practice.
    # This helps make clear which methods respond to requests, and which ones do not.
    def movie_params
      params.require(:movie).permit(:title, :rating, :description, :release_date)
    end

  end