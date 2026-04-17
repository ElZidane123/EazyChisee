class FundingModel {
  final String id;
  final String franchiseId;
  final String franchiseName;
  final double amount;
  final double fundedAmount;
  final double interestRate;
  final int tenureMonths;
  final String status; // pending, approved, rejected, disbursed
  final DateTime applicationDate;
  final DateTime? approvalDate;
  final DateTime? disbursementDate;
  final String? notes;

  FundingModel({
    required this.id,
    required this.franchiseId,
    required this.franchiseName,
    required this.amount,
    required this.fundedAmount,
    required this.interestRate,
    required this.tenureMonths,
    required this.status,
    required this.applicationDate,
    this.approvalDate,
    this.disbursementDate,
    this.notes,
  });

  static List<FundingModel> dummyData() {
    return [
      FundingModel(
        id: '1',
        franchiseId: '1',
        franchiseName: 'Kopi Kenangan',
        amount: 200000000,
        fundedAmount: 200000000,
        interestRate: 8.5,
        tenureMonths: 24,
        status: 'disbursed',
        applicationDate: DateTime.now().subtract(const Duration(days: 60)),
        approvalDate: DateTime.now().subtract(const Duration(days: 55)),
        disbursementDate: DateTime.now().subtract(const Duration(days: 50)),
      ),
      FundingModel(
        id: '2',
        franchiseId: '2',
        franchiseName: 'Mie Gacoan',
        amount: 300000000,
        fundedAmount: 150000000,
        interestRate: 9.0,
        tenureMonths: 36,
        status: 'approved',
        applicationDate: DateTime.now().subtract(const Duration(days: 20)),
        approvalDate: DateTime.now().subtract(const Duration(days: 15)),
      ),
      FundingModel(
        id: '3',
        franchiseId: '3',
        franchiseName: 'Miniso',
        amount: 400000000,
        fundedAmount: 0,
        interestRate: 8.0,
        tenureMonths: 30,
        status: 'pending',
        applicationDate: DateTime.now().subtract(const Duration(days: 5)),
      ),
    ];
  }
}