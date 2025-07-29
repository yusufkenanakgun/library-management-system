import 'package:flutter/material.dart';
import '../../models/user_type.dart';
import '../../models/user_register_dto.dart';
import '../../services/auth_service.dart';
import 'login_screen.dart';

class SignUpScreen extends StatefulWidget {
  final UserType userType;

  const SignUpScreen({super.key, required this.userType});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  final Color yeditepeBlue = const Color(0xFF0056A1);
  bool _isLoading = false;
  String? _error;

  Future<void> _register() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    final dto = UserRegisterDto(
      username: _usernameController.text.trim(),
      password: _passwordController.text.trim(),
      fullName: _fullNameController.text.trim(),
      phoneNumber: _phoneController.text.trim(),
      role: widget.userType == UserType.admin ? 'admin' : 'user',
    );

    final validationError = dto.validate();
    if (validationError != null) {
      setState(() {
        _error = validationError;
        _isLoading = false;
      });
      return;
    }

    final success = await AuthService.register(dto);

    if (success) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    } else {
      setState(() {
        _error = 'Registration failed. Please check your info.';
      });
    }

    setState(() => _isLoading = false);
  }

  void _showHelpDialog() {
    final isUser = widget.userType == UserType.user;
    final title = isUser ? "User Registration Help" : "Admin Registration Help";
    final content =
        isUser
            ? "Please enter your school number, full name, phone number, and password."
            : "Please enter your email, full name, phone number, and password.";

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(title),
            content: Text(content),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Close"),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isUser = widget.userType == UserType.user;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Sign Up"),
        backgroundColor: yeditepeBlue,
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline, color: Colors.white),
            onPressed: _showHelpDialog,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text(
                "Sign up as ${isUser ? "User" : "Admin"}",
                style: const TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _usernameController,
                keyboardType:
                    isUser ? TextInputType.number : TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: isUser ? "School Number" : "Email",
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: "Password",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _fullNameController,
                decoration: const InputDecoration(
                  labelText: "Full Name",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: "Phone Number",
                  border: OutlineInputBorder(),
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
                  onPressed: _isLoading ? null : _register,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: yeditepeBlue,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child:
                      _isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                            "Register",
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
