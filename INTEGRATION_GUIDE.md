# Flutter Application - Backend Integration Guide

## Overview
This guide explains the integration between the Flutter application and the backend API for authentication and donation management.

## Backend API Configuration

The application is configured to communicate with a backend API running at:
```
http://127.0.0.1:3000
```

To change this URL, update the `baseUrl` constant in `flutter_application_1/lib/services/api_service.dart`:
```dart
static const String baseUrl = 'http://127.0.0.1:3000';
```

## Authentication Flow

### 1. User Registration
**Endpoint:** `POST /auth/register`

**Request Body:**
```json
{
  "nome": "User Name",
  "email": "user@example.com",
  "password": "password123",
  "telemovel": "999999999"
}
```

**Expected Response (201):**
```json
{
  "token": "jwt_token_string",
  "user": {
    "id": "user_id",
    "nome": "User Name",
    "email": "user@example.com",
    "telemovel": "999999999"
  }
}
```

**Implementation:**
- User fills registration form in `RegisterUserPage`
- On submit, calls `ApiService.registerUser()`
- Token and user data are stored in memory
- User is redirected to `UserHomePage`

### 2. User Login
**Endpoint:** `POST /auth/login`

**Request Body:**
```json
{
  "email": "user@example.com",
  "password": "password123"
}
```

**Expected Response (200):**
```json
{
  "token": "jwt_token_string",
  "user": {
    "id": "user_id",
    "nome": "User Name",
    "email": "user@example.com",
    "telemovel": "999999999"
  }
}
```

**Implementation:**
- User enters credentials in `LoginPage`
- On submit, calls `ApiService.loginUser()`
- Token and user data are stored in memory
- User is redirected to `UserHomePage`

## Donation Flow

### 1. Create Donation
**Endpoint:** `POST /donations`

**Headers:**
```
Authorization: Bearer {token}
Content-Type: application/json
```

**Request Body:**
```json
{
  "childId": "child_identifier",
  "dateTime": "2026-01-25T14:00:00.000Z"
}
```

**Expected Response (201):**
```json
{
  "id": "donation_id",
  "childId": "child_identifier",
  "dateTime": "2026-01-25T14:00:00.000Z",
  "status": "pendente",
  "userId": "user_id"
}
```

**Implementation:**
- User selects a child from `UserHomePage`
- Navigates to `ScheduleDonationPage`
- Selects date and time
- On confirmation, calls `ApiService.createDonation()`
- User is redirected to `DonationHistoryPage`

### 2. Get User Donations
**Endpoint:** `GET /donations`

**Headers:**
```
Authorization: Bearer {token}
Content-Type: application/json
```

**Expected Response (200):**
```json
[
  {
    "id": "donation_id",
    "childId": "child_name",
    "dateTime": "2026-01-25T14:00:00.000Z",
    "status": "pendente"
  }
]
```

**Supported Status Values:**
- `doacao` - Initial donation state
- `pendente` - Pending confirmation
- `confirmar` - Needs confirmation
- `sucesso` - Completed successfully

**Implementation:**
- `DonationHistoryPage` automatically loads donations on init
- Calls `ApiService.getDonations()`
- Displays donations sorted by date (newest first)
- Shows empty state if no donations exist

## State Management

### Authentication State
The application stores authentication state in memory using static variables in `ApiService`:

```dart
static String? _authToken;
static Map<String, dynamic>? _userData;

// Access via getters
static String? get authToken => _authToken;
static Map<String, dynamic>? get userData => _userData;
static bool get isAuthenticated => _authToken != null;
```

**Note:** This is a simple in-memory solution. For production, consider using:
- Flutter Secure Storage for token persistence
- State management solutions (Provider, Riverpod, Bloc)
- Secure token refresh mechanisms

### User Profile Data
User profile information is automatically populated from the stored `userData`:

```dart
String get _name => ApiService.userData?['nome'] ?? 'Utilizador';
String get _email => ApiService.userData?['email'] ?? 'email@exemplo.com';
String get _phone => ApiService.userData?['telemovel'] ?? '999999999';
```

## Error Handling

All API calls include try-catch blocks and return appropriate values on error:

- **Authentication failures:** Return `false`, show error message to user
- **Donation creation failures:** Return `null`, show error message
- **Network errors:** Caught and logged, empty results returned

Example error handling in UI:
```dart
if (success) {
  // Navigate to next page
} else {
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(content: Text('Error message')),
  );
}
```

## Testing the Integration

### Prerequisites
1. Backend API server running on `http://127.0.0.1:3000`
2. API endpoints implemented and responding correctly
3. Flutter development environment set up

### Test Flow

#### 1. Test Registration
1. Launch the app
2. Click "UTILIZADOR" on registration page
3. Fill in:
   - Nome: "Test User"
   - Email: "test@example.com"
   - Password: "password123"
   - Telefone: "999999999"
4. Click "REGISTAR"
5. Verify redirection to UserHomePage
6. Check backend logs for registration request

#### 2. Test Login
1. From UserTypeSelectionPage, click "Login"
2. Enter credentials:
   - Email: "test@example.com"
   - Password: "password123"
3. Click "LOGIN"
4. Verify redirection to UserHomePage
5. Check backend logs for login request

#### 3. Test User Profile
1. Navigate to UserHomePage
2. Click "Perfil" in bottom navigation
3. Verify user data is displayed:
   - Name from registration
   - Email from registration
   - Phone from registration

#### 4. Test Donation Creation
1. From UserHomePage, click on any child card
2. Click "DOAR" button
3. Select a date and time
4. Click "Confirmar Agendamento"
5. Confirm in dialog
6. Verify loading indicator appears
7. Verify redirection to DonationHistoryPage
8. Check backend logs for donation creation

#### 5. Test Donation History
1. Navigate to "Agenda" from bottom navigation
2. Verify previously created donation appears
3. Verify donation details (child name, date, time)
4. Verify status indicator shows correctly

## Known Limitations

1. **Token Persistence:** Tokens are stored in memory only and will be lost on app restart
2. **Child IDs:** Currently using child names as IDs (temporary solution)
3. **No Token Refresh:** No automatic token refresh mechanism
4. **Error Messages:** Generic error messages (not specific error codes)
5. **No Offline Support:** Requires active internet connection

## Future Enhancements

1. Implement secure token storage with Flutter Secure Storage
2. Add token refresh mechanism
3. Implement proper child ID management
4. Add more detailed error messages
5. Implement offline mode with local caching
6. Add loading states for all API calls
7. Implement proper logout functionality with API call
8. Add profile update API integration
9. Add donation cancellation API integration
10. Implement search and filter functionality for donations

## API Response Formats

### Success Responses
All successful responses should follow these formats for proper parsing.

### Error Responses
The application expects standard HTTP status codes:
- `200` - Success (GET, PUT, DELETE)
- `201` - Created (POST)
- `400` - Bad Request
- `401` - Unauthorized
- `404` - Not Found
- `500` - Internal Server Error

## Debugging

Enable detailed logging in `ApiService` by checking console output:
- Login errors: `Login error: {error}`
- Registration errors: `Register error: {error}`
- Donation creation errors: `Create donation error: {error}`
- Get donations errors: `Get donations error: {error}`
- Authentication checks: `User not authenticated`

## Support

For issues or questions about the integration:
1. Check backend API logs
2. Check Flutter console for error messages
3. Verify API endpoints are responding correctly
4. Ensure request/response formats match expectations
