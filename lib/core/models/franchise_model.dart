class FranchiseModel {
  final String id;
  final String name;
  final String category;
  final String description;
  final String logoUrl;
  final String images;
  final double investmentMin;
  final double investmentMax;
  final double roi;
  final int paybackPeriod; // in months
  final double rating;
  final int totalOutlets;
  final String foundedYear;
  final bool isRecommended;
  final bool isVerified;
  final int trustScore;
  final String riskPrediction;

  FranchiseModel({
    required this.id,
    required this.name,
    required this.category,
    required this.description,
    required this.logoUrl,
    required this.images,
    required this.investmentMin,
    required this.investmentMax,
    required this.roi,
    required this.paybackPeriod,
    required this.rating,
    required this.totalOutlets,
    required this.foundedYear,
    required this.isRecommended,
    this.isVerified = false,
    this.trustScore = 0,
    this.riskPrediction = 'Medium',
  });

  static List<FranchiseModel> dummyData() {
    return [
      FranchiseModel(
        id: '1',
        name: 'Kopi Kenangan',
        category: 'F&B',
        description: 'Coffee chain with modern concept and affordable prices',
        logoUrl: 'https://via.placeholder.com/150',
        images: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRSOj0X0mtlrn-zD3t-z59ZCneMUsEaLK2rMA&s',
        investmentMin: 150000000,
        investmentMax: 250000000,
        roi: 25.5,
        paybackPeriod: 18,
        rating: 4.5,
        totalOutlets: 500,
        foundedYear: '2017',
        isRecommended: true,
        isVerified: true,
        trustScore: 92,
        riskPrediction: 'Low',
      ),
      FranchiseModel(
        id: '2',
        name: 'Mie Gacoan',
        category: 'F&B',
        description: 'Spicy noodles restaurant targeting young people',
        logoUrl: 'https://via.placeholder.com/150',
        images: 'https://i.gojekapi.com/darkroom/gofood-indonesia/v2/images/uploads/85f21d56-51d4-4281-879c-1d0613e57e6d_brand-image_1624004605367.jpg',
        investmentMin: 200000000,
        investmentMax: 350000000,
        roi: 30.0,
        paybackPeriod: 15,
        rating: 4.7,
        totalOutlets: 300,
        foundedYear: '2016',
        isRecommended: true,
        isVerified: true,
        trustScore: 88,
        riskPrediction: 'Low',
      ),
      FranchiseModel(
        id: '3',
        name: 'Miniso',
        category: 'Retail',
        description: 'Japanese lifestyle and creative product store',
        logoUrl: 'https://via.placeholder.com/150',
        images: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTQf5YGt3ogmHYuvfZKXPmyRmKj40kQkV5YIQ&s',
        investmentMin: 300000000,
        investmentMax: 500000000,
        roi: 20.0,
        paybackPeriod: 24,
        rating: 4.3,
        totalOutlets: 200,
        foundedYear: '2013',
        isRecommended: false,
        trustScore: 75,
        riskPrediction: 'Medium',
      ),
      FranchiseModel(
        id: '4',
        name: 'Indomaret',
        category: 'Retail',
        description: 'Convenience store chain',
        logoUrl: 'https://via.placeholder.com/150',
        images: 'https://yt3.googleusercontent.com/8_CaEu3_Cj4PdYU33I32-JhIeN8jjnEukwFpYGX314hjPbTP6RYoTaaf1voBhYuTqlIvIAtK=s900-c-k-c0x00ffffff-no-rj',
        investmentMin: 350000000,
        investmentMax: 500000000,
        roi: 18.5,
        paybackPeriod: 30,
        rating: 4.2,
        totalOutlets: 18000,
        foundedYear: '1988',
        isRecommended: false,
        trustScore: 96,
        riskPrediction: 'Low',
      ),
      FranchiseModel(
        id: '5',
        name: 'Richeese Factory',
        category: 'F&B',
        description: 'Fast food restaurant specializing in chicken and cheese',
        logoUrl: 'https://via.placeholder.com/150',
        images: 'https://upload.wikimedia.org/wikipedia/commons/a/a2/Richeese_Factory_Logo.jpg',
        investmentMin: 400000000,
        investmentMax: 600000000,
        roi: 22.0,
        paybackPeriod: 20,
        rating: 4.4,
        totalOutlets: 150,
        foundedYear: '2006',
        isRecommended: true,
        isVerified: true,
        trustScore: 85,
        riskPrediction: 'Medium',
      ),
    ];
  }
}