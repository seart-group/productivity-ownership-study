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
    void getIssuesTest() {
        int nIssues = 20;
        String projectId = "4207231";      // https://gitlab.com/graphviz/graphviz
        List<Issue> issues = issueService.getIssues(projectId, nIssues);
        assertTrue(issues.size()==nIssues, "Wrong numer of issues!");
    }

    @Test
    @DisplayName("Get the most voted issues")
    void getMostVotedIssuesTest() {
        int nIssues = 50;
        String projectId = "3472737";      // https://gitlab.com/inkscape/inkscape
        List<Issue> mostVotedIssue = issueService.getMostVotedIssues(projectId, nIssues);
        assertFalse(mostVotedIssue.isEmpty(), "The list of most voted issues is empty!");
        assertTrue(mostVotedIssue.size() <= nIssues, "The list of most voted issues is bigger than the number of issues requested!");
    }

    @Test
    @DisplayName("Get all the distinct authors' names from the issues of a GitLab project")
    void getDistinctAuthorsTest() {
        int nIssues = 100;
        String projectId = "4207231";      // https://gitlab.com/graphviz/graphviz
        List<String> authors = issueService.getDistinctAuthors(projectId, nIssues);
        assertFalse(authors.isEmpty(), "The list of authors is empty!");
        assertEquals(new HashSet<>(authors).size(), authors.size(), "There are repeated authors!");
    }

    @Test
    @DisplayName("Get the issues opened for more than one year")
    void getOpenedIssueForMoreThanOneYearTest() {
        int nIssues = 50;
        String projectId = "1148549";      // https://gitlab.com/gitlab-com/runbooks
        List<Issue> issues = issueService.getOpenedIssueForMoreThanOneYear(projectId, nIssues);
        assertFalse(issues.isEmpty(), "The list of issues is empty!");
        System.out.println(issues);

    }
}