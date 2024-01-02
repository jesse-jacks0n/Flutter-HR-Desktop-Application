
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hrflutter/pages/splash.dart';
import 'package:hrflutter/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:window_manager/window_manager.dart';

import 'database/database.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MongoDatabase.connect();

  // Ensure the window manager is initialized
  await windowManager.ensureInitialized();

  // Set the minimum and maximum window size for Windows
  WindowManager.instance.setMinimumSize(const Size(1366, 768));
  //WindowManager.instance.setMaximumSize(const Size(1200, 600));

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final customColor = Color(0xFF1D322F);
    return ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) {
          return MaterialApp(
            title: 'HR DESKTOP',
            theme: themeProvider.themeData,
            debugShowCheckedModeBanner: false,
            home: const Splash(),
          );
        },
      ),
    );

  }

}


