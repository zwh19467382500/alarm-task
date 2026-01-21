import 'package:dio/dio.dart';
import 'package:simple_alarm/service/auth/storage_service.dart';

class ApiService {
  final Dio _dio;
  final StorageService _storageService;

  // Backend URL - Replace with your actual backend URL in production
  static const String _baseUrl = 'http://127.0.0.1:8000/api';

  ApiService(this._storageService) : _dio = Dio(BaseOptions(baseUrl: _baseUrl)) {
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        // Add the token to the header if it exists
        final token = await _storageService.getToken();
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
      onError: (DioException e, handler) {
        // Handle errors globally if needed
        print('API Error: ${e.response?.statusCode} - ${e.response?.data}');
        return handler.next(e);
      },
    ));
  }

  Future<String> login(String username, String password) async {
    // --- MOCK IMPLEMENTATION FOR VALIDATION ---
    print('--- USING MOCKED LOGIN ---');
    await Future.delayed(const Duration(seconds: 1)); // Simulate network delay
    if (username.isEmpty || password.isEmpty) {
      throw 'Username or password cannot be empty';
    }
    // Return a fake, but correctly formatted, JWT.
    const fakeToken = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJ0ZXN0dXNlciIsIm5hbWUiOiJUZXN0IFVzZXIiLCJpYXQiOjE1MTYyMzkwMjJ9.SflKxwRJSMeKKF2QT4fwpMeJf36POk6yJV_adQssw5c';
    await _storageService.saveToken(fakeToken);
    return fakeToken;
    // --- END MOCK --- 

    /* --- REAL IMPLEMENTATION ---
    try {
      final response = await _dio.post(
        '/auth/login',
        data: {'username': username, 'password': password},
        options: Options(contentType: Headers.formUrlEncodedContentType),
      );
      if (response.statusCode == 200 && response.data['access_token'] != null) {
        final token = response.data['access_token'];
        await _storageService.saveToken(token);
        return token;
      } else {
        throw 'Login failed: Invalid response from server';
      }
    } on DioError catch (e) {
      throw e.response?.data['detail'] ?? 'An unknown error occurred';
    }
    */
  }

  Future<void> register(String username, String password) async {
    // --- MOCK IMPLEMENTATION FOR VALIDATION ---
    print('--- USING MOCKED REGISTER ---');
    await Future.delayed(const Duration(seconds: 1)); // Simulate network delay
    if (username.isEmpty || password.isEmpty) {
      throw 'Username or password cannot be empty';
    }
    return;
    // --- END MOCK ---

    /* --- REAL IMPLEMENTATION ---
    try {
      await _dio.post(
        '/auth/register',
        data: {'username': username, 'password': password},
      );
    } on DioError catch (e) {
      throw e.response?.data['detail'] ?? 'An unknown error occurred';
    }
    */
  }

  // This will be implemented in the next phase
  Future<void> bindDevice(String registrationId) async {
    try {
      await _dio.post('/push/bind', data: {'registration_id': registrationId});
    } on DioException catch (e) {
      throw e.response?.data['detail'] ?? 'An unknown error occurred';
    }
  }
}
