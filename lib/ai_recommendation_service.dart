// lib/services/ai_recommendation_service.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class UserProfile {
  final double budget;
  final String location;
  final bool hasExperience;

  UserProfile({
    required this.budget,
    required this.location,
    required this.hasExperience,
  });
}

class FranchiseRecommendation {
  final String name;
  final int matchPercentage;
  final String reason;
  final double estimatedProfit;

  FranchiseRecommendation({
    required this.name,
    required this.matchPercentage,
    required this.reason,
    required this.estimatedProfit,
  });
}

class AIRecommendationService {
  Future<List<FranchiseRecommendation>> getRecommendations(UserProfile userProfile) async {
    // Implementasi AI recommendation menggunakan TensorFlow Lite atau API eksternal
    // Contoh dengan mock data berdasarkan profil user
    
    List<FranchiseRecommendation> recommendations = [];
    
    // Logika rekomendasi berdasarkan budget, lokasi, pengalaman, dll
    if (userProfile.budget < 100000000) {
      recommendations.add(
        FranchiseRecommendation(
          name: 'Warung Makan Sederhana',
          matchPercentage: 92,
          reason: 'Sesuai dengan budget Anda',
          estimatedProfit: userProfile.budget * 0.3,
        )
      );
    } else if (userProfile.hasExperience) {
      recommendations.add(
        FranchiseRecommendation(
          name: 'Coffee Shop Premium',
          matchPercentage: 88,
          reason: 'Pengalaman Anda sangat cocok',
          estimatedProfit: userProfile.budget * 0.5,
        )
      );
    }
    
    return recommendations;
  }
}

// lib/screens/ai_recommendation_screen.dart
class AIRecommendationScreen extends StatefulWidget {
  @override
  _AIRecommendationScreenState createState() => _AIRecommendationScreenState();
}

class _AIRecommendationScreenState extends State<AIRecommendationScreen> {
  bool _isLoading = false;
  List<dynamic> recommendations = [];
  
  Future<void> _getRecommendations() async {
    setState(() => _isLoading = true);
    
    // Simulasi API call
    await Future.delayed(Duration(seconds: 2));
    
    setState(() {
      recommendations = [
        {'name': 'Bakso Premium', 'match': 95, 'reason': 'Modal terjangkau', 'roi': '35%'},
        {'name': 'Laundry Kiloan', 'match': 87, 'reason': 'Permintaan tinggi', 'roi': '28%'},
        {'name': 'Minuman Kekinian', 'match': 82, 'reason': 'Trending saat ini', 'roi': '42%'},
      ];
      _isLoading = false;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('AI Business Recommendation'),
        backgroundColor: Colors.purple[700],
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            // User profile form
            Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Budget (Rp)'),
                      keyboardType: TextInputType.number,
                    ),
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Lokasi usaha'),
                    ),
                    SwitchListTile(
                      title: Text('Punya pengalaman bisnis'),
                      value: true,
                      onChanged: (value) {},
                    ),
                    ElevatedButton(
                      onPressed: _getRecommendations,
                      child: Text('Dapatkan Rekomendasi AI'),
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(double.infinity, 50),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            SizedBox(height: 20),
            
            if (_isLoading)
              Center(child: CircularProgressIndicator())
            else if (recommendations.isNotEmpty)
              Expanded(
                child: ListView.builder(
                  itemCount: recommendations.length,
                  itemBuilder: (context, index) {
                    return Card(
                      margin: EdgeInsets.only(bottom: 12),
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.recommend, color: Colors.purple),
                                SizedBox(width: 10),
                                Text(recommendations[index]['name'],
                                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                                Spacer(),
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: Colors.purple,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text('${recommendations[index]['match']}% Match',
                                      style: TextStyle(color: Colors.white)),
                                ),
                              ],
                            ),
                            SizedBox(height: 8),
                            Text('🎯 ${recommendations[index]['reason']}'),
                            Text('💰 ROI: ${recommendations[index]['roi']}'),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}