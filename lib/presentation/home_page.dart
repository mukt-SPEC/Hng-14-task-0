import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:unitcoverter/presentation/widget/settings_modal.dart';
import 'package:unitcoverter/theme/text_styles.dart';
import 'package:unitcoverter/provider/theme_provider.dart';
import 'package:unitcoverter/theme/appcolor.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);
    final isDark =
        themeMode == ThemeMode.dark ||
        (themeMode == ThemeMode.system &&
            MediaQuery.platformBrightnessOf(context) == Brightness.dark);
    final colors = isDark ? AppColors.dark : AppColors.light;

    return Scaffold(
      backgroundColor: colors.backgroundColor,
      floatingActionButton: FloatingActionButton(
        elevation: 0,
        onPressed: () {
          showModalBottomSheet(
            context: context,
            backgroundColor: Colors.transparent,
            builder: (_) => const SettingsModal(),
          );
        },
        backgroundColor: colors.buttonColor,
        child: const PhosphorIcon(PhosphorIconsFill.gear, color: Colors.white),
      ),
      appBar: AppBar(
        titleSpacing: 16,
        elevation: 0,
        title: Text("Quattro", style: AppTextStyles.titleLarge),
        backgroundColor: Colors.transparent,
        foregroundColor: colors.textColor,
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            RichText(
              text: TextSpan(
                style: AppTextStyles.headlineMedium.copyWith(
                  color: colors.secondaryTextColor,
                  fontWeight: FontWeight.bold,
                  height: 1.2,
                ),
                children: [
                  const TextSpan(text: 'Your all in one \n'),
                  TextSpan(
                    text: 'Productivity',
                    style: AppTextStyles.headlineMedium.copyWith(
                      color: colors.buttonColor,
                      fontWeight: FontWeight.bold,
                      height: 1.2,
                    ),
                  ),
                  const TextSpan(text: ' Suite'),
                ],
              ),
            ),
            IconButton.filled(
              onPressed: () {},
              icon: PhosphorIcon(
                PhosphorIconsFill.bell,
                size: 24,
                color: colors.textColor,
              ),
              style: IconButton.styleFrom(backgroundColor: colors.cardColor),
            ),
          ],
        ),
      ),
    );
  }
}
