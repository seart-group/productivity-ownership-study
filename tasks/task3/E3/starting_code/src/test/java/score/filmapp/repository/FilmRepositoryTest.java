package score.filmapp.repository;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import score.filmapp.model.Film;

import java.util.List;

import static org.junit.jupiter.api.Assertions.*;

@SpringBootTest
class FilmRepositoryTest {

    @Autowired
    FilmRepository filmRepository;

    @Test
    @DisplayName("Get all films")
    void getFilms() {
        List<Film> films = filmRepository.getAllFilms();
        assertNotNull(films, "The list of films is null!");
        assertEquals(films.size(), 10, "Wrong numer of films");
        assertTrue(films.stream().anyMatch(film -> "John Wick".equals(film.getTitle())), "No film with the title 'John Wick' found");
    }

    @Test
    @DisplayName("Get films by title")
    void getFilmByExactTitle() {
        List<Film> films = filmRepository.getFilmByExactTitle("John Wick");
        assertNotNull(films, "The list of films is null!");
        assertEquals(films.size(), 1, "Wrong number of films");
        assertEquals(films.get(0).getTitle(), "John Wick", "Wrong title");
    }

    @Test
    @DisplayName("Get films containing a string in the title")
    void getFilmsByTitle() {
        List<Film> films = filmRepository.getFilmsByTitle("Die");
        assertNotNull(films, "The list of films is null!");
        assertEquals(films.size(),2, "Wrong number of films");
    }

    /*
    @Test
    @DisplayName("Get films ordered by year")
    void getFilmsByYear() {
        //List<Film> films = <METHOD_UNDER_TEST>;
        assertNotNull(films, "The list of films is null!");
        assertEquals(films.size(), 10, "Wrong number of films");
        assertTrue(films.get(0).getYear() <= films.get(1).getYear(), "Films are not ordered by year");
        System.out.println("Films ordered by year:" + films);
    }
    */

}