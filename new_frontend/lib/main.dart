import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Screens
import 'screens/auth/login_screen.dart';
import 'screens/user/user_bottom_nav.dart';
import 'screens/admin/add_book_screen.dart';
import 'screens/admin/manage_books_screen.dart';
import 'screens/admin/total_books_screen.dart';
import 'screens/admin/available_books_screen.dart';
import 'screens/admin/favorite_books_screen.dart';
import 'screens/admin/borrowed_books_screen.dart';
import 'screens/admin/reservation_list_screen.dart';
import 'screens/admin/admin_help_screen.dart';
import 'screens/user/reservations_screen.dart';
import 'screens/user/notification_screen.dart';

// Providers
import 'providers/favorites_provider.dart';
import 'providers/borrowed_provider.dart';
import 'providers/book_provider.dart';
import 'providers/reservation_provider.dart';
import 'providers/user_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final userProvider = UserProvider();
  await userProvider.loadUser(); // 🧠 Kullanıcı bilgilerini yükle

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<UserProvider>.value(value: userProvider),
        ChangeNotifierProvider(create: (_) => FavoritesProvider()),
        ChangeNotifierProvider(create: (_) => BorrowedProvider()),
        ChangeNotifierProvider(create: (_) => BookProvider()),
        ChangeNotifierProvider(create: (_) => ReservationProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<bool> _isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt');
    return token != null;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'YURead',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue, fontFamily: 'Nunito'),
      routes: {
        '/login': (context) => const LoginScreen(),
        '/user': (context) => const UserBottomNav(),
        '/manage-books': (context) => const ManageBooksScreen(),
        '/add-book': (context) => const AddBookScreen(),
        '/total-books': (context) => const TotalBooksScreen(),
        '/available-books': (context) => const AvailableBooksScreen(),
        '/favorites': (context) => const FavoriteBooksScreen(),
        '/borrowed': (context) => const BorrowedBooksScreen(),
        '/admin-help': (context) => const AdminHelpScreen(),
        '/reservations': (context) => const ReservationsScreen(),
        '/notifications': (context) => const NotificationScreen(),
        '/reservation': (context) => const ReservationListScreen(),
      },
      home: FutureBuilder<bool>(
        future: _isLoggedIn(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasData && snapshot.data == true) {
            final role = Provider.of<UserProvider>(context).role;
            return role == 'admin'
                ? const ManageBooksScreen()
                : const UserBottomNav();
          } else {
            return const LoginScreen();
          }
        },
      ),
    );
  }
}
