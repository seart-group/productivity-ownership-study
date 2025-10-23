package score.filmapp.repository;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.springframework.stereotype.Repository;
import score.filmapp.model.Film;

import java.io.IOException;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.List;

@Repository
public class FilmRepository {


    private static final String FILMS_JSON_PATH = "/films.json";

    // Get all films from the JSON file
    public List<Film> getAllFilms() {
        ObjectMapper objectMapper = new ObjectMapper();
        TypeReference<List<Film>> typeReference = new TypeReference<List<Film>>() {
        };
        InputStream inputStream = TypeReference.class.getResourceAsStream(FILMS_JSON_PATH);

        try {
            List<Film> films = objectMapper.readValue(inputStream, typeReference);
            return films;
        } catch (IOException e) {
            throw new RuntimeException("Failed to read films from JSON file located at '" + FILMS_JSON_PATH + "'. Please check if the file exists and is accessible.", e);
        }
    }

    // Get the films with a specific exact title
    public List<Film> getFilmByExactTitle(String title) {
        List<Film> films = getAllFilms();
        List<Film> result = new ArrayList<>();
        for (Film film : films) {
            if (film.getTitle().equals(title)) {
                result.add(film);
            }
        }
        return result;
    }

    // Get the films that contain a specific string in the title
    public List<Film> getFilmsByTitle(String title) {
        List<Film> films = getAllFilms();
        List<Film> result = new ArrayList<>();
        for (Film film : films) {
            if (film.getTitle().toLowerCase().contains(title.toLowerCase())) {
                result.add(film);
            }
        }
        return result;
    }

}
