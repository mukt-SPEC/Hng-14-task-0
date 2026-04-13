import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:unitcoverter/Core/category_list.dart';
import 'package:unitcoverter/provider/category_provider.dart';
import 'package:unitcoverter/provider/converter_provider.dart';
import 'package:unitcoverter/theme/appcolor.dart';
import 'package:unitcoverter/presentation/widget/unit_input.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:unitcoverter/provider/theme_provider.dart';
import 'package:unitcoverter/presentation/widget/settings_modal.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  late TextEditingController topController;
  late TextEditingController bottomController;

  @override
  void initState() {
    super.initState();
    topController = TextEditingController();
    bottomController = TextEditingController();
  }

  @override
  void dispose() {
    topController.dispose();
    bottomController.dispose();
    super.dispose();
  }

  String _format(double? value) {
    if (value == null) return "";
    if (value == value.toInt()) return value.toInt().toString();
    String str = value.toStringAsFixed(6);
    str = str.replaceAll(RegExp(r'0*$'), '');
    str = str.replaceAll(RegExp(r'\.$'), '');
    return str;
  }

  @override
  Widget build(BuildContext context) {
    final activeCategory = ref.watch(activeCategoryProvider);
    final categories = ref.watch(categoryListProvider);
    final converter = ref.watch(converterProvider);
    final themeMode = ref.watch(themeProvider);
    final isDark =
        themeMode == ThemeMode.dark ||
        (themeMode == ThemeMode.system &&
            MediaQuery.platformBrightnessOf(context) == Brightness.dark);
    final colors = isDark ? AppColors.dark : AppColors.light;

    ref.listen<ConverterState>(converterProvider, (previous, next) {
      if (previous?.valueTop != next.valueTop) {
        final textVal = double.tryParse(topController.text);
        if (textVal != next.valueTop) {
          topController.text = _format(next.valueTop);
        }
      }
      if (previous?.valueBottom != next.valueBottom) {
        final textVal = double.tryParse(bottomController.text);
        if (textVal != next.valueBottom) {
          bottomController.text = _format(next.valueBottom);
        }
      }
    });

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
        backgroundColor: colors.cardColor,
        child: PhosphorIcon(PhosphorIconsFill.gear, color: colors.textColor),
      ),
      appBar: AppBar(
        titleSpacing: 16,
        elevation: 0,
        title: Text(
          "Unit Converter",
          style: GoogleFonts.geistMono(fontWeight: FontWeight.w600),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                const SizedBox(width: 16),
                ...categories.map((category) {
                  bool isSelected = category == activeCategory;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0, bottom: 8.0),
                    child: ChoiceChip(
                      padding: EdgeInsets.fromLTRB(8, 4, 8, 8),
                      avatar: PhosphorIcon(
                        category.icon,
                        size: 24,
                        color: isSelected
                            ? const Color.fromARGB(255, 245, 62, 184)
                            : colors.secondaryTextColor,
                        duotoneSecondaryColor: isSelected
                            ? const Color(0xffb100cd)
                            : colors.secondaryTextColor,
                      ),
                      elevation: 0,
                      side: BorderSide.none,
                      backgroundColor: colors.backgroundColor,
                      selectedColor: colors.cardColor,
                      showCheckmark: false,
                      label: Text(category.name),
                      labelStyle: GoogleFonts.geistMono(
                        fontSize: 14,
                        color: isSelected
                            ? colors.textColor
                            : colors.secondaryTextColor,
                        fontWeight: isSelected
                            ? FontWeight.w700
                            : FontWeight.normal,
                      ),
                      selected: isSelected,
                      onSelected: (selected) {
                        ref.read(activeCategoryindexProovider.notifier).state =
                            categories.indexOf(category);
                      },
                    ),
                  );
                }),
              ],
            ),
          ),
        ),
        backgroundColor: Colors.transparent,
        foregroundColor: colors.textColor,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            const SizedBox(height: 16),
            UnitInput(
              value: converter.valueTop,
              selectedUnit: converter.unitTop,
              subUnit: converter.category.units,
              controller: topController,
              onValueChanged: (val) {
                ref.read(converterProvider.notifier).updateFromTop(val);
              },
              onUnitChanged: (unit) {
                if (unit != null) {
                  ref.read(converterProvider.notifier).updateFromTopUnit(unit);
                }
              },
            ),
            const SizedBox(height: 24),
            UnitInput(
              value: converter.valueBottom,
              selectedUnit: converter.unitBottom,
              subUnit: converter.category.units,
              controller: bottomController,
              onValueChanged: (val) {
                ref.read(converterProvider.notifier).updateFromBottom(val);
              },
              onUnitChanged: (unit) {
                if (unit != null) {
                  ref
                      .read(converterProvider.notifier)
                      .updateFromBottomUnit(unit);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
