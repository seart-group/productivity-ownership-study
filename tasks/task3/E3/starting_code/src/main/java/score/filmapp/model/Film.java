
package score.filmapp.model;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.fasterxml.jackson.annotation.JsonProperty;

@JsonIgnoreProperties(ignoreUnknown = true)
public class Film {

    @JsonProperty("Title")
    private String title;
    @JsonProperty("Year")
    private Integer year;
    @JsonProperty("imdbID")
    private String imdbID;
    @JsonProperty("Type")
    private String type;
    @JsonProperty("Poster")
    private String poster;

    @JsonProperty("Title")
    public String getTitle() {
        return title;
    }

    @JsonProperty("Title")
    public void setTitle(String title) {
        this.title = title;
    }

    @JsonProperty("Year")
    public Integer getYear() {
        return year;
    }

    @JsonProperty("Year")
    public void setYear(Integer year) {
        this.year = year;
    }

    @JsonProperty("imdbID")
    public String getImdbID() {
        return imdbID;
    }

    @JsonProperty("imdbID")
    public void setImdbID(String imdbID) {
        this.imdbID = imdbID;
    }

    @JsonProperty("Type")
    public String getType() {
        return type;
    }

    @JsonProperty("Type")
    public void setType(String type) {
        this.type = type;
    }

    @JsonProperty("Poster")
    public String getPoster() {
        return poster;
    }

    @JsonProperty("Poster")
    public void setPoster(String poster) {
        this.poster = poster;
    }
    @Override
    public String toString() {
        StringBuilder sb = new StringBuilder();
        sb.append(Film.class.getName()).append('@').append(Integer.toHexString(System.identityHashCode(this))).append(" [\n");
        sb.append("  title=").append((this.title == null) ? "<null>" : this.title).append(",\n");
        sb.append("  year=").append((this.year == null) ? "<null>" : this.year).append(",\n");
        sb.append("  imdbID=").append((this.imdbID == null) ? "<null>" : this.imdbID).append(",\n");
        sb.append("  type=").append((this.type == null) ? "<null>" : this.type).append(",\n");
        sb.append("  poster=").append((this.poster == null) ? "<null>" : this.poster).append("\n");
        sb.append(']');
        return sb.toString();
    }

}
