import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:quantify/quantify.dart' as q;
import 'package:unitcoverter/Core/category_enum.dart';
import 'package:unitcoverter/Model/unit_category.dart';
import 'package:unitcoverter/Model/unit_model.dart';
import 'package:unitcoverter/theme/appcolor.dart';
import 'package:unitcoverter/utils/extensions.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

final List<UnitCategory> allCategories = [
  UnitCategory(
    icon: PhosphorIcon(
      PhosphorIconsDuotone.ruler,
      duotoneSecondaryColor: AppColor.buttonColor,
      color: AppColor.textColor,
      size: 18,
    ),
    name: CategoryType.length.name.capitalize(),
    type: CategoryType.length,
    units: [
      UnitModel(
        name: q.LengthUnit.meter.name.capitalize(),
        symbol: q.LengthUnit.meter.symbol,
        quantity: q.LengthUnit.meter,
      ),
      UnitModel(
        name: q.LengthUnit.foot.name.capitalize(),
        symbol: q.LengthUnit.foot.symbol,
        quantity: q.LengthUnit.foot,
      ),
      UnitModel(
        name: q.LengthUnit.mile.name.capitalize(),
        symbol: q.LengthUnit.mile.symbol,
        quantity: q.LengthUnit.mile,
      ),
      UnitModel(
        name: q.LengthUnit.inch.name.capitalize(),
        symbol: q.LengthUnit.inch.symbol,
        quantity: q.LengthUnit.inch,
      ),
      UnitModel(
        name: q.LengthUnit.kilometer.name.capitalize(),
        symbol: q.LengthUnit.kilometer.symbol,
        quantity: q.LengthUnit.kilometer,
      ),
    ],
  ),

  UnitCategory(
    icon: PhosphorIcon(
      PhosphorIconsDuotone.clock,
      duotoneSecondaryColor: AppColor.buttonColor,
      color: AppColor.textColor,
      size: 18,
    ),
    name: CategoryType.time.name.capitalize(),
    type: CategoryType.time,
    units: [
      UnitModel(
        name: q.TimeUnit.second.name.capitalize(),
        symbol: q.TimeUnit.second.symbol,
        quantity: q.TimeUnit.second,
      ),

      UnitModel(
        name: q.TimeUnit.minute.name.capitalize(),
        symbol: q.TimeUnit.minute.symbol,
        quantity: q.TimeUnit.minute,
      ),
      UnitModel(
        name: q.TimeUnit.millisecond.name.capitalize(),
        symbol: q.TimeUnit.millisecond.symbol,
        quantity: q.TimeUnit.millisecond,
      ),
      UnitModel(
        name: q.TimeUnit.hour.name.capitalize(),
        symbol: q.TimeUnit.hour.symbol,
        quantity: q.TimeUnit.hour,
      ),
      UnitModel(
        name: q.TimeUnit.day.name.capitalize(),
        symbol: q.TimeUnit.day.symbol,
        quantity: q.TimeUnit.day,
      ),
    ],
  ),
  UnitCategory(
    icon: PhosphorIcon(
      PhosphorIconsDuotone.scales,
      duotoneSecondaryColor: AppColor.buttonColor,
      color: AppColor.textColor,
      size: 18,
    ),
    name: CategoryType.weight.name.capitalize(),
    type: CategoryType.weight,
    units: [
      UnitModel(
        name: q.MassUnit.kilogram.name.capitalize(),
        symbol: q.MassUnit.kilogram.symbol,
        quantity: q.MassUnit.kilogram,
      ),
      UnitModel(
        name: q.MassUnit.gram.name.capitalize(),
        symbol: q.MassUnit.gram.symbol,
        quantity: q.MassUnit.gram,
      ),
      UnitModel(
        name: q.MassUnit.milligram.name.capitalize(),
        symbol: q.MassUnit.milligram.symbol,
        quantity: q.MassUnit.milligram,
      ),
      UnitModel(
        name: q.MassUnit.pound.name.capitalize(),
        symbol: q.MassUnit.pound.symbol,
        quantity: q.MassUnit.pound,
      ),
      UnitModel(
        name: q.MassUnit.ounce.name.capitalize(),
        symbol: q.MassUnit.ounce.symbol,
        quantity: q.MassUnit.ounce,
      ),
    ],
  ),
  UnitCategory(
    icon: PhosphorIcon(
      PhosphorIconsDuotone.thermometer,
      duotoneSecondaryColor: AppColor.buttonColor,
      color: AppColor.textColor,
      size: 18,
    ),
    name: CategoryType.temperature.name.capitalize(),
    type: CategoryType.temperature,
    units: [
      UnitModel(
        name: q.TemperatureUnit.celsius.name.capitalize(),
        symbol: q.TemperatureUnit.celsius.symbol,
        quantity: q.TemperatureUnit.celsius,
      ),
      UnitModel(
        name: q.TemperatureUnit.fahrenheit.name.capitalize(),
        symbol: q.TemperatureUnit.fahrenheit.symbol,
        quantity: q.TemperatureUnit.fahrenheit,
      ),
      UnitModel(
        name: q.TemperatureUnit.kelvin.name.capitalize(),
        symbol: q.TemperatureUnit.kelvin.symbol,
        quantity: q.TemperatureUnit.kelvin,
      ),
    ],
  ),
  UnitCategory(
    icon: PhosphorIcon(
      PhosphorIconsDuotone.jar,
      duotoneSecondaryColor: AppColor.buttonColor,
      color: AppColor.textColor,
      size: 18,
    ),
    name: CategoryType.volume.name.capitalize(),
    type: CategoryType.volume,
    units: [
      UnitModel(
        name: q.VolumeUnit.litre.name.capitalize(),
        symbol: q.VolumeUnit.litre.symbol,
        quantity: q.VolumeUnit.litre,
      ),
      UnitModel(
        name: q.VolumeUnit.milliliter.name.capitalize(),
        symbol: q.VolumeUnit.milliliter.symbol,
        quantity: q.VolumeUnit.milliliter,
      ),
      UnitModel(
        name: q.VolumeUnit.gallon.name.capitalize(),
        symbol: q.VolumeUnit.gallon.symbol,
        quantity: q.VolumeUnit.gallon,
      ),
      UnitModel(
        name: q.VolumeUnit.quart.name.capitalize(),
        symbol: q.VolumeUnit.quart.symbol,
        quantity: q.VolumeUnit.quart,
      ),
      UnitModel(
        name: q.VolumeUnit.pint.name.capitalize(),
        symbol: q.VolumeUnit.pint.symbol,
        quantity: q.VolumeUnit.pint,
      ),
    ],
  ),
];

final categoryListProvider = Provider<List<UnitCategory>>((ref) {
  return allCategories;
});
