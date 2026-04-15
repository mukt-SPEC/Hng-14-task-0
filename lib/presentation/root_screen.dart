import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:unitcoverter/presentation/unit_converter_page.dart';
import 'package:unitcoverter/presentation/home_page.dart';
import 'package:unitcoverter/presentation/todo_page.dart';
import 'package:unitcoverter/provider/theme_provider.dart';
import 'package:unitcoverter/theme/appcolor.dart';

class RootScreen extends ConsumerStatefulWidget {
  const RootScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _RootScreenState();
}

class _RootScreenState extends ConsumerState<RootScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomePage(),
    const TodoPage(),
    const HomeScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeProvider);
    final isDark =
        themeMode == ThemeMode.dark ||
        (themeMode == ThemeMode.system &&
            MediaQuery.platformBrightnessOf(context) == Brightness.dark);
    final colors = isDark ? AppColors.dark : AppColors.light;

    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _screens),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        backgroundColor: colors.backgroundColor,
        selectedItemColor: colors.textColor,
        unselectedItemColor: colors.secondaryTextColor,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
        items: const [
          BottomNavigationBarItem(
            icon: PhosphorIcon(PhosphorIconsRegular.houseSimple),
            activeIcon: PhosphorIcon(PhosphorIconsFill.houseSimple),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: PhosphorIcon(PhosphorIconsRegular.notepad),
            activeIcon: PhosphorIcon(PhosphorIconsFill.notepad),
            label: 'Todo',
          ),
          BottomNavigationBarItem(
            icon: PhosphorIcon(PhosphorIconsRegular.circleHalfTilt),
            activeIcon: PhosphorIcon(PhosphorIconsFill.circleHalfTilt),
            label: 'Converter',
          ),
        ],
      ),
    );
  }
}
