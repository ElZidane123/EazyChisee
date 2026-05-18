class UserModel {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String? photoUrl;
  final double balance;
  final int activeFranchises;
  final double totalInvestment;
  /// 'franchisee' atau 'franchisor'
  final String role;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.photoUrl,
    required this.balance,
    required this.activeFranchises,
    required this.totalInvestment,
    this.role = 'franchisee',
  });

  factory UserModel.dummy({String role = 'franchisee'}) {
    return UserModel(
      id: '1',
      name: 'El Zidane',
      email: 'zidane@example.com',
      phone: '081234567890',
      photoUrl: null,
      balance: 250000000,
      activeFranchises: 3,
      totalInvestment: 180000000,
      role: role,
    );
  }

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? photoUrl,
    double? balance,
    int? activeFranchises,
    double? totalInvestment,
    String? role,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      photoUrl: photoUrl ?? this.photoUrl,
      balance: balance ?? this.balance,
      activeFranchises: activeFranchises ?? this.activeFranchises,
      totalInvestment: totalInvestment ?? this.totalInvestment,
      role: role ?? this.role,
    );
  }
}