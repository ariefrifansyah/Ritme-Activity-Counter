import 'package:flutter/material.dart';
import 'data/activity_data.dart';
import 'repositories/activity_repository.dart';
import 'viewmodels/activity_viewmodel.dart';
import 'views/home_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ActivityCounterApp());
}

/// Root aplikasi: Data -> Repository -> ViewModel -> View.
/// Tidak menambah file Dart maupun dependensi eksternal.
class ActivityCounterApp extends StatefulWidget {
  const ActivityCounterApp({super.key});

  @override
  State<ActivityCounterApp> createState() => _ActivityCounterAppState();
}

class _ActivityCounterAppState extends State<ActivityCounterApp> {
  late final ActivityViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = ActivityViewModel(ActivityRepository(ActivityData()));
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const forest = Color(0xFF08654E);
    const ink = Color(0xFF103B32);
    const canvas = Color(0xFFFBFBF7);
    const line = Color(0xFFE3EBE4);
    const lime = Color(0xFFD8F79A);

    return ActivityScope(
      viewModel: _viewModel,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Ritme — Activity Counter',
        theme: ThemeData(
          useMaterial3: true,
          scaffoldBackgroundColor: canvas,
          colorScheme: ColorScheme.fromSeed(
            seedColor: forest,
            primary: forest,
            onPrimary: Colors.white,
            secondary: lime,
            onSecondary: ink,
            surface: Colors.white,
            onSurface: ink,
            error: const Color(0xFFC93636),
          ),
          textTheme: const TextTheme(
            bodyMedium: TextStyle(color: ink, fontSize: 14),
            bodyLarge: TextStyle(color: ink, fontSize: 16),
          ),
          appBarTheme: const AppBarTheme(
            backgroundColor: canvas,
            surfaceTintColor: Colors.transparent,
            elevation: 0,
            scrolledUnderElevation: 0,
            centerTitle: true,
            iconTheme: IconThemeData(color: ink),
            titleTextStyle: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: ink,
              letterSpacing: -0.4,
            ),
          ),
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: Colors.white,
            hintStyle: const TextStyle(color: Color(0xFF93A49C)),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 17,
              vertical: 17,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(17),
              borderSide: const BorderSide(color: line),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(17),
              borderSide: const BorderSide(color: line),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(17),
              borderSide: const BorderSide(color: forest, width: 1.7),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(17),
              borderSide: const BorderSide(color: Color(0xFFC93636)),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(17),
              borderSide: const BorderSide(color: Color(0xFFC93636), width: 1.7),
            ),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              elevation: 0,
              backgroundColor: forest,
              foregroundColor: Colors.white,
              minimumSize: const Size(0, 56),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              textStyle: const TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 15,
              ),
            ),
          ),
          snackBarTheme: SnackBarThemeData(
            behavior: SnackBarBehavior.floating,
            backgroundColor: ink,
            contentTextStyle: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
        ),
        home: const HomeView(),
      ),
    );
  }
}
