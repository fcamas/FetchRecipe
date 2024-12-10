# Fetch Mobile Take Home Project

## Table of Contents
1. [Overview](#overview)
2. [Steps to Run the App](#steps-to-run-the-app)
3. [Focus Areas](#focus-areas)
4. [Time Spent](#time-spent)
5. [Trade-offs and Decisions](#trade-offs-and-decisions)
6. [Weakest Part of the Project](#weakest-part-of-the-project)
7. [Additional Information](#additional-information)


![recipeApp](https://github.com/user-attachments/assets/416501ed-b8b0-416b-aacd-d5341c23a2b9)

---

### Description

This project is a recipe app that allows users to view, refresh, and interact with a list of recipes fetched from a provided API endpoint. Each recipe displays the recipe's name, photo, and cuisine type. The app can handle different data states, such as empty data and malformed data, and provides a smooth user experience using Swift Concurrency for asynchronous operations.

### Key Features
- **Fetch Recipes**: Displays a list of recipes fetched from a remote API endpoint.
- **Refreshable UI**: The recipe list can be refreshed at any time to fetch the latest data.
- **Image Caching**: Images are loaded lazily and cached on disk to reduce unnecessary network usage.
- **Error Handling**: Gracefully handles errors such as malformed or empty data from the API.

## Steps to Run the App
1. Clone the repository to your local machine using `git clone <repository_url>`.
2. Open the project in Xcode.
3. Make sure your development environment is set up for iOS 16+.
4. Build and run the app on the simulator or a physical device.

## Focus Areas

### Areas of Focus
1. **Concurrency**: I focused heavily on leveraging Swift’s async/await for handling API calls and loading images. Using async/await ensures that the app runs smoothly and efficiently without blocking the main thread, especially during network requests and image rendering.
   
2. **Error Handling**: I implemented robust error handling to manage scenarios such as malformed data, empty data, and network issues. If the data is malformed, the app disregards the list and presents an error message. For empty data, the app displays a friendly message indicating that no recipes are available.

3. **Image Caching**: I implemented custom image caching to reduce unnecessary network calls by storing images locally. When a user scrolls through the recipe list, images are only loaded if needed and cached for future use, optimizing performance and network usage.

4. **UI/UX**: The app’s UI is simple, with a clear layout for viewing recipes. I prioritized clean, intuitive design, ensuring that the recipe list is easy to navigate. The refresh control allows users to manually update the recipe list, and appropriate loading states are shown during network activity.

## Time Spent

- **Total Time**: I spent approximately 4-5 hours working on this project.
- **Time Allocation**:
  - **API Integration & Data Handling**: 2 hours — Fetching data from the provided API and handling different data states (empty, malformed).
  - **Image Caching**: 1 hour — Implementing a custom disk-based caching mechanism for images.
  - **UI/UX**: 1 hour — Designing a simple and intuitive interface to display recipes.
  - **Error Handling & Testing**: 1 hour — Implementing error handling and writing basic unit tests for the data fetching and caching logic.

## Trade-offs and Decisions

1. **UI Simplicity**: I decided to keep the UI simple and focused on functionality. Although it could be enhanced with features like filtering or sorting, I wanted to prioritize the core functionality and meet the project’s requirements within the time limit.

2. **Custom Image Caching vs URLSession**: While URLSession’s built-in caching could be used, I opted to implement a custom caching solution to demonstrate more control over the process. This ensures that images are cached explicitly to disk, reducing unnecessary network traffic and improving performance.

3. **Unit Testing**: I chose to focus testing efforts on the core logic — data fetching and caching — instead of full UI tests. Since the main goal was to showcase the app's functionality, I felt that the unit tests would demonstrate my understanding of testing without overcomplicating the task.

## Weakest Part of the Project

The weakest part of the project may be the **lack of complex UI components**. Given the time constraints, the UI is quite simple, and there could be opportunities for better enhancements such as showing recipe ratings, a search function, or adding more detailed error screens. Additionally, there is no testing for the UI or integration, which would be an area to improve if given more time.

## Additional Information

- **Async Image Loading**: Images are loaded asynchronously and cached to disk for future use, ensuring efficient network usage and minimizing delays during scrolling.
- **Data Source**: The app uses a remote API, and I ensured that error handling was in place for malformed or empty data scenarios.
- **Testing**: Unit tests focus on validating the API data fetching logic and the image caching mechanism, ensuring that the app behaves correctly under various conditions.
- **Design Decisions**: I kept the app's design minimal to meet the time constraints, but additional features such as pagination, sorting, or advanced filtering could be added for a more comprehensive experience.

