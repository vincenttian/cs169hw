class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    if params[:ratings]
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
    elsif session[:selected] != nil
      @movies = []
      session[:selected].each { |s| 
        Movie.where(rating: s).each { |z| 
          @movies.push z
        }
      }
      @movies = @movies
      @ratings = session[:selected]
      @rating_hash = {}
      @ratings.each { |r|
        @rating_hash[r] = 1
      }
      redirect_to movies_path(:ratings => @rating_hash)
    else
      @movies = Movie.all
      @ratings = ["G", "R", "PG-13", "PG"]
    end

    @all_ratings = Movie.all.map {|movie| movie.rating}.uniq
    if params[:title]
      @movies = @movies.sort_by {|movie| movie.title}
    end
    if params[:release]
      @movies = @movies.sort_by {|movie| movie.release_date}
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
      params.require(:movie).permit(:title, :rating, :description, :release_date)
    end

end
