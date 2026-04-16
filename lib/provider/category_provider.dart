import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:unitcoverter/Core/category_list.dart';
import 'package:unitcoverter/model/unit_category.dart';

final activeCategoryindexProovider = StateProvider<int>((ref) {
  return 0;
});

final activeCategoryProvider = Provider<UnitCategory>((ref) {
  final index = ref.watch(activeCategoryindexProovider);
  final categories = ref.watch(categoryListProvider);
  return categories[index];
});
