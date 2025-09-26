# Rating System Implementation

## Overview
The rating system has been integrated into the app to collect user feedback after they use exactly one feature in a session.

## How it Works

### 1. Feature Usage Tracking
- When a user taps on any feature from the homepage or "All Features" screen, the app tracks this usage
- The system stores which features were used in the current session

### 2. Rating Prompt Trigger
The rating dialog appears when ALL of these conditions are met:
- User has used exactly **one feature** in the current session
- User has not already rated the app
- At least 24 hours have passed since the last rating prompt (to avoid spam)

### 3. Rating Flow
1. User taps a feature → navigates to feature screen
2. User returns to home → system checks if rating prompt should show
3. If conditions are met → "Rate Us" dialog appears
4. User can choose "Maybe Later" or "Rate Now"
5. If "Rate Now" → navigates to beautiful rating screen with animated face
6. User submits rating → marked as rated, won't be prompted again

### 4. Files Modified/Created

#### New Files:
- `lib/screens/rating_screen.dart` - The beautiful animated rating screen
- `lib/services/rating_service.dart` - Service to track usage and manage rating logic
- `RATING_SYSTEM_README.md` - This documentation

#### Modified Files:
- `lib/main.dart` - Added rating screen route
- `lib/screens/home_screen.dart` - Added feature tracking and rating dialog
- `lib/screens/auth_wrapper.dart` - Clear session data on login

### 5. Rating Screen Features
- **Animated Background**: Changes color based on rating (red → amber → green)
- **Dynamic Face**: Eyes close at middle rating, mouth curves based on rating
- **Smooth Slider**: 0-2 scale with "Bad", "Not Bad", "Good" labels
- **Beautiful UI**: Material Design 3 with smooth animations

### 6. Data Storage
Uses SharedPreferences to store:
- Feature usage count (persistent across sessions)
- Whether user has rated (persistent)
- Last rating prompt time (prevents spam)
- Current session features (cleared on app restart/login)

### 7. Testing the System
1. **First Time**: Use exactly one feature → should see rating prompt
2. **Already Rated**: Use features → no prompt (user marked as rated)
3. **Multiple Features**: Use more than one feature → no prompt
4. **Reset for Testing**: Call `RatingService.resetRatingData()` to reset all rating data

## Technical Details

### Rating Logic
```dart
// Check if should show rating prompt
final shouldShow = await RatingService.shouldShowRatingPrompt();

// Conditions:
// 1. User hasn't rated yet
// 2. Used exactly 1 feature this session  
// 3. Haven't prompted in last 24 hours
```

### Face Animation
The rating screen uses a custom painter that:
- Interpolates eye size and position based on rating
- Changes mouth curvature (smile/frown) based on rating
- Provides smooth animations with easing curves

### Session Management
- Session data is cleared when user logs in
- Feature usage persists across app restarts
- Rating status persists until manually reset
