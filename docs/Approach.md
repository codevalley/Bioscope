# Approach Document

## I. Introduction

Our mission is to craft a beautifully designed and reliable core experience for the personal nutrition coach app, now with an added social dimension. We'll build upon this foundation by integrating user feedback and data-driven improvements over time. Central to this effort is a visually engaging, Instagram-like feed for food entries, supplemented by seamless food capture, intuitive onboarding, and thoughtful guidance through ephemeral prompts (floating thoughts).

This document outlines the detailed definitions and designs for:

- Feed Screen (formerly Dashboard)
- Food Capture Interface
- Onboarding and User Profile
- Social Features and Public Feed
- Guidance and Insights

Additionally, we provide an elaborate description of the design language to guide our UI developers in creating a cohesive and engaging user interface.

## II. Feed Screen (formerly Dashboard)

*The heart of the app—a visually engaging, Instagram-like feed that provides users with immediate insight into their nutritional intake, progress toward their goals, and social interactions.*

**A. Purpose and Functionality**

- **Social Engagement**: Present a scrollable feed of the user's and followed users' food entries.
- **Nutritional Insight**: Display current calorie and nutrient consumption vs. daily targets in an easily digestible format.
- **Motivational Visuals**: Use engaging visuals to motivate users without overwhelming them.
- **Seamless Interaction**: Provide effortless transitions between viewing the feed, capturing new food entries, and interacting with posts.

**B. Design Elements**

1. **Layout and Structure**
   - **Full-Screen Feed Design**: The feed utilizes the entire display, creating an immersive experience similar to Instagram.
   - **Vertical Scrolling**: Users can scroll vertically through the feed of food entry posts.

2. **Feed Posts**
   - **Post Structure**:
     - User avatar and name
     - Food entry image
     - Caption or notes
     - Nutrition information summary
     - Like and comment buttons
     - Timestamp

3. **Nutrition Overview**
   - **Sticky Header or Pull-Down View**:
     - Quick summary of daily nutrition progress
     - Circular progress indicators for calories and key nutrients

4. **Add Entry Call-to-Action (CTA)**
   - **Prominent Button**:
     - Design: A large, circular button with a '+' icon, similar to Instagram's add post button.
     - Placement: Fixed position at the bottom right of the screen.

**C. User Flow**

1. **Upon Opening the App**
   - **Immediate Engagement**: Users see their personalized feed without any loading screens.
   - **Pull to Refresh**: Users can pull down to refresh the feed and nutrition data.

2. **Interacting with the Feed**
   - **Viewing Posts**: Users can scroll through the feed, viewing their own and followed users' food entries.
   - **Liking and Commenting**: Users can interact with posts through likes and comments.
   - **Viewing Details**: Tapping on a post opens a detailed view with full nutrition information.

3. **Adding a Food Entry**
   - **Capture Interface**: Tapping the '+' button opens the food capture interface.
   - **Quick Add**: Long-pressing the '+' button could open a quick-add menu for frequently logged items.

## III. Food Capture Interface

*An intuitive interface that allows users to effortlessly log their meals through minimal steps, integrating seamlessly with the feed.*

**A. Purpose and Functionality**

- **Effortless Logging**: Minimize friction in logging food entries to encourage consistent use.
- **Intelligent Recognition**: Leverage AI for image recognition and learning from user habits.
- **Social Sharing**: Allow users to easily share their food entries on their feed.

**B. Design Elements**

1. **Capture Methods**
   - **Photo Capture**:
     - Full-screen camera interface activated upon tapping "Add Entry."
     - Overlay instructions and capture button.
   - **Text Input**:
     - Clean, full-screen card with a large text field for typing or dictating meal details.
   - **Quick Selection**:
     - Option to quickly select from recently or frequently logged items.

2. **Confirmation Screen**
   - **Layout**: Full-screen card summarizing the detected food items and nutrition info.
   - **Content**:
     - Editable meal title and description.
     - List of detected food items with quantities and nutrition info.
     - Option to add or remove items manually.
   - **Social Sharing Options**:
     - Toggle for public/private posting.
     - Option to add a caption for the feed post.

3. **Actions**
   - Edit options for adjusting quantities or making corrections.
   - "Post to Feed" button to save the entry and share it on the user's feed.

**C. User Flow**

1. **Initiating Capture**
   - From Feed Screen: User taps the "+" button.
   - Default to camera interface, with options to switch to text input or quick selection.

2. **Capturing and Confirming**
   - Real-time processing of captured images or text input.
   - Review and edit detected items and nutrition information.
   - Add social elements like captions and privacy settings.

3. **Posting to Feed**
   - Tapping "Post to Feed" saves the entry, adds it to the user's feed, and returns to the Feed Screen.
   - The Feed Screen updates to show the new entry.

## IV. Onboarding and User Profile

*An intuitive onboarding process that quickly sets up the user with a personalized profile, ensuring they can start using the app effectively from the outset.*

**A. Purpose and Functionality**

- **Immediate Value**: Guide users to the core functionality swiftly.
- **Personalization**: Collect essential information to tailor the app experience.
- **Goal Setting**: Allow users to set detailed nutrition goals.

**B. Design Elements**

1. **Welcome Screen**
   - Greeting message and brief app description.
   - Options for sign-up or login, including Google Sign-In.

2. **Profile Setup**
   - Input fields for name, age, height, weight, and gender.
   - Profile picture upload option.

3. **Goal Setting**
   - Daily calorie goal input.
   - Macronutrient distribution setting (protein, carbs, fat percentages).
   - Option to set goals for specific micronutrients.

4. **Dietary Preferences**
   - Selection of dietary restrictions or preferences (e.g., vegetarian, vegan, gluten-free).

5. **Feed Customization**
   - Options to select interests or types of food posts to see in the public feed.

**C. User Flow**

1. **Account Creation**
   - Users can sign up with email or use Google Sign-In.
   - Brief explanation of data usage and privacy policy.

2. **Profile and Goal Setting**
   - Step-by-step guide through profile creation and goal setting.
   - Option to skip detailed setup and use default goals.

3. **Feed Introduction**
   - Brief tutorial on how to use the feed, add entries, and interact with posts.

## V. Social Features and Public Feed

*Engaging social features that allow users to connect, share, and discover through a public feed of food entries.*

**A. Purpose and Functionality**

- **Community Building**: Foster a supportive community around healthy eating habits.
- **Inspiration**: Provide users with ideas and motivation from others' food choices.
- **Education**: Facilitate learning about nutrition through shared experiences.

**B. Design Elements**

1. **Public Feed**
   - Similar layout to the main feed, but with posts from all public users.
   - Discover tab or search functionality to find new users or specific types of food entries.

2. **User Profiles**
   - Public profile pages showing user's public food entries and summary statistics.
   - Follow/Unfollow buttons.

3. **Interactions**
   - Like and comment functionality on public posts.
   - Option to share interesting posts to one's own feed.

4. **Privacy Controls**
   - Granular privacy settings for each post (public, followers only, private).
   - Option to make entire profile private.

**C. User Flow**

1. **Accessing the Public Feed**
   - Tab or button in the main navigation to switch to the public feed.
   - Infinite scrolling through public posts.

2. **Discovering and Following Users**
   - Search functionality to find users by username or food types.
   - Suggested users based on similar goals or interests.

3. **Interacting with Posts**
   - Liking, commenting, and sharing public posts.
   - Viewing and responding to interactions on own posts.

## VI. Guidance and Insights

*Providing users with meaningful feedback through subtle, contextually relevant prompts and insights to support their goals without causing distractions.*

**A. Purpose and Functionality**

- **Supportive Nudges**: Offer guidance as gentle reminders rather than intrusive notifications.
- **Contextual Relevance**: Ensure prompts are timely and based on user habits and progress.
- **Community Insights**: Provide insights based on community trends and successful practices.

**B. Design Elements**

1. **Floating Thoughts**
   - Small, rounded rectangular cards that appear temporarily on the feed.
   - Short, encouraging messages or tips based on user's progress and community insights.

2. **Insights Dashboard**
   - Accessible through a tab or by swiping up on the feed.
   - Displays detailed progress towards goals, trends, and achievements.
   - Community comparisons and success stories.

3. **Smart Notifications**
   - Customizable push notifications for reminders, goal achievements, and social interactions.
   - In-app notification center for a summary of recent activities and insights.

**C. User Flow**

1. **Receiving Guidance**
   - Contextual prompts appear as users scroll through their feed or after adding entries.
   - Users can tap on prompts for more detailed information or suggestions.

2. **Exploring Insights**
   - Users can access the Insights Dashboard for a comprehensive view of their progress.
   - Insights are updated real-time as new entries are added or goals are modified.

3. **Community Benchmarks**
   - Users can opt-in to see how their habits compare to similar users or the community at large.
   - Personalized suggestions based on successful strategies from similar users.

## VII. Visual and Interaction Design

- **Theme and Background**:
  - Light, clean aesthetic with ample white space.
  - Option for dark mode with deep navy color (#0B1120) for high contrast.

- **Typography**:
  - Sans-serif font family for clean, modern look.
  - Hierarchical type scale for clear information structure.

- **Color Palette**:
  - Primary: Black (#000000) and White (#FFFFFF) for high contrast.
  - Accent: Bright Yellow (#FFD700) for highlights and calls-to-action.
  - Mint Green (#E6F3EF) for progress indicators and success states.

- **Iconography**:
  - Simple, line-based icons with 2px stroke width.
  - Consistent 24x24px size for standard icons.

- **Interaction Design**:
  - Smooth, subtle animations for transitions and feedback.
  - Haptic feedback for key actions on supported devices.

- **Accessibility**:
  - High contrast text and important UI elements.
  - Support for dynamic type and screen readers.
