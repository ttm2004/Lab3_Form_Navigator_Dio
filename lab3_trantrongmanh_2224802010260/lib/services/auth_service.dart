import 'package:dio/dio.dart';

class AuthService {
  static const String baseUrl = 'https://69dde456410caa3d47ba24cb.mockapi.io/api/users';

  static final Dio _dio = Dio(
    BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {
        'Content-Type': 'application/json',
      },
    ),
  );

  static Future<Map<String, dynamic>> login(
    String email,
    String password,
  ) async {
    try {
      final response = await _dio.get('');

      if (response.statusCode == 200) {
        final List users = response.data;

        for (final user in users) {
          if (user['email'] == email && user['password'] == password) {
            return {
              'success': true,
              'message': 'Đăng nhập thành công',
              'user': user,
            };
          }
        }

        return {
          'success': false,
          'message': 'Sai email hoặc mật khẩu',
        };
      }

      return {
        'success': false,
        'message': 'Không kết nối được API',
      };
    } on DioException catch (e) {
      return {
        'success': false,
        'message': 'Lỗi Dio: ${e.message}',
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Lỗi: $e',
      };
    }
  }

  static Future<Map<String, dynamic>> register(
    String username,
    String email,
    String password,
  ) async {
    try {
      final checkResponse = await _dio.get('');

      if (checkResponse.statusCode == 200) {
        final List users = checkResponse.data;

        final isEmailExists = users.any((user) => user['email'] == email);

        if (isEmailExists) {
          return {
            'success': false,
            'message': 'Email đã tồn tại',
          };
        }
      }

      final response = await _dio.post(
        '',
        data: {
          'username': username,
          'email': email,
          'password': password,
        },
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        return {
          'success': true,
          'message': 'Đăng ký thành công',
          'user': response.data,
        };
      }

      return {
        'success': false,
        'message': 'Đăng ký thất bại',
      };
    } on DioException catch (e) {
      return {
        'success': false,
        'message': 'Lỗi Dio: ${e.message}',
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Lỗi: $e',
      };
    }
  }
}