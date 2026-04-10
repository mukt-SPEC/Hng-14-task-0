import 'package:quantify/quantify.dart' as q;

class UnitModel {
  final String name;
  final String symbol;
  final q.Unit quantity;

  UnitModel({required this.name, required this.symbol, required this.quantity});
}
