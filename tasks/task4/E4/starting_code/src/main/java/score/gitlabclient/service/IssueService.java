package score.gitlabclient.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;
import score.gitlabclient.model.Issue;

import java.time.Instant;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.ZoneOffset;
import java.time.temporal.ChronoUnit;

import java.util.*;

@Service
public class IssueService {

    @Autowired
    RestTemplate restTemplate;

    private String baseUri = "https://gitlab.com/api/v4/";

    // Get the issues from the GitLab project with id = projectId. Return a maximum of nIssues issues.
    public List<Issue> getIssues(String projectId, int nIssues) {

        String uri = baseUri + "projects/" + projectId + "/issues?page=";
        List<Issue> issues = new ArrayList<>();

        int fetchedIssues = 0;
        int page = 1;

        while (fetchedIssues < nIssues) {

            String fullUri = uri + page;
            Issue[] issuesPage = restTemplate.getForObject(fullUri, Issue[].class);

            if (issuesPage == null || issuesPage.length == 0) {
                break;
            } else {
                issues.addAll(Arrays.asList(issuesPage));
                fetchedIssues += issuesPage.length;
            }
            page++;
        }

        return issues;
    }

    /* Get the most voted issue(s) from the GitLab project with id = projectId. Limit the search to nIssues issues.
       If there are multiple issues with the same number of votes, return all of them. */
    public List<Issue> getMostVotedIssues(String projectId, int nIssues) {
        List<Issue> issues = getIssues(projectId, nIssues);
        List<Issue> mostVotedIssues = new ArrayList<>();
        int maxVotes = 0;

        for (Issue issue : issues) {
            if (issue.getUpvotes() >= maxVotes) {
                mostVotedIssues.clear();
                mostVotedIssues.add(issue);
                maxVotes = issue.getUpvotes();
            } else if (issue.getUpvotes() == maxVotes)
                mostVotedIssues.add(issue);
        }

        return mostVotedIssues;
    }

    // Get the distinct authors' names (without repetitions) of the issues of project with id = projectId. Limit the search to nIssues issues.
    public List<String> getDistinctAuthors(String projectId, int nIssues) {
        List<Issue> issues = getIssues(projectId, nIssues);
        Set<String> authors = new HashSet<>();

        for (Issue issue : issues) {
            if (issue.getAuthor() != null) {
                authors.add(issue.getAuthor().getUsername());
            }
        }

        return new ArrayList<>(authors);
    }

    // Get the issues (closed or not) opened for more than one year in project with id = projectId. Limit the search to nIssues issues.
    public List<Issue> getOpenedIssueForMoreThanOneYear(String projectId, int nIssues) {
        List<Issue> issues = getIssues(projectId, nIssues);
        List<Issue> oldIssues = new ArrayList<>();

        for (Issue issue : issues) {
            if (issue.getClosedAt() != null) {
                if (issue.getClosedAt().isAfter(issue.getCreatedAt().plus(1, ChronoUnit.YEARS))) {
                    oldIssues.add(issue);
                }
            } else {
                LocalDate oneYearAgo = LocalDate.now().minus(1, ChronoUnit.YEARS);
                if (issue.getCreatedAt().toLocalDate().isAfter(oneYearAgo))
                    oldIssues.add(issue);

            }
        }

        return oldIssues;
    }
}
