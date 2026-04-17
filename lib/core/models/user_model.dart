class UserModel {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String? photoUrl;
  final double balance;
  final int activeFranchises;
  final double totalInvestment;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.photoUrl,
    required this.balance,
    required this.activeFranchises,
    required this.totalInvestment,
  });

  factory UserModel.dummy() {
    return UserModel(
      id: '1',
      name: 'El Zidane',
      email: 'zidane@example.com',
      phone: '081234567890',
      photoUrl: null,
      balance: 250000000,
      activeFranchises: 3,
      totalInvestment: 180000000,
    );
  }
}