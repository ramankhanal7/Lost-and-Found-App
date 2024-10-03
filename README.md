# Lost and Found App

This project is an iOS application designed to help users report and retrieve lost and found items within their community. Built using Swift and SwiftUI, the app allows users to create posts for items they have lost or found, view and search for posts, and interact with other users by commenting on posts.

## Features

- **User Registration and Login:** Users can sign up for an account and log in securely using their username and password. Passwords are hashed using SHA256 for security.
- **Post Creation:** Users can create posts categorized as either "Lost" or "Found," with detailed descriptions, locations, and the ability to upload images of the items.
- **Image Upload:** Integrated image upload functionality using `UIImagePicker` allows users to take or select pictures of lost/found items and upload them to the server.
- **Search and Filter:** Users can filter posts by category (Lost or Found) and search by title, description, or location.
- **User Profiles:** Users can view and edit their profile, including updating their profile image, bio, and other personal details.
- **Comments:** Users can comment on posts, providing a means for communication between those who have lost or found items.

## Technologies Used

### Frontend
- **Swift and SwiftUI:** Used for building the user interface, handling interactions, and managing the app's state.
- **SDWebImage:** For asynchronous image loading and caching within the app.

### Backend
- **Flask (Python):** The backend is built using Flask, a lightweight web framework.
- **SQLite:** The app uses SQLite for database management.
- **SQLAlchemy:** An ORM (Object-Relational Mapping) library used to interact with the database.
- **Werkzeug:** Used for handling file uploads securely.
  
### API Endpoints
The backend provides a set of RESTful APIs to handle:
- User registration, login, and profile management
- Post creation, retrieval, updating, and deletion
- Comment management (creation, retrieval, and deletion)
- Image uploading and retrieval

## How to Run the App

1. **Frontend (iOS App):**
   - Clone this repository and open the project in Xcode.
   - Build and run the app on your iOS simulator or a physical device.

2. **Backend (Flask API):**
   - Navigate to the `backend` folder and run the Flask server by executing:
     ```bash
     python app.py
     ```
   - Ensure that the SQLite database is properly set up by running database migrations.

## Future Enhancements

- **Push Notifications:** Notify users when their lost item has been found or when there is an update on their post.
- **Location-Based Search:** Implement more advanced location filtering for posts.
- **User Messaging:** Add a direct messaging feature for users to communicate privately regarding posts.

## Demo
https://www.youtube.com/watch?v=DcUpOmtydV8

