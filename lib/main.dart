import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:unitcoverter/Model/todo_model.dart';
import 'package:unitcoverter/presentation/root_screen.dart';
import 'package:unitcoverter/provider/theme_provider.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(TodoModelAdapter());
  await Hive.openBox<TodoModel>('todos');
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const RootScreen(),
      themeMode: themeMode,
      theme: ThemeData(
        brightness: Brightness.light,
        splashFactory: NoSplash.splashFactory,
        highlightColor: Colors.transparent,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        splashFactory: NoSplash.splashFactory,
        highlightColor: Colors.transparent,
      ),
    );
  }
}
