**I. Introduction**

Focusing exclusively on Phase 1, our mission is to craft a beautifully designed and reliable core experience for the personal coach app. We'll build upon this foundation by integrating user feedback and data-driven improvements over time. Central to this effort is a minimalistic yet visually stunning dashboard, supplemented by seamless food capture, intuitive onboarding, and thoughtful guidance through ephemeral prompts (floating thoughts).

This document outlines the detailed definitions and designs for:

- Dashboard
- Food Capture Interface
- Onboarding
- Guidance and Insights

Additionally, we provide an elaborate description of the design language to guide our UI developers in creating a cohesive and engaging user interface.

---

**II. Dashboard**

*The heart of the app—a minimalistic, visually engaging dashboard that provides users with immediate insight into their nutritional intake and progress toward their goals.*

**A. Purpose and Functionality**

- **Immediate Clarity**: Present critical information at a glance—current calorie and nutrient consumption vs. daily targets.
- **Motivational Visuals**: Use engaging visuals to motivate users without overwhelming them.
- **Seamless Interaction**: Provide effortless transitions between viewing progress and capturing new food entries.

**B. Design Elements**

1. **Layout and Structure**

   - **Full-Screen Card Design**: The dashboard is a full-screen card that utilizes the entire display, creating an immersive experience.
   - **Vertical Scrolling**: While the primary dashboard fits on one screen, users can scroll vertically to view recent history or additional details.

2. **Greeting Section**

   - **Prominent Greeting**:
     - **Text**: A large, bold, center-aligned greeting such as "Good Morning" or "Hello, [User's Name]" at the top of the screen.
     - **Font**: Uses a bold, large sans-serif font for readability at a glance.
   - **Secondary Details**:
     - **Date and Summary**: Below the greeting, display the current date and a concise summary like "1,200 kcal consumed, 800 kcal remaining."
     - **Muted Text Style**: Use smaller, less contrasting fonts for secondary information to create a visual hierarchy.

3. **Nutrition Meter**

   - **Circular Progress Ring**:
     - **Central Element**: A large, circular ring representing overall calorie intake against the daily goal.
     - **Dynamic Filling**: The ring fills proportionally as the user logs food, with subtle color changes to indicate progress (e.g., from light blue to deep navy).
     - **Inner Nutrient Rings**: Additional concentric rings represent key nutrients like proteins, carbs, and fats.

   - **Data Display**:
     - **Calorie Count**: Center of the circle displays total calories consumed in large, bold text.
     - **Nutrient Breakdown**: Below the calorie count, display grams of proteins, carbs, and fats in smaller, muted text.

4. **Recent History**

   - **Scrollable Section**:
     - **Layout**: Vertically scrollable list of recent meals below the nutrition meter.
     - **Card Design**: Each meal is represented by a rounded rectangular card with a pastel background color.
     - **Content**:
       - **Meal Title**: Large, bold text indicating the meal (e.g., "Breakfast").
       - **Subtext**: Smaller font for time and calorie content (e.g., "8:00 AM • 350 kcal").
       - **Icons/Images**: Minimalist icons or small images representing the meal.

5. **Capture Call-to-Action (CTA)**

   - **Prominent Button**:
     - **Design**: A large, pill-shaped button labeled "Add Meal" at the bottom of the screen.
     - **Color Coding**: Uses a light blue color to stand out against the background.
     - **Iconography**: Includes a simple '+' icon within the button for quick recognition.

**C. User Flow**

1. **Upon Opening the App**

   - **Immediate Engagement**: Users see the greeting and current progress without any loading screens.
   - **Visual Update**: The nutrition meter and recent history reflect the latest data.

2. **Interacting with the Dashboard**

   - **Viewing Details**: Tapping on the nutrition meter brings up detailed statistics in an overlay card.
   - **Scrolling Through History**: Users can scroll vertically to review or edit recent meals.
   - **Adding a Meal**: Tapping the "Add Meal" button transitions to the food capture interface.

**D. Visual and Interaction Design**

- **Theme and Background**:
  - **Primary Background**: Utilize a pastel white/gray theme as the base, with the option for a dark theme featuring a deep navy color (#0B1120) for high contrast.

- **Typography**:
  - **Primary Font**: Bold, large sans-serif font for headings and main titles.
  - **Secondary Font**: Smaller, regular weight sans-serif font for subtexts.
  - **Text Alignment**: Center-aligned for greetings and main headings; left-aligned for detailed information.

- **Color Palette**:
  - **Primary Colors**: Black, white, and shades of gray.
  - **Accent Colors**: Orange (#ED764A) for primary actions, mint green for progress indicators.

- **Progress Indicator**:
  - Thin line (2px) chart with dots for data points.
  - Use mint green for the line, black for data points.

- **Task List**:
  - Left-aligned text with ample spacing between items (24px).
  - Circular checkboxes (24x24px) aligned to the right.

- **Profile Section**:
  - Circular avatar (48x48px) in the top-left corner.
  - User name right-aligned in the top-right corner.

- **Navigation**:
  - Bottom tab bar with simple icons and labels.
  - Active state indicated by filled icons or underline.

---

**III. Food Capture Interface**

*An intuitive interface that allows users to effortlessly log their meals through minimal steps, integrating seamlessly with the dashboard.*

**A. Purpose and Functionality**

- **Effortless Logging**: Minimize friction in logging food entries to encourage consistent use.
- **Intelligent Recognition**: Leverage AI for image recognition and learning from user habits.

**B. Design Elements**

1. **Capture Methods**

   - **Photo Capture**:
     - **Full-Screen Camera Interface**: Activated upon tapping "Add Meal," with minimal on-screen elements.
     - **Overlay Instructions**: Muted text prompts like "Snap a photo of your meal" appear at the center.
     - **Capture Button**: A circular, pastel-colored button at the bottom center with a camera icon.

   - **Text Input**:
     - **Switch Option**: A small, flat icon (e.g., a keyboard symbol) allows users to switch to text input.
     - **Input Field**: A clean, full-screen card with a large text field for typing or dictating meal details.

2. **Confirmation Screen**

   - **Layout**:

     - **Full-Screen Card**: A rounded rectangular card pops up, summarizing the detected food items.
     - **Background Color**: Uses a light pastel color to differentiate from the main dashboard.

   - **Content**:

     - **Meal Title**: Editable field with the meal name in large, bold text.
     - **Detected Items**: List of food items with icons or images, each in its own card section.
     - **Nutritional Information**: Calories and key nutrients displayed in smaller, muted text below each item.

   - **Actions**:

     - **Edit Options**: Users can tap on any item to adjust quantities or make corrections.
     - **Add to Favorites**: A small star icon allows users to save the meal for quick future logging.
     - **Save Meal**: A prominent "Save Meal" button at the bottom in a light blue color.

**C. User Flow**

1. **Initiating Capture**

   - **From Dashboard**: User taps the "Add Meal" button.
   - **Default Method**: The app opens the camera interface by default, with the option to switch to text input.

2. **Capturing and Confirming**

   - **Real-Time Processing**: The app begins analyzing the image as soon as it's captured.
   - **Review and Edit**: The confirmation screen allows users to review and adjust detected items.

3. **Completion**

   - **Saving the Meal**: Tapping "Save Meal" logs the entry and returns the user to the dashboard.
   - **Immediate Feedback**: The nutrition meter updates to reflect the new data.

**D. Visual and Interaction Design**

- **Iconography**:

  - **Minimal and Flat Icons**: Use simple, flat icons for camera, keyboard, and food items.
  - **Circular Backgrounds**: Icons are placed inside circular backgrounds for clarity.

- **Buttons**:

  - **Design**: Filled buttons with round edges, following Material Design principles.
  - **Color Coding**: Light blue for primary actions like "Save Meal."

- **Animations and Transitions**:

  - **Smooth Transitions**: Gentle animations when moving between screens enhance the user experience.
  - **Feedback**: Subtle vibrations or color changes provide immediate feedback on interactions.

---

**IV. Onboarding**

*An intuitive onboarding process that quickly sets up the user with minimal effort, ensuring they can start using the app effectively from the outset.*

**A. Purpose and Functionality**

- **Immediate Value**: Guide users to the core functionality swiftly.
- **Personalization**: Collect essential information to tailor the app experience.

**B. Design Elements**

1. **Welcome Screen**

   - **Greeting Message**:

     - **Text**: Large, bold, center-aligned message like "Welcome to [App Name]".
     - **Subtext**: Smaller font with a brief description of the app's purpose.

   - **Visuals**:

     - **Minimalistic Graphics**: Simple illustrations or icons that align with the app's aesthetic.

2. **Goal Setting**

   - **Full-Screen Cards**:

     - **Layout**: Each onboarding step is presented on a separate full-screen card with a pastel background.

   - **Content**:

     - **Daily Calorie Goal**:

       - **Input Method**: Large, easy-to-use slider or input field.
       - **Visual Feedback**: As the user adjusts the goal, an on-screen icon or meter reflects the change.

     - **Nutrient Targets**:

       - **Selection Options**: Toggle buttons or sliders for proteins, carbs, and fats.
       - **Defaults and Customization**: Provide default values with the option to customize.

3. **Preferences**

   - **Dietary Restrictions**:

     - **Icons with Labels**: Options like vegetarian, vegan, gluten-free, represented with simple icons and text.

   - **Units of Measurement**:

     - **Buttons**: Choice between imperial and metric units using clear labels.

   - **Notification Settings**:

     - **Toggle Switches**: Enable or disable different types of notifications.

4. **Finalization**

   - **Summary Screen**:

     - **Content**: Recap of the user's selections in a clean, readable format.
     - **Edit Option**: An "Edit" button allows users to make changes before proceeding.

   - **Start Button**:

     - **Design**: A prominent, pill-shaped "Get Started" button in light blue.

**C. User Flow**

1. **Starting Onboarding**

   - **Account Setup**: Option to sign up or continue as a guest, with assurances about data privacy.

2. **Setting Up**

   - **Sequential Progression**: Users swipe left or tap "Next" to move through each onboarding card.
   - **Progress Indicators**: Small dots or a progress bar at the bottom indicate the number of steps.

3. **Completion**

   - **Welcome Message**: A final greeting like "You're all set, [User's Name]!" before entering the dashboard.

**D. Visual and Interaction Design**

- **Consistency**:

  - **Color Palette**: Use the same pastel colors and design elements as the main app.

- **Typography**:

  - **Primary Font**: Large, bold sans-serif for headings.
  - **Secondary Font**: Smaller, regular weight for instructions and options.

- **Icons and Graphics**:

  - **Minimalist Icons**: Enhance comprehension without clutter.

---

**V. Guidance and Insights**

*Providing users with meaningful feedback through subtle, contextually relevant prompts and insights to support their goals without causing distractions.*

**A. Purpose and Functionality**

- **Supportive Nudges**: Offer guidance as gentle reminders rather than intrusive notifications.
- **Contextual Relevance**: Ensure prompts are timely and based on user habits and progress.

**B. Design Elements**

1. **Floating Thoughts**

   - **Ephemeral Prompts**:

     - **Appearance**: Small, rounded rectangular cards that appear temporarily on the dashboard.
     - **Content**: Short messages like "Great job yesterday!" or "Don't forget to log your lunch."

   - **Design**:

     - **Background Color**: Use pastel colors that stand out subtly against the main background.
     - **Text Style**: Smaller, friendly font that matches the app's typography.

2. **Insights**

   - **Daily Summary**:

     - **Access**: Swiping up from the bottom reveals a full-screen card with insights.
     - **Content**:

       - **Statistics**: Display total calories, nutrient breakdowns, and progress towards goals.
       - **Visuals**: Simple charts or bars with flat design elements.

   - **Encouraging Messages**:

     - **Placement**: Below the statistics, include messages like "You're on track!" or "Consider more protein for muscle gain."

**C. User Flow**

1. **Receiving Prompts**

   - **Timing**: Prompts appear after certain actions or at relevant times (e.g., near usual meal times).
   - **Interactivity**: Tapping a prompt can provide more details or dismiss it.

2. **Interacting with Insights**

   - **Accessing**: Users can swipe up from the dashboard or tap an icon to view insights.
   - **Navigating**: Vertical scrolling within the insights card allows users to see more data.

