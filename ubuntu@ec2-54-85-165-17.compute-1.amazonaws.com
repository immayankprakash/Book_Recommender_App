import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import pickle
from sklearn.metrics.pairwise import cosine_similarity


# Plot settings
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

# Loading data
books_df = pd.read_csv('data/Books.csv')
users_df = pd.read_csv('data/Users.csv')
ratings_df = pd.read_csv('data/Ratings.csv')


# Rename columns for consistency
books_df.rename(columns={'Book-Title': 'Title',
                        'Book-Author': 'Author',
                        'Image-URL-M': 'URL',
                        'Year-Of-Publication': 'Publication_Year'},
                         inplace=True)

ratings_df.rename(columns={'Book-Rating': 'Rating'},
                  inplace=True)


# Drop unnecessary columns
books_df.drop(['Image-URL-S', 'Image-URL-L'], axis=1, inplace=True)


# Count the number of unique books and users
num_books = len(books_df["ISBN"].unique())
num_users = len(users_df["User-ID"].unique())
print("Number of unique books: ", num_books)
print("Number of unique users: ", num_users)


# Print shape of dataframes
print("Books Dataframe Shape:", books_df.shape)
print("Ratings Dataframe Shape:", ratings_df.shape)
print("Users Dataframe Shape:", users_df.shape)


# Check for missing values
print("Missing values in books dataframe:", books_df.isnull().sum())
print("Missing values in users dataframe:", users_df.isnull().sum())
print("Missing values in ratings dataframe:", ratings_df.isnull().sum())


# Check for duplicate values
print("Duplicate values in books dataframe:", books_df.duplicated().sum())
print("Duplicate values in ratings dataframe:", ratings_df.duplicated().sum())
print("Duplicate values in users dataframe:", users_df.duplicated().sum())


# Ratings distribution
plt.hist(ratings_df["Rating"], bins=10)
plt.xlabel("Rating")
plt.ylabel("Frequency")
plt.title("Ratings Given by Users")
plt.savefig('images/Ratings_distribution.png', dpi=300)
plt.show()


# Authors with the highest number of books
author_counts = books_df["Author"].value_counts()
top_authors = author_counts.head(10)

# Top authors
top_authors.plot(kind='bar')
plt.xlabel("Author")
plt.ylabel("Number of Books")
plt.title("Top 10 Authors by Number of Books")
plt.savefig('images/Top_10_Authors.png',dpi=300)
plt.show()


# Popularity Based Recommender System

# Creating a new dataframe with the average rating and number of ratings for each book
ratings_with_name = ratings_df.merge(books_df,on='ISBN')
num_rating_df = ratings_with_name.groupby('Title').count()['Rating'].reset_index()
num_rating_df.rename(columns={'Rating':'Num_Ratings'},inplace=True)

avg_rating_df = ratings_with_name.groupby('Title').mean()['Rating'].reset_index()
avg_rating_df.rename(columns={'Rating':'Avg_Rating'},inplace=True)
popular_df = num_rating_df.merge(avg_rating_df,on='Title')
popular_df = popular_df[popular_df['Num_Ratings']>=250].sort_values('Avg_Rating',ascending=False).head(50)
popular_df = popular_df.merge(books_df,on='Title').drop_duplicates('Title')[['Title','Author','URL','Num_Ratings','Avg_Rating','Publication_Year','Publisher']]
print(popular_df['Title'][0])


# Collaborative Filtering Based Recommender System

# Filtering users with at least 25 ratings and books with at least 50 ratings
x = ratings_with_name.groupby('User-ID').count()['Rating'] > 25
filtered_users = x[x].index
filtered_rating = ratings_with_name[ratings_with_name['User-ID'].isin(filtered_users)]
y = filtered_rating.groupby('Title').count()['Rating']>=50
famous_books = y[y].index
final_ratings = filtered_rating[filtered_rating['Title'].isin(famous_books)]

# Creating a pivot table with books as rows and users as columns and replace NaN values with 0
pt = final_ratings.pivot_table(index='Title',columns='User-ID',values='Rating')
pt.fillna(0,inplace=True)

# Calculate cosine similarity
similarity_scores = cosine_similarity(pt)


def recommend(book_name):
    # index fetch
    index = np.where(pt.index==book_name)[0][0]
    similar_items = sorted(list(enumerate(similarity_scores[index])),key=lambda x:x[1],reverse=True)[1:5]

    # Get the details of the similar books
    data = []
    for i in similar_items:
        item = []
        temp_df = books_df[books_df['Title'] == pt.index[i[0]]]
        item.extend(list(temp_df.drop_duplicates('Title')['Title'].values))
        item.extend(list(temp_df.drop_duplicates('Title')['Author'].values))
        item.extend(list(temp_df.drop_duplicates('Title')['URL'].values))
        data.append(item)
    return data

# Example usage
print(recommend('1984'))

# Removing duplicate books based on title
books_df.drop_duplicates('Title',inplace=True)

# Saving the dataframes to pickle files for later use
pickle.dump(popular_df,open('models/popular.pkl','wb'))
pickle.dump(pt,open('models/pt.pkl','wb'))
pickle.dump(books_df,open('models/books.pkl','wb'))
pickle.dump(similarity_scores,open('models/similarity_scores.pkl','wb'))