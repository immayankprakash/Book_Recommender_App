#!/usr/bin/env python
# coding: utf-8

# # Importing libraries
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import pickle
from sklearn.metrics.pairwise import cosine_similarity

# # Plot settings
def set_plot_settings():
    plt.rcParams['axes.labelsize'] = 20
    plt.rcParams['xtick.labelsize'] = 15
    plt.rcParams['ytick.labelsize'] = 15
    plt.rcParams['legend.fontsize'] = 23
    plt.rcParams['figure.titlesize'] = 26
    plt.rcParams['xtick.major.size'] = 10
    plt.rcParams['xtick.major.width'] = 1
    plt.rcParams['ytick.major.size'] = 10
    plt.rcParams['ytick.major.width'] = 1
    plt.rcParams['xtick.minor.width'] = 1
    plt.rcParams['ytick.minor.size'] = 5
    plt.rcParams['ytick.minor.width'] = 1
    plt.rcParams['xtick.minor.size'] = 5
    plt.rcParams['figure.figsize'] = 10,7


# # Loading data

def load_data():
    books = pd.read_csv('Books.csv')
    users = pd.read_csv('Users.csv')
    ratings = pd.read_csv('Ratings.csv')
    return books, users, ratings

def count_unique_books_users(books, users, ratings):
    num_books = len(books["ISBN"].unique())
    num_users = len(users["User-ID"].unique())
    print("Number of unique books: ", num_books)
    print("Number of unique users: ", num_users)

def print_shape(books, users, ratings):
    print(books.shape)
    print(ratings.shape)
    print(users.shape)

def print_null_count(books, users, ratings):
    print(books.isnull().sum())
    print(users.isnull().sum())
    print(ratings.isnull().sum())

def print_duplicate_count(books, users, ratings):
    print(books.duplicated().sum(),ratings.duplicated().sum(),users.duplicated().sum())


def plot_ratings_distribution(ratings):
    plt.hist(ratings["Book-Rating"], bins=10)
    plt.xlabel("Rating")
    plt.ylabel("Frequency")
    plt.savefig('Ratings_distribution.png',dpi=300)
    plt.show()

def popularity_based_recommender(ratings):
    ratings_with_name = ratings.merge(books,on='ISBN')
    num_rating_df = ratings_with_name.groupby('Book-Title').count()['Book-Rating'].reset_index()
    num_rating

if __name__ == "__main__":
    set_plot_settings()
    books, users, ratings = load_data()
    count_unique_books_users(books, users, ratings)
    print_shape(books, users, ratings)
    print_null_count(books, users, ratings)
    print_duplicate_count(books, users, ratings)
    plot_ratings_distribution(ratings)
    popularity_based_recommender_df = popularity_based_recommender(ratings)
    print(popularity_based_recommender_df)

