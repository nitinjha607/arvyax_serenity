import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/ambience.dart';

class AmbienceRepository {
  Future<List<Ambience>> getAmbiences() async {
    try {
      final String response = await rootBundle.loadString('assets/data/ambiences.json');
      final List<dynamic> data = json.decode(response);
      return data.map((json) => Ambience.fromJson(json)).toList();
    } catch (e) {
      print("Error loading ambiences: $e");
      return [];
    }
  }
}
