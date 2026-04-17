import 'package:eazychise/core/models/user_model.dart';
import 'package:flutter/material.dart';


class AuthProvider extends ChangeNotifier {
  UserModel? _currentUser;
  bool _isLoggedIn = false;

  UserModel? get currentUser => _currentUser;
  bool get isLoggedIn => _isLoggedIn;

  Future<bool> login(String email, String password) async {
    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));
    
    // Dummy authentication
    if (email == 'zidane@gmail.com' && password == 'zidane') {
      _currentUser = UserModel.dummy();
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

  Future<bool> register(String name, String email, String password) async {
    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));
    
    // Dummy registration
    _currentUser = UserModel(
      id: DateTime.now().toString(),
      name: name,
      email: email,
      phone: '',
      balance: 0,
      activeFranchises: 0,
      totalInvestment: 0,
    );
    _isLoggedIn = true;
    notifyListeners();
    return true;
  }

  void updateUser(UserModel user) {
    _currentUser = user;
    notifyListeners();
  }
}