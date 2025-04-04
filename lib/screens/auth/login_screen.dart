import 'package:flutter/material.dart';
import '../../models/user_type.dart';
import '../user/user_bottom_nav.dart';
import '../admin/admin_bottom_nav.dart';
import 'signup_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailOrNumberController =
      TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  UserType _selectedUserType = UserType.user;

  final Color yeditepeBlue = const Color(0xFF0056A1);

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
                          setState(() {
                            _selectedUserType = value!;
                          });
                        },
                        activeColor: yeditepeBlue,
                      ),
                      Text("User", style: TextStyle(color: yeditepeBlue)),
                      const SizedBox(width: 16),
                      Radio<UserType>(
                        value: UserType.admin,
                        groupValue: _selectedUserType,
                        onChanged: (value) {
                          setState(() {
                            _selectedUserType = value!;
                          });
                        },
                        activeColor: yeditepeBlue,
                      ),
                      Text("Admin", style: TextStyle(color: yeditepeBlue)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _emailOrNumberController,
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
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_emailOrNumberController.text.isNotEmpty &&
                            _passwordController.text.isNotEmpty) {
                          if (_selectedUserType == UserType.user) {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const UserBottomNav(),
                              ),
                            );
                          } else {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const AdminBottomNav(),
                              ),
                            );
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: yeditepeBlue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        "Log In",
                        style: TextStyle(fontSize: 18, color: Colors.white),
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
