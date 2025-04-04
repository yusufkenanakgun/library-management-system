import 'package:flutter/material.dart';
import '../../models/user_type.dart';

class SignUpScreen extends StatelessWidget {
  final UserType userType;

  const SignUpScreen({super.key, required this.userType});

  @override
  Widget build(BuildContext context) {
    final Color yeditepeBlue = const Color(0xFF0056A1);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Sign Up"),
        backgroundColor: yeditepeBlue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text(
                "Sign up as ${userType == UserType.user ? "User" : "Admin"}",
                style: const TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 16),

              /// 💡 Form elemanlarına controller ekleyebilirsin
              /// Eğer ileride verileri backend'e göndermek istersen
              TextField(
                decoration: const InputDecoration(labelText: "Full Name"),
              ),

              if (userType == UserType.user)
                TextField(
                  decoration: const InputDecoration(labelText: "School Number"),
                  keyboardType: TextInputType.number,
                ),

              TextField(
                decoration: const InputDecoration(labelText: "Email"),
                keyboardType: TextInputType.emailAddress,
              ),

              TextField(
                decoration: const InputDecoration(labelText: "Phone Number"),
                keyboardType: TextInputType.phone,
              ),

              /// 💡 Şifre alanı eklemek mantıklı olabilir:
              TextField(
                obscureText: true,
                decoration: const InputDecoration(labelText: "Password"),
              ),

              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    /// Şu an sadece geri dönüyor
                    /// Gerçek bir kayıt işlemi varsa burada yapılabilir
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: yeditepeBlue,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    "Register",
                    style: TextStyle(color: Colors.white, fontSize: 16),
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
