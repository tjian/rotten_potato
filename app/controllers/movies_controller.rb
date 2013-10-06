class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index

    is_redirect = false
    if params[:sort_by] == nil && session[:sort_by] != nil
      is_redirect = true
    else
      session[:sort_by] = params[:sort_by]
    end

    if params[:ratings] == nil && session[:ratings] != nil
      is_redirect = true
    else
      session[:ratings] = params[:ratings]
    end

    if is_redirect
      flash.keep
      redirect_to movies_path({:sort_by => session[:sort_by], :ratings => session[:ratings]})
    end


    @all_ratings = Movie.ratings
    
    if params[:ratings].is_a?(Hash)
      @checked_rating = params[:ratings].keys
    elsif params[:ratings].kind_of?(Array)
      @checked_rating = params[:ratings]
    else
      @checked_rating = @all_ratings
    end

    if params[:sort_by] == 'title'
      order = {:order => :title}
      @title_style = 'hilite'
    end

    if params[:sort_by] == 'release_date'
      order = {:order => :release_date}
      @release_style = 'hilite'
    end

    @movies = Movie.find_all_by_rating(@checked_rating, order)
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
