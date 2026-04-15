import 'package:flutter/material.dart';
import 'package:unitcoverter/theme/text_styles.dart';
import 'package:unitcoverter/Model/unit_model.dart';
import 'package:unitcoverter/theme/appcolor.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:unitcoverter/provider/theme_provider.dart';

class UnitInput extends ConsumerWidget {
  final double? value;
  final UnitModel selectedUnit;
  final List<UnitModel> subUnit;
  final Function(double?) onValueChanged;
  final Function(UnitModel?) onUnitChanged;
  final TextEditingController controller;

  const UnitInput({
    super.key,
    required this.value,
    required this.selectedUnit,
    required this.subUnit,
    required this.onValueChanged,
    required this.onUnitChanged,
    required this.controller,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);
    final isDark = themeMode == ThemeMode.dark ||
        (themeMode == ThemeMode.system &&
            MediaQuery.platformBrightnessOf(context) == Brightness.dark);
    final colors = isDark ? AppColors.dark : AppColors.light;

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: colors.cardColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: colors.backgroundColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<UnitModel>(
                value: selectedUnit,
                dropdownColor: colors.cardColor,
                icon: Icon(
                  Icons.keyboard_arrow_down,
                  color: colors.secondaryTextColor,
                ),
                isExpanded: true,
                onChanged: onUnitChanged,
                items: subUnit.map((unit) {
                  return DropdownMenuItem(
                    value: unit,
                    child: Text(
                      "${unit.name} (${unit.symbol})",
                      style: AppTextStyles.monoBodyLarge.copyWith(
                        color: colors.textColor,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0),
            child: TextField(
              textAlign: TextAlign.end,
              cursorColor: colors.textColor,
              controller: controller,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              style: AppTextStyles.monoDisplay.copyWith(
                color: colors.textColor,
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: '0.0',
                hintStyle: AppTextStyles.monoDisplay.copyWith(
                  color: colors.secondaryTextColor.withValues(alpha: 0.5),
                ),
              ),
              onChanged: (text) {
                final newvalue = double.tryParse(text);
                onValueChanged(newvalue);
              },
            ),
          ),
        ],
      ),
    );
  }
}
