import 'package:flutter/material.dart';
import 'package:eazychise/core/models/franchise_model.dart';

class FranchiseProvider extends ChangeNotifier {
  List<FranchiseModel> _franchises = [];
  List<FranchiseModel> _bookmarks = [];
  String _selectedCategory = 'All';
  String _searchQuery = '';

  FranchiseProvider() {
    _franchises = FranchiseModel.dummyData();
    _selectedCategory = ''; // Set default ke empty string (show all)
  }

  List<FranchiseModel> get franchises {
    var filtered = _franchises.where((franchise) {
      final matchesCategory = _selectedCategory.isEmpty || 
          franchise.category == _selectedCategory;
      final matchesSearch = franchise.name.toLowerCase().contains(
          _searchQuery.toLowerCase()) || 
          franchise.description.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();
    
    return filtered;
  }

  List<FranchiseModel> get bookmarks => _bookmarks;
  List<FranchiseModel> get recommended => 
      _franchises.where((f) => f.isRecommended).toList();
  String get selectedCategory => _selectedCategory;
  String get searchQuery => _searchQuery;

  void setCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  // Di file franchise_provider.dart, tambahkan method ini:

void clearFilters() {
  _searchQuery = '';
  _selectedCategory = '';
  notifyListeners();
}

  void toggleBookmark(FranchiseModel franchise) {
    if (_bookmarks.contains(franchise)) {
      _bookmarks.remove(franchise);
    } else {
      _bookmarks.add(franchise);
    }
    notifyListeners();
  }

  bool isBookmarked(FranchiseModel franchise) {
    return _bookmarks.contains(franchise);
  }

  List<String> get categories {
    return ['All', ..._franchises.map((f) => f.category).toSet()];
  }
}