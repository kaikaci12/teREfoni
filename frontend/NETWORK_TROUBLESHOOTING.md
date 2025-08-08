# Network Connection Troubleshooting Guide

## The Error You're Seeing
```
Exception: Network error: The connection errored: The XMLHttpRequest onError callback was called. This typically indicates an error on the network layer.
```

This error typically occurs due to one of these issues:

## 🔍 Step-by-Step Troubleshooting

### 1. **Check if Backend Server is Running**
First, make sure your backend server is running:

```bash
cd backend
npm start
# or
node server.js
```

You should see: `Server is running on PORT 3000`

### 2. **Test Server Connectivity**
Add the `ConnectionTestWidget` to any screen in your app to test connectivity:

```dart
import 'package:frontend/utils/http/connection_test.dart';

// Add this widget to any screen
const ConnectionTestWidget(),
```

### 3. **Check CORS Configuration**
The backend has been updated to accept requests from multiple Flutter web development ports. Make sure your backend is running the updated code.

### 4. **Verify Port Configuration**
- **Web**: Uses `http://localhost:3000`
- **Mobile**: Uses `http://10.0.2.2:3000` (Android emulator)

### 5. **Common Issues and Solutions**

#### Issue: Backend Server Not Running
**Solution**: Start the backend server
```bash
cd backend
npm install  # if not done already
npm start
```

#### Issue: CORS Error (Web Only)
**Solution**: The backend CORS configuration has been updated to handle multiple origins. Restart your backend server.

#### Issue: Wrong Port for Flutter Web
**Solution**: Check what port your Flutter web app is running on. The backend now accepts:
- `http://localhost:5173` (Vite default)
- `http://localhost:8080` (Flutter web default)
- `http://localhost:58895-58899` (Flutter web dev server)

#### Issue: Network Unreachable
**Solution**: 
1. Check if you can access `http://localhost:3000` in your browser
2. Try `curl http://localhost:3000/api/auth/test` in terminal
3. Check firewall settings

### 6. **Debug Information**
The updated Dio configuration now provides detailed logging. Check your browser console or Flutter debug console for:
- Request URLs being made
- Error types and messages
- Response status codes

### 7. **Quick Test**
You can test the connection directly in your browser:
1. Open `http://localhost:3000/api/auth/test`
2. You should see: `{"message":"Server is running and accessible!"}`

### 8. **Environment Variables**
If you're using a different frontend URL, set the environment variable:
```bash
# In backend/.env
FRONTEND_URL=http://your-frontend-url
```

## 🚀 Next Steps

1. **Start the backend server** if it's not running
2. **Add the ConnectionTestWidget** to test connectivity
3. **Check the console logs** for detailed error information
4. **Verify the server is accessible** in your browser

## 📞 Still Having Issues?

If the problem persists:
1. Check the browser's Network tab for failed requests
2. Look at the backend server console for CORS errors
3. Verify both frontend and backend are running on the expected ports
4. Try accessing the API endpoints directly in your browser 