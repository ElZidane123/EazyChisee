import 'package:flutter/material.dart';
import 'package:eazychise/core/models/funding_model.dart';

class FundingProvider extends ChangeNotifier {
  List<FundingModel> _fundings = [];

  FundingProvider() {
    _fundings = FundingModel.dummyData();
  }

  List<FundingModel> get fundings => _fundings;
  
  List<FundingModel> get activeFundings {
    return _fundings.where((f) => 
      f.status == 'approved' || f.status == 'disbursed'
    ).toList();
  }

  List<FundingModel> get pendingFundings {
    return _fundings.where((f) => f.status == 'pending').toList();
  }

  Future<bool> applyFunding({
    required String franchiseId,
    required String franchiseName,
    required double amount,
    required int tenureMonths,
  }) async {
    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));
    
    final newFunding = FundingModel(
      id: DateTime.now().toString(),
      franchiseId: franchiseId,
      franchiseName: franchiseName,
      amount: amount,
      fundedAmount: 0,
      interestRate: 8.5,
      tenureMonths: tenureMonths,
      status: 'pending',
      applicationDate: DateTime.now(),
    );
    
    _fundings.add(newFunding);
    notifyListeners();
    return true;
  }

  double get totalFundedAmount {
    return _fundings
        .where((f) => f.status == 'disbursed')
        .fold(0, (sum, f) => sum + f.amount);
  }

  double get totalPendingAmount {
    return _fundings
        .where((f) => f.status == 'pending')
        .fold(0, (sum, f) => sum + f.amount);
  }
}