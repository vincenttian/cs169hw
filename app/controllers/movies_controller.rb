class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def same_director
    @movie = Movie.find(params[:id])
    @same_movies = Movie.where(director: @movie.director).to_a
    @same_movies.each { |m|
      if m.id == @movie.id
        @same_movies.delete(m)
      end
    }
    if @same_movies.length == 0
      flash[:notice] = "#{@movie.title} has no director info"     
      redirect_to movies_path
    end
  end

  def index
    @redirect = false
    # rating logic
    if params[:ratings] # clicked on params
      @selected = params[:ratings].keys
      session[:selected] = @selected
      @movies = []
      @selected.each { |s| 
        Movie.where(rating: s).each { |z| 
          @movies.push z
        }
      }
      @movies = @movies
      @ratings = @selected
    elsif session[:selected] != nil # clicked on sort
      @movies = []
      session[:selected].each { |s| 
        Movie.where(rating: s).each { |z| 
          @movies.push z
        }
      }
      @movies = @movies
      @ratings = session[:selected]
      @redirect = true
    else # first time logging in
      @movies = Movie.all
      @ratings = ["G", "R", "PG-13", "PG"]
    end

    # sorting logic
    @session = nil
    @all_ratings = Movie.all.map {|movie| movie.rating}.uniq
    if params[:title]
      @movies = @movies.sort_by {|movie| movie.title}
      session[:sort] = "title"
      @session = :title
    elsif params[:release]
      @movies = @movies.sort_by {|movie| movie.release_date}
      session[:sort] = "release"
      @session = :release
    elsif session[:sort]
      if session[:sort] == "title"
        @movies = @movies.sort_by {|movie| movie.title}
        @redirect = true
        @session = :title
      elsif session[:sort] == "release"
        @movies = @movies.sort_by {|movie| movie.release_date}
        @redirect = true
        @session = :release
      else
        session[:sort] = "none"
        @session = :none
      end
    else # first time login
      @session = :none
    end

    if @redirect
      #redirect 
      @rating_hash = {}
      @ratings.each { |r|
        @rating_hash[r] = 1
      }
      redirect_to movies_path(:ratings => @rating_hash, @session => 'sorted')
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
    def movie_params
      params.require(:movie).permit(:title, :rating, :description, :release_date, :director)
    end

end
