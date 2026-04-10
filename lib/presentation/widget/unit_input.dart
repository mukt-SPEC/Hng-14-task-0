import 'package:flutter/material.dart';
import 'package:unitcoverter/Model/unit_model.dart';

class UnitInput extends StatelessWidget {
  final double value;
  final UnitModel selectedUnit;
  final List<UnitModel> subUnit;
  final Function(double) onValueChanged;
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
      padding: const EdgeInsetsGeometry.all(16),
      child: Column(
        spacing: 8,
        children: [
          DropdownButton<UnitModel>(
            value: selectedUnit,
            isExpanded: true,
            onChanged: onUnitChanged,
            items: subUnit.map((unit) {
              return DropdownMenuItem(
                value: unit,
                child: Text("${unit.name} (${unit.symbol})"),
              );
            }).toList(),
          ),
          TextField(
            controller: controller,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
            onChanged: (text){
              final newvalue = double.tryParse(text) ?? 0.0;
              onValueChanged(newvalue);
            },
          ),
        ],
      ),
    );
  }
}
