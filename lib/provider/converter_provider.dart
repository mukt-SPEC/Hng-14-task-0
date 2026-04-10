import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:unitcoverter/Core/category_enum.dart';
import 'package:unitcoverter/Model/unit_category.dart';
import 'package:unitcoverter/Model/unit_model.dart';
import 'package:unitcoverter/provider/category_provider.dart';

// class ConverterProvider extends StateNotifier<UnitCategory> {
//   ConverterProvider() : super(UnitCategory());
// }

// final converterProvider = StateNotifierProvider<ConverterProvider, UnitCategory>((ref) {
//   return ConverterProvider();
// });

class ConverterState {
  final UnitCategory category;
  final UnitModel fromUnit;
  final UnitModel toUnit;
  final double valueA;
  final CategoryType type;
  final double valueB;

  ConverterState({
    required this.category,
    required this.fromUnit,
    required this.toUnit,
    required this.valueA,
    required this.type,
    required this.valueB,
  });

  ConverterState copyWith({
    UnitCategory? category,
    UnitModel? fromUnit,
    UnitModel? toUnit,
    double? valueA,
    CategoryType? type,
    double? valueB,
  }) {
    return ConverterState(
      category: category ?? this.category,
      fromUnit: fromUnit ?? this.fromUnit,
      toUnit: toUnit ?? this.toUnit,
      valueA: valueA ?? this.valueA,
      type: type ?? this.type,
      valueB: valueB ?? this.valueB,
    );
  }
}

class ConverterNotifier extends Notifier<ConverterState> {
  @override
  ConverterState build() {
    final category = ref.watch(activeCategoryProvider);
    final fromUnit = category.units.first;
    final toUnit = category.units.last;
    return ConverterState(
      category: category,
      fromUnit: fromUnit,
      toUnit: toUnit,
      valueA: 0.0,
      type: category.type,
      valueB: 0.0,
    );
  }

  void setFromUnit(UnitModel unit) {
    state = state.copyWith(fromUnit: unit);
  }

  void setToUnit(UnitModel unit) {
    state = state.copyWith(toUnit: unit);
  }

  void setValueA(double value) {
    state = state.copyWith(valueA: value);
  }

  void setValueB(double value) {
    state = state.copyWith(valueB: value);
  }
}
