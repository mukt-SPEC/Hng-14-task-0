import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:unitcoverter/provider/theme_provider.dart';
import 'package:unitcoverter/theme/appcolor.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class SettingsModal extends ConsumerWidget {
  const SettingsModal({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);
    final isDark =
        themeMode == ThemeMode.dark ||
        (themeMode == ThemeMode.system &&
            MediaQuery.platformBrightnessOf(context) == Brightness.dark);
    final colors = isDark ? AppColors.dark : AppColors.light;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: colors.backgroundColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Theme",
                  style: GoogleFonts.geistMono(
                    color: colors.textColor,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton.filled(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: PhosphorIcon(
                    PhosphorIconsFill.x,
                    size: 16,
                    color: colors.textColor,
                  ),
                  style: IconButton.styleFrom(
                    backgroundColor: colors.cardColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: _themeChoice(
                    "Light",
                    ThemeMode.light,
                    themeMode,
                    colors,
                    ref,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _themeChoice(
                    "Dark",
                    ThemeMode.dark,
                    themeMode,
                    colors,
                    ref,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: colors.cardColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "System",
                    style: GoogleFonts.geistMono(
                      color: colors.textColor,
                      fontSize: 14,
                    ),
                  ),
                  Switch(
                    value: themeMode == ThemeMode.system,
                    onChanged: (val) {
                      if (val) {
                        ref
                            .read(themeProvider.notifier)
                            .setTheme(ThemeMode.system);
                      } else {
                        final brightness = MediaQuery.platformBrightnessOf(
                          context,
                        );
                        ref
                            .read(themeProvider.notifier)
                            .setTheme(
                              brightness == Brightness.dark
                                  ? ThemeMode.dark
                                  : ThemeMode.light,
                            );
                      }
                    },
                    activeThumbImage: null,
                    activeTrackColor: colors.buttonColor,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _themeChoice(
    String title,
    ThemeMode mode,
    ThemeMode currentMode,
    AppColors colors,
    WidgetRef ref,
  ) {
    bool isSelected = false;
    if (currentMode == mode) {
      isSelected = true;
    }
    if (currentMode == ThemeMode.system) {
      final brightness =
          WidgetsBinding.instance.platformDispatcher.platformBrightness;
      if (brightness == Brightness.dark && mode == ThemeMode.dark) {
        isSelected = true;
      }
      if (brightness == Brightness.light && mode == ThemeMode.light) {
        isSelected = true;
      }
    }

    return GestureDetector(
      onTap: () {
        ref.read(themeProvider.notifier).setTheme(mode);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 120,
            decoration: BoxDecoration(
              color: mode == ThemeMode.light
                  ? const Color(0xfff5f5f7)
                  : const Color(0xff121212),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isSelected ? Colors.green : colors.borderColor,
                width: isSelected ? 2 : 1,
              ),
            ),
            child: Stack(
              children: [
                Positioned(
                  top: 16,
                  left: 16,
                  right: 16,
                  bottom: 0,
                  child: Container(
                    decoration: BoxDecoration(
                      color: mode == ThemeMode.light
                          ? Colors.white
                          : const Color(0xff1e1e1e),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(8),
                        topRight: Radius.circular(8),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: isSelected
                      ? const Icon(
                          Icons.check_circle,
                          color: Colors.green,
                          size: 24,
                        )
                      : Icon(
                          Icons.circle_outlined,
                          color: colors.secondaryTextColor,
                          size: 24,
                        ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: GoogleFonts.geistMono(
              color: isSelected ? colors.textColor : colors.secondaryTextColor,
              fontSize: 14,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
