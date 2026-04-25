import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/walk_event_provider.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const PottyTrackerApp());
}

class PottyTrackerApp extends StatelessWidget {
  const PottyTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => WalkEventProvider()),
      ],
      child: MaterialApp(
        title: 'PottyTracker',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
        ),
        home: const HomeScreen(),
      ),
    );
  }
}