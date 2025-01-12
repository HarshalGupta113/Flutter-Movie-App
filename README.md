# Flutter Movie App

A Flutter-based movie app that uses the TVMaze API to display movies and TV shows. This project demonstrates key Flutter concepts such as API integration, navigation, state management, and responsive UI design.

## Features

- **Home Screen**: Displays a list of movies and shows fetched from the TVMaze API.
- **Search Screen**: Allows users to search for movies or shows.
- **Detail Screen**: Shows detailed information about a selected movie, including its episodes.
- **Season Selector**: Enables users to select a season and view corresponding episodes.

## Screenshots

### Home Screen
<img src="screenshots/home_screen.png" alt="Home Screen" width="300"/>

### Search Screen
<img src="screenshots/search_screen.png" alt="Search Screen" width="300"/>

### Detail Screen
<img src="screenshots/detail_screen.png" alt="Detail Screen" width="300"/>

### Episodes by Season
<img src="screenshots/episodes_screen.png" alt="Episodes Screen" width="300"/>



## API Used

This app uses the [TVMaze API](https://www.tvmaze.com/api) for fetching movies, shows, and episodes.

### Endpoints:
- **Get All Shows**: `https://api.tvmaze.com/search/shows?q=all`
- **Search Shows**: `https://api.tvmaze.com/search/shows?q={search_term}`
- **Get Episodes**: `https://api.tvmaze.com/shows/{id}/episodes`

## Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/your-username/flutter-movie-app.git
   cd flutter-movie-app

2. Install dependencies:
   flutter pub get
3. Run the app:
   flutter run

Requirements
Flutter SDK (2.0 or later)
Dart SDK
Android Studio 