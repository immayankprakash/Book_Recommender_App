'''
Author: Mayank Prakash Pandey
'''

import pickle
import streamlit as st
import numpy as np

# Adding header and author information
st.header('Book Recommender')
st.markdown("A **Machine Learning** Powered App by :red[**Mayank Prakash Pandey**] :computer:")

# Loading the necessary pickle files
model = pickle.load(open('models/similarity_scores.pkl', 'rb'))
final_rating = pickle.load(open('models/books.pkl', 'rb'))
book_pivot = pickle.load(open('models/pt.pkl', 'rb'))
top_books = pickle.load(open('models/popular.pkl','rb'))

# Creating a sidebar panel with a list of books
df=top_books
st.sidebar.title("Top 50 Books")
book_list = st.sidebar.selectbox("Select a book", df['Title'])

# Show the selected book's title and rating on the main page
if book_list:
    selected_book = df[df['Title'] == book_list]
    st.sidebar.title("Selected Book")
    st.sidebar.image(selected_book['URL'].values[0])
    st.sidebar.write("Title :red[:] ", selected_book['Title'].values[0])
    st.sidebar.write("Author :red[:] ", selected_book['Author'].values[0])
    st.sidebar.write("Rating :red[:] ", np.round(selected_book['Avg_Rating'].values[0],2),"(",str(selected_book['Num_Ratings'].values[0]),"votes)")
    st.sidebar.write("Publisher :red[:] ", selected_book['Publisher'].values[0])
    st.sidebar.write("Year :red[:] ", str(selected_book['Publication_Year'].values[0]))

# Defining the recommendation function
def recommend_book(book_name):
    # Fetch the index of the selected book
    index = np.where(book_pivot.index == book_name)[0][0]
    # Top 3 similar books
    similar_items = sorted(list(enumerate(model[index])), key=lambda x: x[1], reverse=True)[1:5]

    data = []
    for i in similar_items:
        item = []
        temp_df = final_rating[final_rating['Title'] == book_pivot.index[i[0]]]
        item.extend(list(temp_df.drop_duplicates('Title')['Title'].values))
        item.extend(list(temp_df.drop_duplicates('Title')['Author'].values))
        item.extend(list(temp_df.drop_duplicates('Title')['URL'].values))
        data.append(item)
    return data

# Create a dropdown to select a book
selected_books = st.selectbox(
    "**Type or select a book from the dropdown**",
    book_pivot.index.values
)


if st.button('Show Recommendation'):
    recommended_books  = recommend_book(selected_books)
    col1, col2, col3 = st.columns(3,gap="large")
    with col1:
        st.image(recommended_books[1][2])
        st.text(recommended_books[1][0])
        st.text(recommended_books[1][1])
    with col2:
        st.image(recommended_books[2][2])
        st.text(recommended_books[2][0])
        st.text(recommended_books[2][1])
    with col3:
        st.image(recommended_books[3][2])
        st.text(recommended_books[3][0])
        st.text(recommended_books[3][1])


hide_menu_style="""
            <style>
 #           #MainMenu {visibility: hidden;}
            footer {visibility:hidden;}
            </style>
            """
st.markdown(hide_menu_style, unsafe_allow_html=True)
