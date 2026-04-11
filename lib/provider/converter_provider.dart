import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:unitcoverter/Core/category_enum.dart';
import 'package:unitcoverter/Model/unit_category.dart';
import 'package:unitcoverter/Model/unit_model.dart';
import 'package:unitcoverter/provider/category_provider.dart';
import 'package:quantify/quantify.dart' as q;

class ConverterState {
  final UnitCategory category;
  final UnitModel unitTop;
  final UnitModel unitBottom;
  final double? valueTop;
  final CategoryType type;
  final double? valueBottom;

  ConverterState({
    required this.category,
    required this.unitTop,
    required this.unitBottom,
    this.valueTop,
    required this.type,
    this.valueBottom,
  });

  ConverterState copyWith({
    UnitCategory? category,
    UnitModel? unitTop,
    UnitModel? unitBottom,
    double? valueTop,
    CategoryType? type,
    double? valueBottom,
    bool clearValues = false,
  }) {
    return ConverterState(
      category: category ?? this.category,
      unitTop: unitTop ?? this.unitTop,
      unitBottom: unitBottom ?? this.unitBottom,
      valueTop: clearValues ? null : (valueTop ?? this.valueTop),
      type: type ?? this.type,
      valueBottom: clearValues ? null : (valueBottom ?? this.valueBottom),
    );
  }
}

class ConverterNotifier extends Notifier<ConverterState> {
  @override
  ConverterState build() {
    final category = ref.watch(activeCategoryProvider);
    final unitTop = category.units.first;
    final unitBottom = category.units.length > 1
        ? category.units[1]
        : category.units.first;
    return ConverterState(
      category: category,
      unitTop: unitTop,
      unitBottom: unitBottom,
      valueTop: null,
      type: category.type,
      valueBottom: null,
    );
  }

  double _convert(double value, UnitModel from, UnitModel to) {
    q.Quantity quantity;
    switch (state.type) {
      case CategoryType.length:
        quantity = q.Length(value, from.quantity as q.LengthUnit);
        break;
      case CategoryType.weight:
        quantity = q.Mass(value, from.quantity as q.MassUnit);
        break;
      case CategoryType.temperature:
        quantity = q.Temperature(value, from.quantity as q.TemperatureUnit);
        break;
      case CategoryType.time:
        quantity = q.Time(value, from.quantity as q.TimeUnit);
        break;
      case CategoryType.volume:
        quantity = q.Volume(value, from.quantity as q.VolumeUnit);
        break;
      case CategoryType.energy:
        quantity = q.Energy(value, from.quantity as q.EnergyUnit);
        break;
      case CategoryType.frequency:
        quantity = q.Frequency(value, from.quantity as q.FrequencyUnit);
        break;
      case CategoryType.power:
        quantity = q.Power(value, from.quantity as q.PowerUnit);
        break;
      case CategoryType.pressure:
        quantity = q.Pressure(value, from.quantity as q.PressureUnit);
        break;
      case CategoryType.speed:
        quantity = q.Speed(value, from.quantity as q.SpeedUnit);
        break;
    }
    return quantity.convertTo(to.quantity).value;
  }

  void updateFromTop(double? newvalue) {
    if (newvalue == null) {
      state = state.copyWith(clearValues: true);
      return;
    }
    final convertedValue = _convert(newvalue, state.unitTop, state.unitBottom);
    state = state.copyWith(valueTop: newvalue, valueBottom: convertedValue);
  }

  void updateFromBottom(double? newvalue) {
    if (newvalue == null) {
      state = state.copyWith(clearValues: true);
      return;
    }
    final convertedValue = _convert(newvalue, state.unitBottom, state.unitTop);
    state = state.copyWith(valueBottom: newvalue, valueTop: convertedValue);
  }

  void updateFromTopUnit(UnitModel unit) {
    if (state.valueTop == null) {
      state = state.copyWith(unitTop: unit);
      return;
    }
    final convertedValue = _convert(state.valueTop!, unit, state.unitBottom);
    state = state.copyWith(unitTop: unit, valueBottom: convertedValue);
  }

  void updateFromBottomUnit(UnitModel unit) {
    if (state.valueBottom == null) {
      state = state.copyWith(unitBottom: unit);
      return;
    }
    final convertedValue = _convert(state.valueBottom!, unit, state.unitTop);
    state = state.copyWith(unitBottom: unit, valueTop: convertedValue);
  }
}

final converterProvider =
    NotifierProvider.autoDispose<ConverterNotifier, ConverterState>(() {
      return ConverterNotifier();
    });
