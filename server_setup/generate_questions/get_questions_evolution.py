from get_questions import main

TASK = "evolution" # "development" or "evolution"
LANGUAGE = "Python" # "Java", "Python" or "C"
NATURAL_LANGUAGE = "Italian" # "Spanish", "Italian" or None

if __name__ == "__main__":
    main(TASK, LANGUAGE, NATURAL_LANGUAGE)