package psa.movie.loader;

/*
 * MovieLoader.java - Interface for injecting data sources
 */
import psa.movie.model.Movie;

import java.util.List;

public interface MovieLoader {
    List<Movie> loadMovies() throws Exception;
}