# DS687 Capstone Project: Signal Extraction from IMDb Ratings and Metadata

**Author**: Jan McConnell
**Email**: janmcconnell@cityuniversity.edu
**Program**: Master of Science in Data Science (MSDS), City University of Seattle
**Course**: DS687 – Data Science Capstone

---

## 🧠 Project Overview

This capstone project uses the Internet Movie Database (IMDb) as a real-world example of large, relational data used for applied analytics. The focus is on examining IMDb ratings and structured production metadata to understand what observable audience engagement signals can be extracted and where those signals are limited.

A clean, movies-only analytical dataset is constructed using SQL through relational joins, filtering, and feature engineering. The analysis examines how production attributes such as genres, release periods, and cast and crew roles relate to audience ratings and vote counts. The goal is not to evaluate film quality or artistic merit, but to identify patterns and relationships that emerge when ratings-based measures are analyzed alongside production metadata.

The project reflects an applied analytics workflow. SQL is used for data preparation and feature construction, Python is used for exploratory analysis and visualization, and R is used for statistical validation. Results are presented with an emphasis on interpretability and analytical reasoning, supporting decision-oriented insights relevant to professional analytics and business contexts.

---

## 📌 Abstract

The Internet Movie Database (IMDb) provides structured data on film titles, production attributes, and aggregated audience ratings. This project analyzes IMDb data to examine how production-related factors, including cast, crew, and title attributes, relate to observable audience engagement as reflected in ratings and vote counts. SQL is used to construct and validate a relational analytical dataset through targeted joins, filtering, and feature engineering. Python supports exploratory analysis and visualization, and R is used for statistical validation. The project emphasizes interpretation of ratings-based signals within complex, real-world data and demonstrates an end-to-end analytics workflow applicable to decision support and applied data science.

---

## 🔑 Keywords

Audience engagement, IMDb ratings, production metadata, relational data analysis, decision support analytics

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
