from get_questions import main

TASK = "development" # "development" or "evolution"
LANGUAGE = "Python" # "Java", "Python" or "C"
NATURAL_LANGUAGE = "Spanish" # "Spanish", "Italian" or None

if __name__ == "__main__":
    main(TASK, LANGUAGE, NATURAL_LANGUAGE)