import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  // Thay link này bằng endpoint users thật của bạn
  static const String baseUrl = 'https://YOUR_MOCKAPI_LINK/users';

  static Future<Map<String, dynamic>> login(
    String email,
    String password,
  ) async {
    try {
      final response = await http.get(Uri.parse(baseUrl));

      if (response.statusCode == 200) {
        final List<dynamic> users = jsonDecode(response.body);

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
      final checkResponse = await http.get(Uri.parse(baseUrl));

      if (checkResponse.statusCode == 200) {
        final List<dynamic> users = jsonDecode(checkResponse.body);

        final isEmailExists = users.any((user) => user['email'] == email);

        if (isEmailExists) {
          return {
            'success': false,
            'message': 'Email đã tồn tại',
          };
        }
      }

      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': username,
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        return {
          'success': true,
          'message': 'Đăng ký thành công',
          'user': jsonDecode(response.body),
        };
      }

      return {
        'success': false,
        'message': 'Đăng ký thất bại',
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Lỗi: $e',
      };
    }
  }
}