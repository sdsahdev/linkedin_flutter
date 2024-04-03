// candidate_provider.dart
import 'package:flutter/material.dart';

class CandidateProvider with ChangeNotifier {
  final List<Map<String, dynamic>> _candidates = [
    // Your candidate data
  ];

  List<Map<String, dynamic>> get candidates => _candidates;

  void connectDisconnectUser(int index) {
    _candidates[index]['isConnected'] = !_candidates[index]['isConnected'];
    notifyListeners();
  }
}
