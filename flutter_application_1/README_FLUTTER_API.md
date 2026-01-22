# Flutter API Integration Guide

## Base URL Configuration

The Flutter app communicates with the backend API using a base URL that needs to be adjusted based on your platform:

### Platform-specific URLs:

- **Android Emulator**: `http://10.0.2.2:3000`
  - The Android emulator uses `10.0.2.2` to access the host machine's localhost
  
- **iOS Simulator**: `http://localhost:3000`
  - iOS Simulator can directly access `localhost`

- **Physical Device**: `http://<YOUR_IP_ADDRESS>:3000`
  - Replace `<YOUR_IP_ADDRESS>` with your computer's IP address on the local network
  - Find your IP with:
    - macOS/Linux: `ifconfig` or `ip addr`
    - Windows: `ipconfig`

### Changing the Base URL

Edit the `baseUrl` constant in `lib/services/api_service.dart`:

```dart
static const String baseUrl = 'http://10.0.2.2:3000'; // Android Emulator
// static const String baseUrl = 'http://localhost:3000'; // iOS Simulator
// static const String baseUrl = 'http://192.168.1.100:3000'; // Physical Device
```

## Setup Instructions

### 1. Install Dependencies

After updating `pubspec.yaml`, run:

```bash
flutter pub get
```

This will install the new dependencies, including `shared_preferences` for storing JWT tokens.

### 2. Backend Server

Make sure your backend server is running on port 3000:

```bash
cd backend
npm install
npm start
```

### 3. Run the Flutter App

```bash
cd flutter_application_1
flutter run
```

## Testing Registration and Login Flows

### User Registration Flow

1. Launch the app
2. Select "UTILIZADOR" on the user type selection page
3. Fill in the registration form:
   - Nome (Name)
   - Email
   - Password
   - Telefone (Phone)
4. Tap "REGISTAR" (Register)
5. Upon successful registration, the app will:
   - Store the JWT token in SharedPreferences
   - Automatically navigate to UserHomePage

### Institution Registration Flow

1. Launch the app
2. Select "INSTITUIÇÃO" on the user type selection page
3. Fill in the institution registration form:
   - Nome (Institution Name)
   - Email
   - Password
   - Morada (Address)
   - NIF (Tax ID)
4. Tap "REGISTAR" (Register)
5. Upon successful registration, navigate to the verification page
6. Enter the validation code sent to the email
7. Tap "VALIDAR" (Validate)
8. Upon successful validation, the app will:
   - Automatically log in
   - Store the JWT token
   - Navigate to AdminHomePage

### Login Flow

1. From the user type selection page, tap "Já tenho conta" (I already have an account)
2. Enter email and password
3. Tap "ENTRAR" (Login)
4. Upon successful login:
   - JWT token is stored
   - Navigate to appropriate home page (User or Admin)

### Donation Scheduling Flow

1. Log in as a user
2. Navigate to schedule donation page
3. Select a child, date, and time
4. Confirm the donation
5. The app will:
   - Retrieve JWT token from storage
   - POST to `/donations` endpoint with Authorization header
   - Show success/error message via SnackBar

## Authentication Storage

The app uses `SharedPreferences` to store:
- `jwt_token`: JWT authentication token
- `user_data`: JSON-encoded user information

These are automatically managed by the `ApiService` class through:
- `registerUser()` - Registers and stores token
- `loginUser()` - Logs in and stores token
- `getToken()` - Retrieves stored token
- `logout()` - Clears stored data

## API Endpoints Used

- `POST /auth/register` - User registration
- `POST /auth/register/admin` - Institution registration
- `POST /auth/validate-admin` - Admin validation with code
- `POST /auth/login` - User/Admin login
- `POST /donations` - Create donation (requires JWT)

## Troubleshooting

### "Connection refused" error

- Verify backend server is running
- Check that baseUrl matches your platform (see above)
- For physical device, ensure both device and computer are on same network

### "Token not found" error

- User needs to log in again
- Clear app data and re-register/login

### Validation code not working

- Check email for the validation code
- Ensure backend email service is configured correctly
- Code may expire after a certain time
