import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import '../../models/user_type.dart';
import '../admin/admin_bottom_nav.dart';
import '../user/user_bottom_nav.dart';
import 'signup_screen.dart';
import '../../services/auth_service.dart';
import '../../models/user_login_dto.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  UserType _selectedUserType = UserType.user;

  final Color yeditepeBlue = const Color(0xFF0056A1);
  bool _isLoading = false;
  String? _error;

  Future<void> _handleLogin() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    final success = await AuthService.login(
      UserLoginDto(
        username: _usernameController.text.trim(),
        password: _passwordController.text.trim(),
      ),
    );

    if (success) {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('jwt');

      if (token == null) {
        setState(() => _error = 'Token alınamadı.');
        _isLoading = false;
        return;
      }

      Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
      print("🔍 JWT Token İçeriği:\n$decodedToken");

      String? role =
          decodedToken['http://schemas.microsoft.com/ws/2008/06/identity/claims/role'];
      String? username = decodedToken['sub'];
      String? fullName = decodedToken['FullName'];
      String? phoneNumber = decodedToken['PhoneNumber'];
      String? userId = decodedToken['sub']; // ✅ sub olarak çekiyoruz

      if (role == null || username == null || userId == null) {
        setState(() {
          _error = 'Token eksik bilgi içeriyor.';
          _isLoading = false;
        });
        return;
      }

      await prefs.setString('username', username);
      await prefs.setString('fullName', fullName ?? '');
      await prefs.setString('role', role);
      await prefs.setString('PhoneNumber', phoneNumber ?? '');
      await prefs.setString(
        'userId',
        userId,
      ); // ✅ SharedPreferences’a doğru userId

      if ((_selectedUserType == UserType.user && role == 'user') ||
          (_selectedUserType == UserType.admin && role == 'admin')) {
        if (role == 'user') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const UserBottomNav()),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const AdminBottomNav()),
          );
        }
      } else {
        setState(() {
          _error =
              'Rol uyuşmazlığı. Doğru kullanıcı türünü seçtiğinizden emin olun.';
        });
      }
    } else {
      setState(() {
        _error = 'Giriş başarısız. Lütfen bilgilerinizi kontrol edin.';
      });
    }

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              "assets/images/background6.png",
              fit: BoxFit.cover,
              alignment: Alignment.center,
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Radio<UserType>(
                        value: UserType.user,
                        groupValue: _selectedUserType,
                        onChanged: (value) {
                          setState(() => _selectedUserType = value!);
                        },
                        activeColor: yeditepeBlue,
                      ),
                      Text("User", style: TextStyle(color: yeditepeBlue)),
                      const SizedBox(width: 16),
                      Radio<UserType>(
                        value: UserType.admin,
                        groupValue: _selectedUserType,
                        onChanged: (value) {
                          setState(() => _selectedUserType = value!);
                        },
                        activeColor: yeditepeBlue,
                      ),
                      Text("Admin", style: TextStyle(color: yeditepeBlue)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _usernameController,
                    keyboardType:
                        _selectedUserType == UserType.user
                            ? TextInputType.number
                            : TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText:
                          _selectedUserType == UserType.user
                              ? "School Number"
                              : "Email",
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.9),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: "Password",
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.9),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  if (_error != null) ...[
                    const SizedBox(height: 12),
                    Text(_error!, style: const TextStyle(color: Colors.red)),
                  ],
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _handleLogin,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: yeditepeBlue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child:
                          _isLoading
                              ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                              : const Text(
                                "Log In",
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                ),
                              ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextButton(
                    style: TextButton.styleFrom(foregroundColor: yeditepeBlue),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (_) => SignUpScreen(userType: _selectedUserType),
                        ),
                      );
                    },
                    child: const Text(
                      "Don't have an account? Sign Up",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
