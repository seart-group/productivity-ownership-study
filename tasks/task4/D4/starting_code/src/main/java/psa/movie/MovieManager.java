package psa.movie;

/*
 * MovieManager.java - Core logic
 */

import psa.movie.loader.MovieLoader;
import psa.movie.model.Movie;

import java.util.*;
import java.util.stream.Collectors;

public class MovieManager {
    private Map<String, Movie> movies = new HashMap<>();

    public MovieManager(MovieLoader loader) throws Exception {
        List<Movie> movieList = loader.loadMovies();
        loadMovies(movieList);
    }

    private void loadMovies(List<Movie> movieList) {
        for (Movie m : movieList) {
            if (m.getImdbID() != null) {
                movies.put(m.getImdbID(), m);
            }
        }
    }

    private void validateMovie(Movie movie) {
        if (movie == null || movie.getImdbID() == null || movie.getImdbID().isEmpty()
                || movie.getTitle() == null || movie.getTitle().isEmpty()
                || movie.getDirector() == null || movie.getDirector().isEmpty()
                || movie.getRating() < 0 || movie.getRating() > 10) {
            throw new IllegalArgumentException("Invalid movie data");
        }
    }

    public void addMovie(Movie movie) {
        validateMovie(movie);
        if (movies.containsKey(movie.getImdbID())) {
            throw new IllegalArgumentException("Movie already exists");
        }
        movies.put(movie.getImdbID(), movie);
    }

    public void deleteMovie(String imdbID) {
        if (!movies.containsKey(imdbID)) {
            throw new NoSuchElementException("Movie not found");
        }
        movies.remove(imdbID);
    }

    public void updateMovie(Movie updatedMovie) {
        validateMovie(updatedMovie);
        if (!movies.containsKey(updatedMovie.getImdbID())) {
            throw new NoSuchElementException("Movie not found");
        }
        movies.put(updatedMovie.getImdbID(), updatedMovie);
    }

    public List<Movie> getAllMovies() {
        return new ArrayList<>(movies.values());
    }

    public List<Movie> searchByYear(int year) {
        return movies.values().stream().filter(m -> m.getYear() == year).collect(Collectors.toList());
    }

    public List<Movie> searchByGenre(String genre) {
        return movies.values().stream().filter(m -> m.getGenre().toLowerCase().contains(genre.toLowerCase())).collect(Collectors.toList());
    }

    public List<Movie> searchByDirector(String director) {
        return movies.values().stream().filter(m -> m.getDirector().equalsIgnoreCase(director)).collect(Collectors.toList());
    }

    public Movie searchByImdbID(String imdbID) {
        Movie movie = movies.get(imdbID);
        if (movie == null) throw new NoSuchElementException("Movie not found");
        return movie;
    }

    public Movie searchByExactTitle(String title) {
        return movies.values().stream()
                .filter(m -> m.getTitle().equalsIgnoreCase(title))
                .findFirst()
                .orElseThrow(() -> new NoSuchElementException("Movie not found"));
    }

    public List<Movie> searchByTitleContaining(String substring) {
        return movies.values().stream()
                .filter(m -> m.getTitle().toLowerCase().contains(substring.toLowerCase()))
                .collect(Collectors.toList());
    }

    public List<Movie> searchByRatingRange(double min, double max) {
        if (min < 0 || max < 0 || min > 10 || max > 10 || min > max) {
            throw new IllegalArgumentException("Rating range must be between 0 and 10, and min must be less than or equal to max");
        }
        return movies.values().stream()
                .filter(m -> m.getRating() >= min && m.getRating() <= max)
                .collect(Collectors.toList());
    }

    public List<Movie> findDuplicateMovies() {
        return movies.values().stream()
                .collect(Collectors.groupingBy(m -> m.getTitle() + "|" + m.getDirector()))
                .values().stream()
                .filter(group -> group.size() > 1)
                .map(group -> group.get(0))
                .collect(Collectors.toList());
    }
}