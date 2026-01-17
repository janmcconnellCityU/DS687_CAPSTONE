# DS687 Capstone Project: Signal Extraction from IMDb Ratings and Metadata

**Author**: Jan McConnell
**Email**: janmcconnell@cityuniversity.edu
**Program**: Master of Science in Data Science (MSDS), City University of Seattle
**Course**: DS687 – Data Science Capstone

---

## 🧠 Project Overview

This capstone project applies data science and analytics techniques to a large-scale, real-world dataset using the Internet Movie Database (IMDb) as a case study. The project focuses on extracting interpretable signals from IMDb ratings and structured production metadata, including title attributes, release information, genres, and cast and crew roles.

Using SQL, a clean, movies-only analytical dataset is constructed through relational joins, filtering, and feature engineering, incorporating audience rating measures such as average ratings and vote counts. The analysis examines whether specific production attributes or role categories are associated with consistently higher levels of audience engagement, as reflected in ratings and vote counts. Rather than evaluating film quality or artistic merit, the project emphasizes identifying patterns and relationships within complex relational data.

To reflect the applied nature of the MSDS program, the project integrates **SQL** for data preparation and feature engineering, **Python** for exploratory analysis and visualization, and **R** for statistical validation. Results are communicated with an emphasis on interpretability and analytical reasoning, supporting decision-oriented insights relevant to business analytics and data-focused professional roles.

---

## 📌 Abstract

The Internet Movie Database (IMDb) contains extensive structured data describing film titles, production attributes, and audience ratings. This project analyzes IMDb data to extract meaningful analytical signals from ratings and production metadata, with the goal of understanding how cast, crew, and other production-related factors relate to audience engagement. SQL is used to construct and validate a clean relational dataset through targeted joins, filtering, and feature engineering, while Python supports exploratory analysis and visualization and R is used for statistical validation. The project emphasizes interpretable relationships within complex, real-world data and demonstrates an end-to-end analytics workflow applicable to business analytics and data-driven decision-making contexts.

---

## 🔑 Keywords

IMDb, audience engagement, movie ratings, production metadata, cast and crew analysis, relational data analysis, signal extraction, feature engineering, exploratory data analysis, statistical analysis, SQL, Python, R

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
