import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:unitcoverter/Model/unit_model.dart';
import 'package:unitcoverter/theme/appcolor.dart';

class UnitInput extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColor.cardColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: AppColor.backgroundColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<UnitModel>(
                value: selectedUnit,
                dropdownColor: AppColor.cardColor,
                icon: const Icon(
                  Icons.keyboard_arrow_down,
                  color: AppColor.secondaryTextColor,
                ),
                isExpanded: true,
                onChanged: onUnitChanged,
                items: subUnit.map((unit) {
                  return DropdownMenuItem(
                    value: unit,
                    child: Text(
                      "${unit.name} (${unit.symbol})",
                      style: GoogleFonts.robotoMono(
                        color: AppColor.textColor,
                        fontSize: 16,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: TextField(
              controller: controller,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              style: GoogleFonts.robotoMono(
                fontSize: 32,
                fontWeight: FontWeight.w600,
                color: AppColor.textColor,
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: '0.0',
                hintStyle: GoogleFonts.robotoMono(
                  color: AppColor.secondaryTextColor.withValues(alpha: 0.5),
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
