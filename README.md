# VK iOS Client

A fully native iOS client for the VK.com social network, built from scratch to explore client-server architecture, API integration, and performance optimization in a real-world application.

Developed as a pet project, this project serves as a technical showcase of clean code best practices using a modern reactive programming approach, secure data persistence, and scalable code patterns.

The app consumes the open [VK API](https://dev.vk.com).

## Tech Stack
* **Architecture:** MVP (Clean Code principles)
* **Frameworks:** UIKit + Reactive programming with Combine
* **Data Persistence:** Realm Database
* **Security:** Keychain (for secure token management)

## Key Features

**Authentication & Security**
* Secure login to VK services via OAuth 2.0.
* Safe, persistent storage of user access tokens using the iOS Keychain.

**News Feed & Media**
* Dynamic news feed displaying friends' posts and community updates.
* Tracks and displays metrics including likes, comments, reposts, and total views.
* Infinite scrolling for seamless news feed pagination and continuous data updates.
* Native video playback directly within the news feed.

**Social Interactions**
* **Profiles & Friends:** View your friend list, explore individual profiles, and browse detailed photo albums.
* **Posts:** Browse user and community walls, check for new posts, read comments, and leave likes.
* **Communities:** Search for new communities, view your current groups, and manage your memberships (join/leave).
* **Newsfeed:** Build your own newsfeed based on your groups/friends activities.

**Offline Access**
* Key data models (Groups, Friends, and Photos) are cached to a local Realm database for rapid retrieval and offline availability.
