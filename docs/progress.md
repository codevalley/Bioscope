# Progress

## Chunk 4: Food Entry Data Structure Revamp and Supabase Integration

### Chunk Overview

- **Description**: Revamp the food entry data structure to mimic a nutrition info label, providing more comprehensive nutritional information, and integrate Supabase as an alternative data source.
- **Milestone**: Updated food entry system with detailed nutritional data, corresponding UI changes, and Supabase integration for both FoodEntry and UserProfile.

### Tasks

#### Completed Tasks

- [x] **Task 4.1**: Redesign FoodEntry entity
  - Notes: Updated FoodEntry to include more nutritional information

- [x] **Task 4.2**: Implement FoodEntrySupabaseDs
  - Notes: Created Supabase data source for FoodEntry

- [x] **Task 4.3**: Implement UserProfileSupabaseDs
  - Notes: Created Supabase data source for UserProfile

- [x] **Task 4.4**: Update dependency injection
  - Notes: Modified dependency_injection.dart to support both SQLite and Supabase data sources

- [x] **Task 4.5**: Update FoodEntryRepositoryImpl
  - Notes: Ensured repository works with both SQLite and Supabase data sources

- [x] **Task 4.6**: Update UserRepositoryImpl
  - Notes: Ensured repository works with both SQLite and Supabase data sources

- [x] **Task 4.7**: Modify DashboardNotifier
  - Notes: Updated to use watchAll method for real-time updates

- [x] **Task 4.8**: Update AddFoodEntryScreen
  - Notes: Modified UI to allow input of more detailed nutritional information

- [x] **Task 4.9**: Update Dashboard UI
  - Notes: Adjusted dashboard to display more comprehensive nutritional information
  - Implemented NutritionInfoWidget for reusable nutrition display
  - Redesigned RecentHistory widget for better visual appeal
  - Added FoodEntryDetailScreen for detailed food entry view

#### Pending Tasks

- [ ] **Task 4.10**: Optimize Supabase Data Fetch
  - Status: To Do
  - Assigned to: [Team Member Name]
  - Notes: Investigate and improve the speed of Supabase data fetching to reduce initial loading time

- [ ] **Task 4.11**: Implement Real-time Updates for Dashboard
  - Status: To Do
  - Assigned to: [Team Member Name]
  - Notes: Utilize Supabase's reactivity capabilities to automatically update food history after adding a new entry

- [ ] **Task 4.12**: Enhance Error Handling for Nutrition Analysis
  - Status: To Do
  - Assigned to: [Team Member Name]
  - Notes: Implement robust error handling for analyze API response, ignoring empty or incorrectly formatted components except for the mandatory "Calories" field

### Issues and Blockers

- Supabase data fetch is currently slow, causing delays in app start and dashboard element loading
- Food history is not updating automatically after adding a new entry
- Error handling for nutrition analysis API response needs improvement

### Notes

- Supabase integration provides real-time capabilities and cloud syncing.
- Need to ensure proper error handling and offline support when using Supabase.
- Consider implementing a sync mechanism between SQLite and Supabase for offline-first functionality.
- Optimization of Supabase data fetching is crucial for improving app performance.
- Implementing real-time updates for the dashboard will enhance user experience.
- Robust error handling for nutrition analysis will improve app reliability.
- The new NutritionInfoWidget improves code reusability and consistency in nutrition data display.
- The redesigned RecentHistory widget and new FoodEntryDetailScreen enhance the user experience.

### Next Steps

1. Optimize Supabase data fetching to reduce initial loading times
2. Implement real-time updates for the dashboard using Supabase's reactivity features
3. Enhance error handling for nutrition analysis API responses
4. Implement Supabase authentication for user management
5. Consider adding more interactive elements to the FoodEntryDetailScreen, such as editing capabilities

## Chunk 5: Food Capture Interface Development

### Chunk Overview

- **Description**: Implementing the food capture interface and integrating it with the nutrition analysis backend
- **Milestone**: Users can capture food entries via text input or image capture, review nutrition information, and save entries

### Tasks

#### Completed Tasks

- [x] **Task 5.1: Design Food Capture UI**
  - Notes: Implemented AddFoodEntryScreen with camera interface and text input mode

- [x] **Task 5.2: Implement FoodCaptureBloc**
  - Notes: Defined states and events, implemented logic for handling user input and state transitions

- [x] **Task 5.3: Integrate Image Capture Functionality**
  - Notes: Implemented image capture and gallery selection using image_picker package

- [x] **Task 5.4: Integrate Text Input Functionality**
  - Notes: Implemented text input field for manual food entry

- [x] **Task 5.5: Implement Placeholder RemoteNutritionService**
  - Notes: Created NutritionService with API integration for food analysis


#### Pending Tasks

- [ ] **Task 5.7: Implement Error Handling**
  - Status: To Do
  - Assigned to: [Team Member Name]

- [ ] **Task 5.8: Add Confirmation Screen**
  - Status: To Do
  - Assigned to: [Team Member Name]

- [ ] **Task 5.9: Integrate with Dashboard**
  - Status: To Do
  - Assigned to: [Team Member Name]

### Issues and Blockers

- Secure storage for API key not yet implemented
- Need to improve error handling in NutritionService and FoodCaptureBloc

### Notes

- **AddFoodEntryScreen Update**: Implemented UI for both image capture and text input. Added functionality to select images from gallery and take photos with the camera.
- **FoodCaptureBloc Update**: Implemented basic state management for food capture process. Needs further refinement for error handling.
- **NutritionService Update**: Integrated with backend API for food analysis. Handles both image and text-based requests.
- **API Integration**: Currently using a placeholder in ApiConfig for the API key. Need to implement secure storage.
- **Data Model Updates**: Updated FoodEntry, NutritionInfo, and related models to accommodate full nutrition data from API responses.
- **Repository Updates**: Modified FoodEntryRepository and its implementation to work with the new data structures.

### Next Steps

1. Complete the integration of FoodCaptureBloc with AddFoodEntryScreen
2. Implement comprehensive error handling throughout the food capture process
3. Create a confirmation screen for users to review nutrition information before saving
4. Integrate the food capture flow with the dashboard for seamless user experience
5. Implement secure storage for the API key

## Chunk 6: Dashboard UI Redesign

### Chunk Overview

- **Description**: Redesign the dashboard screen to follow an Instagram-like layout with improved food history display and nutrition goal visualization.
- **Milestone**: Updated dashboard with a more visually appealing and user-friendly interface.

### Tasks

#### Completed Tasks

- [x] **Task 6.1: Redesign RecentHistory Widget**
  - Notes: Updated RecentHistory to display food entries in an Instagram-like card layout

- [x] **Task 6.2: Create NutritionIndicator Widget**
  - Notes: Implemented a new widget to display daily nutrition goal progress

- [x] **Task 6.3: Update DashboardScreen Layout**
  - Notes: Restructured DashboardScreen to include DashboardTopSection, scrollable RecentHistory, and "Add Food" button in a bottom bar

- [x] **Task 6.4: Update DashboardBottomBar and DashboardTopSection**
  - Notes: Updated the design for DashboardBottomBar and DashboardTopSection

- [x] **Task 6.5: Separate FoodEntryItem into a new widget**
  - Notes: Created a new FoodEntryItem widget for individual food entries

#### Pending Tasks

- [ ] **Task 6.6: Implement Navigation to AddFoodEntryScreen**
  - Status: To Do
  - Assigned to: [Team Member Name]
  - Notes: Add functionality to the "Add Food" button to navigate to the food entry screen

- [ ] **Task 6.7: Integrate Real Data with Dashboard**
  - Status: To Do
  - Assigned to: [Team Member Name]
  - Notes: Connect the dashboard with actual user data from the repository

- [ ] **Task 6.8: Implement Pull-to-Refresh Functionality**
  - Status: To Do
  - Assigned to: [Team Member Name]
  - Notes: Add the ability to refresh the dashboard data by pulling down on the screen

### Issues and Blockers

- Need to ensure that the new layout is responsive on different screen sizes
- May need to optimize image loading for better performance in the RecentHistory widget

### Notes

- The new Instagram-like layout provides a more familiar and engaging user experience
- Consider adding animations to smooth transitions between screens and when loading new data
- Explore the possibility of adding quick actions (like delete or edit) to food history items

### Next Steps

1. Complete the integration of the new dashboard design with the existing data flow
2. Implement navigation to the AddFoodEntryScreen
3. Add pull-to-refresh functionality for updating dashboard data
4. Conduct user testing to gather feedback on the new design
5. Optimize performance, especially for image loading in the food history

## References

- [Pitch.md](./Pitch.md)
- [Approach.md](./Approach.md)
- [DesignLanguage.md](./DesignLanguage.md)
- [ProjectPlan.md](./ProjectPlan.md)