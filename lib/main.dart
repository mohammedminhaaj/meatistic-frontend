import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:meatistic/models/store.dart';
import 'package:meatistic/screens/landing_page.dart';
import 'package:meatistic/screens/login.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:meatistic/screens/onboarding_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await Hive.initFlutter();
  Hive.registerAdapter(StoreAdapter());
  await Hive.openBox<Store>("store");
  await Firebase.initializeApp();
  runApp(const ProviderScope(child: App()));
}

class App extends StatelessWidget {
  const App({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final Box<Store> box = Hive.box<Store>("store");
    final Store store = box.get("storeObj", defaultValue: Store())!;
    final bool onboardingCompleted = store.onboardingCompleted;
    final String userLoggedIn = store.authToken;

    return MaterialApp(
      title: 'Meatistic',
      theme: ThemeData(
          // This is the theme of your application.
          //
          // TRY THIS: Try running your application with "flutter run". You'll see
          // the application has a blue toolbar. Then, without quitting the app,
          // try changing the seedColor in the colorScheme below to Colors.green
          // and then invoke "hot reload" (save your changes or press the "hot
          // reload" button in a Flutter-supported IDE, or press "r" if you used
          // the command line to start the app).
          //
          // Notice that the counter didn't reset back to zero; the application
          // state is not lost during the reload. To reset the state, use hot
          // restart instead.
          //
          // This works for code too, not just values: Most code changes can be
          // tested with just a hot reload.
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 0, 90, 125),
          ),
          bottomSheetTheme: const BottomSheetThemeData(
              backgroundColor: Colors.white, surfaceTintColor: Colors.white),
          useMaterial3: true,
          scaffoldBackgroundColor: Colors.white,
          textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme)),
      home: !onboardingCompleted
          ? const OnboardingScreen()
          : userLoggedIn == ""
              ? const LoginScreen()
              : const LandingPage(),
    );
  }
}
