package score.gitlabclient.service;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import score.gitlabclient.model.Issue;

import java.util.HashSet;
import java.util.List;

import static org.junit.jupiter.api.Assertions.*;

@SpringBootTest
class IssueServiceTest {

    @Autowired
    IssueService issueService;

    @Test
    @DisplayName("Get the issues from a GitLab project")
    void getIssues() {
        int nIssues = 25;
        String projectId = "4207231";      // https://gitlab.com/graphviz/graphviz
        List<Issue> issues = null;
        // issues = <METHOD UNDER TEST>(projectId, nIssues);
        assertTrue(issues.size()==nIssues, "Wrong numer of issues!");
    }

    @Test
    @DisplayName("Attempt to get issues from a GitLab project with no issues")
    void getZeroIssues() {
        int nIssues = 25;
        String projectId = "52152";      // https://gitlab.com/ianoff/intro-html-css
        List<Issue> issues = null;
        // issues = <METHOD UNDER TEST>(projectId, nIssues);
        assertTrue(issues.isEmpty(), "The list of issues is not empty!");
    }

    @Test
    @DisplayName("Get the most voted issues")
    void getMostVotedIssues() {
        int nIssues = 50;
        String projectId = "3472737";      // https://gitlab.com/inkscape/inkscape
        List<Issue> mostVotedIssues = null;
        //mostVotedIssues = <METHOD UNDER TEST>(projectId, nIssues);
        assertFalse(mostVotedIssues.isEmpty(), "The list of most voted issues is empty!");
        assertTrue(mostVotedIssues.size() <= nIssues, "The list of most voted issues is bigger than the number of issues requested!");
    }

    @Test
    @DisplayName("Get all the distinct authors' names from the issues of a GitLab project")
    void getDistinctAuthors() {
        int nIssues = 100;
        String projectId = "4207231";      // https://gitlab.com/graphviz/graphviz
        List<String> authors = null;
        //authors = <METHOD UNDER TEST>(projectId, nIssues);
        assertFalse(authors.isEmpty(), "The list of authors is empty!");
        assertEquals(new HashSet<>(authors).size(), authors.size(), "There are repeated authors!");
    }

    @Test
    @DisplayName("Get the issues opened for more than one year")
    void getOpenedIssueForMoreThanOneYear() {
        int nIssues = 50;
        String projectId = "1148549";      // https://gitlab.com/gitlab-com/runbooks
        List<Issue> issues = null;
        // issues = <METHOD UNDER TEST>(projectId, nIssues);
        assertFalse(issues.isEmpty(), "The list of issues is empty!");
    }
}