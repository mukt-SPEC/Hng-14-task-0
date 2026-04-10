import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:unitcoverter/Core/category_enum.dart';
import 'package:unitcoverter/Model/unit_model.dart';

class UnitCategory {
  final String name;
  final PhosphorIcon icon;
  final CategoryType type;
  final List<UnitModel> units;

  UnitCategory({
    required this.name,
    required this.type,
    required this.icon,
    required this.units,
  });
}
