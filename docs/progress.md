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

#### Pending Tasks

- [ ] **Task 4.8**: Update AddFoodEntryScreen
  - Status: To Do
  - Assigned to: [Team Member Name]
  - Notes: Modify UI to allow input of more detailed nutritional information

- [ ] **Task 4.9**: Update Dashboard UI
  - Status: To Do
  - Assigned to: [Team Member Name]
  - Notes: Adjust dashboard to display more comprehensive nutritional information

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

### Next Steps

1. Optimize Supabase data fetching to reduce initial loading times
2. Implement real-time updates for the dashboard using Supabase's reactivity features
3. Enhance error handling for nutrition analysis API responses
4. Complete the remaining UI updates for AddFoodEntryScreen and Dashboard
5. Implement Supabase authentication for user management

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

## References

- [Pitch.md](./Pitch.md)
- [Approach.md](./Approach.md)
- [DesignLanguage.md](./DesignLanguage.md)
- [ProjectPlan.md](./ProjectPlan.md)