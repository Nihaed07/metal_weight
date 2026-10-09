import 'dart:convert';
import 'package:metal_weight/models.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HistoryService {
  static const String _historyKey = 'calculation_history';

  Future<void> saveHistory(List<CalculationModel> history) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final List<String> jsonList = history
          .map((item) => jsonEncode(item.toJson()))
          .toList();
      await prefs.setStringList(_historyKey, jsonList);
    } catch (_) {
      return;
    }
  }

  Future<List<CalculationModel>> loadHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final List<String>? jsonList = prefs.getStringList(_historyKey);

      if (jsonList == null || jsonList.isEmpty) {
        return [];
      }

      return jsonList
          .map((jsonStr) => CalculationModel.fromJson(jsonDecode(jsonStr)))
          .toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> clearHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_historyKey);
    } catch (_) {
      return;
    }
  }

  Future<void> addCalculation(CalculationModel calculation) async {
    try {
      final history = await loadHistory();
      history.insert(0, calculation);
      await saveHistory(history);
    } catch (_) {
      return;
    }
  }

  Future<void> deleteCalculation(int index) async {
    try {
      final history = await loadHistory();
      if (index < history.length) {
        history.removeAt(index);
        await saveHistory(history);
      }
    } catch (_) {
      return;
    }
  }
}
