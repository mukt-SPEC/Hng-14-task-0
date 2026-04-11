import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:unitcoverter/Core/category_list.dart';
import 'package:unitcoverter/provider/category_provider.dart';
import 'package:unitcoverter/provider/converter_provider.dart';
import 'package:unitcoverter/theme/appcolor.dart';
import 'package:unitcoverter/presentation/widget/unit_input.dart';
import 'package:google_fonts/google_fonts.dart';

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

    return DefaultTabController(
      length: categories.length,
      child: Scaffold(
        backgroundColor: AppColor.backgroundColor,
        appBar: AppBar(
          titleSpacing: 16,
          elevation: 0,
          title: Text(
            "Unit Converter",
            style: GoogleFonts.robotoMono(fontWeight: FontWeight.w600),
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(40),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  const SizedBox(width: 16),
                  ...categories.map((category) {
                    bool isSelected = category == activeCategory;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: ChoiceChip(
                        padding: const EdgeInsets.fromLTRB(12, 8, 8, 12),
                        avatar: Center(
                          child: PhosphorIcon(
                            category.icon,
                            size: 24,
                            color: isSelected
                                ? const Color.fromARGB(255, 245, 62, 184)
                                : AppColor.secondaryTextColor,
                            duotoneSecondaryColor: isSelected
                                ? const Color(0xffb100cd)
                                : AppColor.secondaryTextColor,
                          ),
                        ),
                        elevation: 0,
                        side: BorderSide.none,
                        backgroundColor: AppColor.backgroundColor,
                        selectedColor: AppColor.backgroundColor,
                        showCheckmark: false,
                        label: Text(category.name),
                        labelPadding: const EdgeInsets.only(top: 4, left: 8),
                        labelStyle: GoogleFonts.robotoMono(
                          fontSize: 14,
                          color: isSelected
                              ? AppColor.textColor
                              : AppColor.secondaryTextColor,
                          fontWeight: isSelected
                              ? FontWeight.w700
                              : FontWeight.normal,
                        ),
                        selected: isSelected,
                        onSelected: (selected) {
                          ref
                              .read(activeCategoryindexProovider.notifier)
                              .state = categories.indexOf(category);
                        },
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
          backgroundColor: Colors.transparent,
          foregroundColor: AppColor.textColor,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              const SizedBox(height: 32),
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
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 24),
                child: Center(
                  child: PhosphorIcon(
                    PhosphorIconsRegular.arrowsDownUp,
                    color: AppColor.secondaryTextColor,
                    size: 28,
                  ),
                ),
              ),
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
                    ref.read(converterProvider.notifier).updateFromBottomUnit(unit);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
