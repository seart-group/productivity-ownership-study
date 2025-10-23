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

    // ADD YOUR METHODS HERE

}
