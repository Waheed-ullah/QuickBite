class DeliveryService {
  static const Map<String, double> zoneFees = {
    'Urban': 20,
    'Suburban': 30,
    'Remote': 50,
  };

  static double calculateDeliveryFee(List<String> zones) {
    if (zones.isEmpty) return 0;

    // Get the highest fee among all zones in cart
    double maxFee = 0;
    for (var zone in zones) {
      final fee = zoneFees[zone] ?? 0;
      if (fee > maxFee) {
        maxFee = fee;
      }
    }
    return maxFee;
  }

  static String getZoneDescription(String zone) {
    switch (zone) {
      case 'Urban':
        return 'Urban (Delivery fee: ₹20)';
      case 'Suburban':
        return 'Suburban (Delivery fee: ₹30)';
      case 'Remote':
        return 'Remote (Delivery fee: ₹50)';
      default:
        return zone;
    }
  }
}
