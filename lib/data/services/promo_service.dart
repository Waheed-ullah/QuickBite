// import 'package:quickbite/data/models/promo_model.dart';

// class PromoService {
//   static final Map<String, PromoCode> availablePromoCodes = {
//     'SAVE50': PromoCode(
//       code: 'SAVE50',
//       description: 'Get ₹50 off on orders above ₹700',
//       discountAmount: 50,
//       minOrderAmount: 700,
//     ),
//     'FIRST100': PromoCode(
//       code: 'FIRST100',
//       description: 'Get ₹100 off on your first order',
//       discountAmount: 100,
//       isFirstOrderOnly: true,
//     ),
//     'QUICK20': PromoCode(
//       code: 'QUICK20',
//       description: 'Get 20% off up to ₹100',
//       discountAmount: 20,
//       isPercentage: true,
//       minOrderAmount: 500,
//     ),
//   };

//   static PromoCode? validatePromoCode(
//     String code,
//     double orderAmount,
//     bool isFirstOrder,
//   ) {
//     final promoCode = availablePromoCodes[code.toUpperCase()];

//     if (promoCode == null) {
//       return null;
//     }

//     if (!promoCode.isValidForOrder(orderAmount, isFirstOrder)) {
//       return null;
//     }

//     return promoCode;
//   }

//   static double calculateDiscount(
//     String code,
//     double orderAmount,
//     bool isFirstOrder,
//   ) {
//     final promoCode = validatePromoCode(code, orderAmount, isFirstOrder);

//     if (promoCode == null) {
//       return 0;
//     }

//     return promoCode.calculateDiscount(orderAmount);
//   }
// }
