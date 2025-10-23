package psa.movie.loader;

/*
 * MovieLoader.java - Interface for injecting data sources
 */
import java.io.File;
import java.nio.file.Paths;
import java.util.List;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import psa.movie.model.Movie;

public class JsonMovieLoader implements MovieLoader {
    private final String filePath;

    public JsonMovieLoader(String filePath) {
        this.filePath = filePath;
    }

    @Override
    public List<Movie> loadMovies() throws Exception {
        ObjectMapper mapper = new ObjectMapper();
        File file = Paths.get(filePath).toFile();
        return mapper.readValue(file, new TypeReference<List<Movie>>() {});
    }
}