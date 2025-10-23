package psa.movie.model;

import java.util.Objects;

/*
 * Movie.java - POJO for movie data
 */
public class Movie {
    private String title;
    private String director;
    private int year;
    private double rating;
    private String genre;
    private String poster;
    private String imdbID;

    public Movie() {}

    public Movie(String title, String director, int year, double rating, String genre, String poster, String imdbID) {
        this.title = title;
        this.director = director;
        this.year = year;
        this.rating = rating;
        this.genre = genre;
        this.poster = poster;
        this.imdbID = imdbID;
    }

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public String getDirector() { return director; }
    public void setDirector(String director) { this.director = director; }

    public int getYear() { return year; }
    public void setYear(int year) { this.year = year; }

    public double getRating() { return rating; }
    public void setRating(double rating) { this.rating = rating; }

    public String getGenre() { return genre; }
    public void setGenre(String genre) { this.genre = genre; }

    public String getPoster() { return poster; }
    public void setPoster(String poster) { this.poster = poster; }

    public String getImdbID() { return imdbID; }
    public void setImdbID(String imdbID) { this.imdbID = imdbID; }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        Movie movie = (Movie) o;
        return title.equals(movie.title) && director.equals(movie.director);
    }

    @Override
    public int hashCode() {
        return Objects.hash(imdbID);
    }
}