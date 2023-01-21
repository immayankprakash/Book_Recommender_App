# A Personalized Book Recommendation App

Find the App : <a href="https://immayankprakash-book-recommender-app-app-33rl58.streamlit.app/">Book Recommendation Engine</a> <br>
By : Mayank Prakash Pandey

## Description 
This project is an innovative book recommendation app that uses machine learning algorithms to suggest books to users based on their reading history and 
preferences. The app, built using the streamlit library, not only shows the top 50 books based on popularity, but also uses cosine similarity to recommend 
3 personalized books to the reader based on their selection. The app is deployed on AWS EC2, making it accessible to users from anywhere. The deployment
uses streamlit, which allows for easy updates and maintenance of the app. With this app, readers can discover new books and expand their reading horizons,
making reading an even more enjoyable experience.

## Data
The data used in this project was obtained from <a href="https://www.kaggle.com/datasets/arashnic/book-recommendation-dataset/">Kaggle</a>  and consists of book information and user ratings. The data was preprocessed and cleaned before
being used for training the recommendation algorithm.

## Method
The recommendation algorithm used in this project is based on collaborative filtering. It uses the user's past reading history and preferences to suggest
new books that they may be interested in.

### Collaborative Filtering 
Collaborative filtering is a method of making recommendations by analyzing the preferences and behaviors of users. It is based on the idea that users who have similar preferences in the past will have similar preferences in the future. In collaborative filtering, there are two main types of algorithms: user-based and item-based. User-based collaborative filtering looks at the preferences of similar users and recommends items that those users have liked. Item-based collaborative filtering looks at the similarity between items and recommends items that are similar to the ones a user has liked in the past.

<p align="center">
  <img src="https://github.com/immayankprakash/Book_Recommender_App/blob/main/images/cf.png" width='400' height= '400' /> 
<p>

## App Usage
To use the app, simply navigate to the app's URL. The app will show top 50 books based on the rating on the side panel. You can choose a book from the drop down 
menu and hit on "`show recommendation`" button, the app will suggest you 3 new books based on your selection.

## Deployement
The app is currently deployed on `AWS EC2` and `streamlit` instance and can be accessed by the provided URL.

## Conclusion
This book recommendation app is a great tool for readers to discover new books based on their reading history and preferences. The app is easy to use and deploy and
makes use of a `cosine similarity` algorithm. If you have any questions or feedback, please do not hesitate to contact.

## Future Work
<ul>
  <li>Adding a feature that allows users to save their recommended books and create reading lists.</li>
  <li>Integrating with a book store API to allow users to purchase recommended books directly from the app.</li>
  <li>Improving the recommendation algorithm by incorporating more data and using more advanced techniques such as deep learning.</li>
  <li>Adding a feature that allows users to share their recommended books with friends and family.</li>
  <li>Making the app more interactive by adding a chatbot that will help users find books based on their preferences.</li>
  <li>Expanding the app to other languages to reach a wider audience.</li>
  <li>Improving the app's design and user experience to make it more user-friendly.</li>
  <li>Adding a feature that allows users to review books and read reviews from other readers to make a more informed decision.</li>
</ul>
