class LocationData {
  final String city;
  final String areaType;
  final String trafficPotential; // Rendah, Sedang, Tinggi, Sangat Tinggi
  final int competitionScore; // 1-10
  final String rentRange;
  final List<String> bestCategories;
  final String peakHours;
  final int baseScore;

  LocationData({
    required this.city,
    required this.areaType,
    required this.trafficPotential,
    required this.competitionScore,
    required this.rentRange,
    required this.bestCategories,
    required this.peakHours,
    required this.baseScore,
  });

  static Map<String, Map<String, LocationData>> get mockData {
    final cities = ['Jakarta', 'Surabaya', 'Medan', 'Semarang', 'Malang'];
    final areas = ['Pusat Kota', 'Perumahan', 'Kampus', 'Perkantoran', 'Mall'];
    
    final Map<String, Map<String, LocationData>> data = {};
    
    for (var city in cities) {
      data[city] = {};
      for (var area in areas) {
        // Generating varied mock data based on area type
        int base = 70;
        String traffic = 'Sedang';
        int comp = 5;
        String rent = 'Rp 50jt - 100jt/tahun';
        List<String> cats = ['F&B', 'Retail'];
        String peak = 'Siang - Sore';

        if (area == 'Pusat Kota') {
          base = 85; traffic = 'Sangat Tinggi'; comp = 9; rent = 'Rp 150jt - 300jt/tahun'; cats = ['F&B', 'Jasa', 'Retail']; peak = 'Siang - Malam';
        } else if (area == 'Perumahan') {
          base = 75; traffic = 'Sedang'; comp = 4; rent = 'Rp 30jt - 70jt/tahun'; cats = ['F&B (Delivery)', 'Laundry', 'Minimarket']; peak = 'Pagi & Sore';
        } else if (area == 'Kampus') {
          base = 80; traffic = 'Tinggi'; comp = 8; rent = 'Rp 40jt - 90jt/tahun'; cats = ['F&B (Murah)', 'Print/Fotokopi', 'Cafe']; peak = 'Siang - Sore';
        } else if (area == 'Perkantoran') {
          base = 78; traffic = 'Tinggi'; comp = 7; rent = 'Rp 100jt - 200jt/tahun'; cats = ['F&B (Cepat Saji)', 'Kopi', 'Retail']; peak = 'Pagi & Jam Makan Siang';
        } else if (area == 'Mall') {
          base = 90; traffic = 'Sangat Tinggi'; comp = 10; rent = 'Rp 200jt - 500jt/tahun'; cats = ['F&B Premium', 'Retail Fashion', 'Hiburan']; peak = 'Weekend & Malam Hari';
        }

        // Slight variation by city
        if (city == 'Jakarta') { base += 5; comp += 1; }
        if (city == 'Malang') { base -= 2; rent = rent.replaceAll('jt', 'jt (estimasi lokal)'); }

        data[city]![area] = LocationData(
          city: city,
          areaType: area,
          trafficPotential: traffic,
          competitionScore: comp > 10 ? 10 : comp,
          rentRange: rent,
          bestCategories: cats,
          peakHours: peak,
          baseScore: base > 100 ? 100 : base,
        );
      }
    }
    return data;
  }
}
