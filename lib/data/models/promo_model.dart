class PromoCode {
  final String code;
  final String description;
  final double discountAmount;
  final double? minOrderAmount;
  final bool isPercentage;
  final bool isFirstOrderOnly;
  final DateTime? validUntil;

  PromoCode({
    required this.code,
    required this.description,
    required this.discountAmount,
    this.minOrderAmount,
    this.isPercentage = false,
    this.isFirstOrderOnly = false,
    this.validUntil,
  });

  bool isValidForOrder(double orderAmount, bool isFirstOrder) {
    if (validUntil != null && DateTime.now().isAfter(validUntil!)) {
      return false;
    }

    if (isFirstOrderOnly && !isFirstOrder) {
      return false;
    }

    if (minOrderAmount != null && orderAmount < minOrderAmount!) {
      return false;
    }

    return true;
  }

  double calculateDiscount(double orderAmount) {
    if (!isValidForOrder(orderAmount, false)) {
      return 0;
    }

    if (isPercentage) {
      return orderAmount * (discountAmount / 100);
    }

    return discountAmount;
  }
}
