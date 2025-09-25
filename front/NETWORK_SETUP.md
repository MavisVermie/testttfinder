# Network Setup for Price Advisor

## The Issue
Flutter apps running on mobile devices/emulators can't connect to `localhost:3000` because localhost refers to the device itself, not your computer.

## Solutions

### 1. For Android Emulator
✅ **Already configured** - Uses `10.0.2.2:3000` which maps to your computer's localhost.

### 2. For iOS Simulator
- Change `ApiConfig.baseUrl` to use `_iosSimulatorUrl` (localhost:3000)
- Or keep the current Android emulator URL

### 3. For Physical Device
1. Find your computer's IP address:
   - **Windows**: Run `ipconfig` in Command Prompt
   - **Mac/Linux**: Run `ifconfig` in Terminal
   - Look for your local network IP (usually starts with 192.168.x.x or 10.x.x.x)

2. Update `ApiConfig._physicalDeviceUrl` with your actual IP:
   ```dart
   static const String _physicalDeviceUrl = 'http://YOUR_IP_HERE:3000';
   ```

3. Change the `baseUrl` getter to return `_physicalDeviceUrl`

### 4. For Web
- Use `localhost:3000` (already configured)

## Testing
1. Make sure your backend is running: `cd back && npm start`
2. Test the connection by visiting `http://YOUR_IP:3000` in your browser
3. Run the Flutter app and try the Price Advisor feature

## Current Configuration
- **Android Emulator**: `http://10.0.2.2:3000` ✅
- **iOS Simulator**: `http://localhost:3000` (needs change if using physical device)
- **Physical Device**: `http://192.168.1.100:3000` (needs your actual IP)
- **Web**: `http://localhost:3000` ✅
