import 'package:eazychise/core/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider extends ChangeNotifier {
  UserModel? _currentUser;
  bool _isLoggedIn = false;

  UserModel? get currentUser => _currentUser;
  bool get isLoggedIn => _isLoggedIn;

  /// Role dari user saat ini: 'franchisee' atau 'franchisor'
  String get userRole => _currentUser?.role ?? 'franchisee';
  bool get isFranchisor => userRole == 'franchisor';

  /// Muat role yang tersimpan di SharedPreferences
  Future<String> _loadSavedRole() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_role') ?? 'franchisee';
  }

  Future<bool> login(String email, String password) async {
    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    // Dummy authentication
    if (email == 'zidane@gmail.com' && password == 'zidane') {
      final role = await _loadSavedRole();
      _currentUser = UserModel.dummy(role: role);
      _isLoggedIn = true;
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<void> logout() async {
    _currentUser = null;
    _isLoggedIn = false;
    notifyListeners();
  }

  Future<bool> register(String name, String email, String password, String text) async {
    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    final role = await _loadSavedRole();
    _currentUser = UserModel(
      id: DateTime.now().toString(),
      name: name,
      email: email,
      phone: '',
      balance: 0,
      activeFranchises: 0,
      totalInvestment: 0,
      role: role,
    );
    _isLoggedIn = true;
    notifyListeners();
    return true;
  }

  void updateUser(UserModel user) {
    _currentUser = user;
    notifyListeners();
  }

  /// Update role dan simpan ke SharedPreferences
  Future<void> updateRole(String role) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_role', role);
    if (_currentUser != null) {
      _currentUser = _currentUser!.copyWith(role: role);
      notifyListeners();
    }
  }
}