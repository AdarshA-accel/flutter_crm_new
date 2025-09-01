import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart';
import 'package:provider/provider.dart';
import 'package:flutter_crm/providers/user_provider.dart';
import 'package:flutter_crm/routes/route_generator.dart';
import 'package:flutter_crm/screens/splash/splash_screen.dart';
import 'package:flutter_crm/screens/dashboard/home_screen.dart';
import 'package:flutter_crm/screens/welcome/welcome_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: DevicePreview(
        enabled: true,
        builder: (context) => const MyApp(),
      ),
    ),
  );
}

/// Root widget of the Flutter CRM application.
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _loading = true;
  bool _loggedIn = false;

  @override
  void initState() {
    super.initState();
    _checkLogin();
  }

  Future<void> _checkLogin() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    // Load persisted token & user
    await userProvider.loadToken();
    await userProvider.loadUser();

    // If already logged in, refresh profile from API
    if (userProvider.isLoggedIn) {
      await userProvider.authenticateSession();
    }

    setState(() {
      _loggedIn = userProvider.isLoggedIn;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      // simple splash loader
      return const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: Center(child: CircularProgressIndicator()),
        ),
      );
    }

    return MaterialApp(
      title: 'Flutter CRM',
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        fontFamily: 'PublicSans',
      ),
      home: _loggedIn ? const HomeScreen() : const SplashScreen(),
      routes: {
        '/welcome': (context) => const WelcomeScreen(),
        '/home': (context) => const HomeScreen(),
      },
      onGenerateRoute: RouteGenerator.generateRoute,
    );
  }
}
