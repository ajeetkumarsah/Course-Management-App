## Course Management App

Welcome to the Course Management App! This Flutter application allows users to view courses, search for specific courses, and manage user data. Below you'll find instructions to set up and run the app on your local machine.

---

### Prerequisites

Before setting up the project, ensure you have the following installed:

1. **Flutter**: Install [Flutter SDK](https://flutter.dev/docs/get-started/install) for your platform (macOS, Windows, or Linux).
   
   After installation, verify by running:

   ```bash
   flutter doctor
   ```

2. **Dart SDK**: The Dart SDK comes with Flutter, but ensure it's installed.
   
3. **Android Studio/VS Code**: Choose a code editor:
   - [Android Studio](https://developer.android.com/studio) or
   - [VS Code](https://code.visualstudio.com/) (with Flutter plugin)

4. **Xcode (macOS only)**: For iOS development, install Xcode from the [Mac App Store](https://apps.apple.com/us/app/xcode/id497799835?mt=12).

5. **Firebase** (if using Firebase for backend services):
   - Set up a Firebase project at [Firebase Console](https://console.firebase.google.com/).
   - Add `google-services.json` (Android) or `GoogleService-Info.plist` (iOS).

---

### Setup Instructions

1. **Clone the Repository**

   First, clone the repository to your local machine:

   ```bash
   git clone https://github.com/ajeetkumarsah/Course-Management-App.git
   cd Course-Management-App
   ```

2. **Install Dependencies**

   Run the following command to install all necessary dependencies:

   ```bash
   flutter pub get
   ```

3. **Set Up Firebase (if applicable)**

   - For **Android**: Download the `google-services.json` from Firebase Console and place it in the `android/app/` directory.
   - For **iOS**: Download the `GoogleService-Info.plist` from Firebase Console and place it in the `ios/Runner/` directory.

4. **Run the Application**

   To run the app on your local device or emulator, execute:

   ```bash
   flutter run
   ```

   - For **iOS (macOS only)**, ensure you have a valid Xcode setup and run:

     ```bash
     flutter run
     ```

---

### Running Tests

To run unit tests for the app, use the following command:

```bash
flutter test
```

This will execute all test files located in the `test/` directory.

---

### Build Instructions

If you want to build the app for production or release:

- **For Android (APK)**:

  ```bash
  flutter build apk
  ```

- **For iOS**:

  ```bash
  flutter build ios
  ```

---

### Troubleshooting

1. **Flutter Doctor**: If you encounter issues, run `flutter doctor` to check your environment.
   
2. **Clear Cache**: Sometimes, clearing the Flutter build cache can help:

   ```bash
   flutter clean
   flutter pub get
   ```

3. **Check Dependencies**: If you face issues with specific dependencies (like Firebase), make sure you've set up the platform-specific configurations correctly.



### **How Provider was Used for State Management**

Provider was used as the state management solution to handle the application’s state efficiently. Below is a breakdown of its use:

1. **Centralized State Management**:
   - A `CourseProvider` class was created, extending `ChangeNotifier`. This class acts as the central repository for managing data and notifying widgets of state changes.
   - Example:
     ```dart
     class CourseProvider extends ChangeNotifier {
       List<CourseModel> _courses = [];
       bool _isLoading = false;

       List<CourseModel> get courses => _courses;
       bool get isLoading => _isLoading;

       Future<void> fetchCourses(int page) async {
         _isLoading = true;
         notifyListeners();
         try {
           final newCourses = await ApiService().fetchCourses(page);
           _courses.addAll(newCourses);
         } finally {
           _isLoading = false;
           notifyListeners();
         }
       }
     }
     ```

2. **Efficient Updates**:
   - `notifyListeners()` was called only when state changes were required, ensuring that only necessary widgets were rebuilt.
   - Example: Updating the list of courses and triggering a UI refresh.

3. **Dependency Injection**:
   - The `CourseProvider` was injected into the widget tree using `ChangeNotifierProvider`.
     ```dart
     ChangeNotifierProvider(
       create: (context) => CourseProvider(),
       child: CourseManagementApp(),
     );
     ```

---

### **Lazy Loading Implementation**

Lazy loading was implemented to handle large datasets and ensure smooth performance:

1. **ScrollController**:
   - A `ScrollController` was used to detect when the user scrolls near the bottom of the list.
   - Example:
     ```dart
     _scrollController.addListener(() {
       if (_scrollController.position.pixels ==
           _scrollController.position.maxScrollExtent) {
         provider.fetchCourses(currentPage++);
       }
     });
     ```

2. **Pagination**:
   - Courses were fetched in chunks using the `page` parameter in the API call. Each subsequent request fetched the next set of courses.

3. **UI Feedback**:
   - A loading spinner (`CircularProgressIndicator`) was displayed at the bottom of the list when fetching additional data.

---

### **Key Performance Optimizations**

1. **Efficient Widget Rebuilds**:
   - The `Consumer` widget was used to listen to state changes only for specific parts of the UI, minimizing unnecessary rebuilds.
   - Example:
     ```dart
     Consumer<CourseProvider>(
       builder: (context, provider, child) {
         return ListView.builder(
           itemCount: provider.courses.length,
           itemBuilder: (context, index) {
             return CourseCard(course: provider.courses[index]);
           },
         );
       },
     );
     ```

2. **Const Widgets**:
   - Widgets that did not depend on dynamic data were marked as `const` to optimize rendering.

3. **Breaking Down Widgets**:
   - Large widgets were broken into smaller, reusable components (e.g., `CourseCard`).

4. **Network Call Debouncing**:
   - For search functionality, a debounce mechanism ensured that API calls were made only after the user stopped typing.

---

### **Difference Between Provider, BLoC, and Riverpod**

| Feature              | **Provider**                              | **BLoC**                                    | **Riverpod**                              |
|----------------------|-------------------------------------------|---------------------------------------------|-------------------------------------------|
| **Architecture**     | Simplified state management using `ChangeNotifier`. | Follows a strict reactive pattern with streams and events. | A more modern, flexible approach to state management. |
| **Learning Curve**   | Beginner-friendly.                       | Steeper due to streams and reactive concepts. | Medium, with better documentation and tooling. |
| **State Management** | Uses `ChangeNotifier` for state updates.  | Uses streams to emit state changes.         | Uses providers to manage state more elegantly. |
| **Performance**      | Efficient for most use cases.             | Optimized but requires more boilerplate.    | Highly optimized and boilerplate-free.   |
| **Use Cases**        | Suitable for smaller to medium-sized apps.| Ideal for complex, large-scale apps.        | Works for all app sizes, especially modern projects. |

---

Feel free to explore the [GitHub repository](https://github.com/ajeetkumarsah/Course-Management-App) for the detailed implementation! Let me know if you have further questions.
