# DS687 Capstone Project: Sentiment and Rating Analysis Using the IMDb Dataset

**Author**: Jan McConnell
**Email**: janmcconnell@cityuniversity.edu
**Program**: Master of Science in Data Science (MSDS), City University of Seattle
**Course**: DS687 – Data Science Capstone

---

## 🧠 Project Overview

This capstone project applies data science principles, analytical tools, and statistical techniques to a large-scale real-world dataset. Using the Internet Movie Database (IMDb) as a case study, the project investigates how movie popularity relates to production attributes, including cast, directors, writers, and other crew roles. By leveraging the structured IMDb metadata, the project examines whether specific individuals or role categories are associated with consistently higher audience engagement, measured through IMDb user rating counts and average ratings.

To reflect the breadth of the MSDS program, the project integrates **SQL** for data extraction and feature engineering, **R** for statistical analysis and visualization, and **Python** for exploratory analysis and predictive modeling.

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
