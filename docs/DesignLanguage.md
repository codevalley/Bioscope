**Visual and Interaction Design**

- **Animations**:

  - **Subtle Movements**: Floating thoughts gently fade in and out.
  - **Smooth Transitions**: Swiping into the insights card is fluid and responsive.

- **Accessibility**:

  - **High Contrast Text**: Ensures readability against varying backgrounds.
  - **Large Touch Targets**: Buttons and interactive elements are sized for easy tapping.

---

# Updated Design Language for Bioscope App

## General Style

- **Theme**: Minimalist and clean with high contrast color schemes
- **Color Scheme**:
  - Light mint green (#E6F3EF) for background
  - Bright yellow (#FFD700) for accent and highlight areas
  - Black (#000000) for text and icons
  - White (#FFFFFF) for contrast elements

## Layout

- **Full-Screen Cards**: Each screen is a full-screen card with rounded corners
- **Margins**: Consistent 20px margin around the edge of the screen
- **Spacing**: Generous white space between elements (24px-32px)

## Typography

- **Font Family**: San Francisco or a similar sans-serif font
- **Text Sizes**:
  - Large Headers: 32px, bold
  - Section Headers: 24px, medium weight
  - Body Text: 16px, regular weight
  - Small Text/Labels: 14px, regular weight
- **Text Alignment**: Left-aligned for most content, center-aligned for main headers or CTAs

## Color Usage

- **Background Colors**:
  - Primary: Light mint green (#E6F3EF)
  - Secondary: Bright yellow (#FFD700)
- **Text Colors**:
  - Primary: Black (#000000)
  - Secondary: Dark gray (#333333) for less emphasis
- **Accent Colors**:
  - CTA buttons: Black (#000000) with white text
  - Highlights: Bright yellow (#FFD700)

## Interactive Elements

- **Buttons**:
  - Shape: Rounded rectangles with 8px border radius
  - Color: Black background with white text for primary actions
  - Size: 48px height for easy tapping
- **Input Fields**:
  - Underlined text inputs with no visible box
  - Black underline on light background
- **Toggles/Checkboxes**:
  - Custom designed with brand colors (black/yellow)

## Iconography

- **Style**: Simple, line-based icons with 2px stroke width
- **Size**: 24x24px for standard icons, 32x32px for more prominent ones
- **Color**: Black (#000000) on light backgrounds, White (#FFFFFF) on dark backgrounds

## Cards and Containers

- **Shape**: Rounded corners with 16px radius
- **Shadows**: Subtle shadows for depth (2px blur, 1px y-offset, 10% opacity)
- **Borders**: None or very light (1px) when necessary

## Charts and Data Visualization

- **Style**: Minimalist with thin lines (1px)
- **Colors**: Use the primary color palette (mint green, yellow, black)
- **Labels**: Small, subtle text labels (14px)

## Images and Avatars

- **Style**: Circular for profile pictures
- **Border**: None or very subtle (1px black)

## Animations and Transitions

- **Style**: Swift and subtle
- **Duration**: Quick transitions (200-300ms)
- **Easing**: Ease-out for natural feel

## Accessibility

- **Contrast**: Ensure high contrast between text and backgrounds
- **Touch Targets**: Minimum size of 44x44px for all interactive elements
- **Text Size**: Support dynamic type for scalable text

## Specific Components

### Progress Indicator

- Thin line (2px) chart with dots for data points
- Use mint green for the line, black for data points

### Task List

- Left-aligned text with ample spacing between items (24px)
- Circular checkboxes (24x24px) aligned to the right

### Profile Section

- Circular avatar (48x48px) in the top-left corner
- User name right-aligned in the top-right corner

### Navigation

- Bottom tab bar with simple icons and labels
- Active state indicated by filled icons or underline

## Suggestions

1. Consider adding a consistent style for dividers across the app. Currently, we're using a gradient-like effect for section dividers in the GreetingSection and RecentHistory widgets. We should document this style and potentially create a reusable widget for it.

2. The color scheme for the NutritionMeter when exceeding the calorie limit (currently red) should be added to the official color palette in this document.

3. The new Instagram-like layout provides a more familiar and engaging user experience.

4. Consider adding animations to smooth transitions between screens and when loading new data.

5. Explore the possibility of adding quick actions (like delete or edit) to food history items.

This updated design language aligns closely with the minimalist, high-contrast style shown in the screenshot while maintaining the core structure of the original design document.
