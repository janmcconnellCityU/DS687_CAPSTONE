# DS687 Capstone Project: Sentiment and Rating Analysis Using the IMDb Dataset

**Author**: Jan McConnell
**Email**: janmcconnell@cityuniversity.edu
**Program**: Master of Science in Data Science (MSDS), City University of Seattle
**Course**: DS687 – Data Science Capstone

---

## 🧠 Project Overview

This capstone project applies data science principles, analytical tools, and statistical techniques to a large-scale real-world dataset. Using the Internet Movie Database (IMDb) as a case study, the project investigates how movie popularity relates to production attributes, including cast, directors, writers, and other crew roles. By leveraging the structured IMDb metadata, the project examines whether specific individuals or role categories are associated with consistently higher audience engagement, measured through IMDb user rating counts and average ratings.

To reflect the breadth of the MSDS program, the project integrates **SQL** for data extraction and feature engineering (answers structural questions about the data), **R** for statistical analysis and visualization, and **Python** for exploratory analysis and predictive modeling.

---

## 📌 Abstract

The Internet Movie Database (IMDb) is a widely used repository of film information, containing detailed metadata on titles, ratings, genres, cast, and crew. This project analyzes the IMDb dataset to explore how production-related attributes correlate with movie popularity, assessed through IMDb user rating counts and average ratings. SQL is used to construct a clean, movies-only analytical dataset by joining titles, ratings, and personnel information. Python is employed to explore feature relationships, visualize trends, and build preliminary predictive models. R is used to validate statistical associations and generate complementary analytical insights. The results highlight patterns in how cast size, director and writer involvement, and crew categories relate to audience engagement. These findings offer a data-driven perspective on factors that may influence film popularity and contribute to broader understanding of audience behavior in the film industry.

---

## 🔑 Keywords

IMDb, movie popularity, user ratings, cast analysis, crew analysis, production attributes, feature engineering, exploratory data analysis, statistical modeling, SQL, R, Python

---

## 💻 Tools and Technologies

| Tool     | Purpose                                      |
|----------|----------------------------------------------|
| **SQL**  | Loading, joining, and filtering large datasets (e.g., SQLite or PostgreSQL) |
| **R**    | Statistical summaries and data visualization (`ggplot2`, `dplyr`, `tidytext`) |
| **Python** | NLP preprocessing, feature engineering, machine learning modeling (`pandas`, `sklearn`, `nltk`, `matplotlib`) |

---

## 🌍 Data Source

The data used in this project comes from the official [IMDb Datasets](https://datasets.imdbws.com/) collection. Files are provided in compressed TSV format and include movie metadata, ratings, names, and more. Users are responsible for downloading and managing the dataset if they wish to replicate this analysis. No redistribution of IMDb data is included in this repository.

For IMDb dataset details, visit [IMDb Non-Commercial Datasets](https://developer.imdb.com/non-commercial-datasets/).

---

## 🗄️ SQL Summary

This section documents the SQL work used to explore the IMDb dataset, assess data quality, and create the curated movie dataset used in later Python and R analysis.

### 1. Initial Schema Exploration
The SQL phase began with a full review of all IMDb tables imported into SQLite.
This included:

- Listing all tables present in the database.
- Inspecting table structures with `PRAGMA table_info`.
- Verifying relational keys (`tconst`, `nconst`) connecting titles, ratings, cast, and crew.

This established a clear understanding of how the raw dataset is organized.

---

### 2. Exploratory Data Analysis in SQL
Descriptive queries were used to understand distribution patterns and data quality:

- Counts of titles by category (movie, short, TV episode, etc.).
- Frequency of genres across all titles.
- Distribution of IMDb user ratings (`averageRating`).
- Vote-count bucket analysis to gauge engagement levels.
- Movie release volume by decade.
- Runtime trends across decades.
- Distribution of crew roles (actor, actress, director, etc.).
- Identification of the most prolific individuals in the database.

**Insight:** IMDb contains a large volume of low-engagement or non-movie content, which supported the decision to narrow the project focus to movies only.

---

### 3. Performance Optimization
Given the size of several IMDb tables, performance improvements were required.
The SQL work introduced:

- Indexes on key join fields (`tconst`, `nconst`, and `category`).
- Normalized pivot tables for directors, actors, and actresses.
- Rewritten queries to avoid slow substring operations.

**Outcome:** Queries became significantly faster, making deep exploration feasible.

---

### 4. Cast and Crew Popularity Analysis
With normalized pivot tables, the project examined whether certain contributors were consistently associated with higher audience engagement.

Analyses included:

- Ranking directors by average vote counts.
- Identifying actors and actresses associated with popular films.
- Comparing role categories in relation to engagement.

**Key Finding:** Individuals connected to major franchises or highly visible genres tend to appear in films with higher audience engagement.

---

### 5. Missing Data Assessment
The SQL analysis also measured missingness for critical modeling fields:

- `startYear`
- `runtimeMinutes`
- `genres`

**Insight:** Missing metadata is widespread in the broader IMDb dataset, reaffirming the need for filtering before modeling.

---

### 6. Construction of the Final Modeling Dataset
A curated table, **`filtered_movies`**, was created using the following criteria:

- `titleType = 'movie'`
- `numVotes ≥ 5000`
- Non-null `startYear`, `runtimeMinutes`, and `genres`
- Joined with IMDb user ratings

**Final dataset size: 18,371 movies.**

**Purpose:**
To create a clean, consistent dataset suitable for feature engineering, exploratory analysis, visualization, and predictive modeling in Python and R.

---
