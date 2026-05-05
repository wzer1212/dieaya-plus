class ApiConstants {
  static  String  baseUrl = 'https://admin.dieaya-plus.com/api';

  // Settings endpoints
  static  String get aboutUs => '$baseUrl/market/settings/about_us';
  static  String get privacyPolicy => '$baseUrl/market/settings/privacy_policy';

  // Auth
  static  String get login => '$baseUrl/market/login';
  static  String get register => '$baseUrl/market/register';
  static  String get sendOTP => '$baseUrl/market/send_otp';
  static  String get verifyOTP => '$baseUrl/market/verify_otp';

  // Account
  static  String get deleteAccount => '$baseUrl/market/delete_market';
  static  String get profile => '$baseUrl/market/profile';
  static  String get updateProfile => '$baseUrl/market/update_profile';
  static  String get logout => '$baseUrl/market/logout';



  // subscription
  static  String get subscriptionUsage => '$baseUrl/market/package_usage';

  // Offers
  static  String get storeOffer => '$baseUrl/market/offer/store';
  static  String get updateOffer => '$baseUrl/market/offer/update';
  static  String get destroyOffer => '$baseUrl/market/offer/destroy';
  static  String get getOfferBanners => '$baseUrl/market/offer/get_banners';

  // Products
  static  String get storeProduct => '$baseUrl/market/product/store';
  static  String get updateProduct => '$baseUrl/market/product/update';
  static  String get destroyProduct => '$baseUrl/market/product/destroy';
  static  String get deleteProductImage => '$baseUrl/market/product/delete_image';
  static  String get getProductsList => '$baseUrl/market/product/get_products';

  // Home
  static  String get home => '$baseUrl/market/home';

  // Notifications
  static  String get notification => '$baseUrl/market/notification';
  static  String get deleteNotification => '$baseUrl/market/delete/notification';
  static  String get deleteAllNotification => '$baseUrl/market/delete-all/notification';

  // Installment
  static  String get getInstallmentWays => '$baseUrl/market/get_installment_ways';

  // Packages
  static  String get packages => '$baseUrl/market/packages';
  static  String get verifyIosReceipt => '$baseUrl/market/verify-ios-receipt';
  static  String get buyPackage => '$baseUrl/market/buy_package';

  // Banners
  static  String get storeBanner => '$baseUrl/market/banner/store';
  static  String get updateBanner => '$baseUrl/market/banner/update';
  static  String get destroyBanner => '$baseUrl/market/banner/destroy';
  static  String get getBannersList => '$baseUrl/market/banner/get_banners';

  // Settings
  static  String get termsConditions => '$baseUrl/market/settings/terms_conditions';

  // Coupons
  static  String get storeCoupon => '$baseUrl/market/coupon/store';
  static  String get updateCoupon => '$baseUrl/market/coupon/update';
  static  String get destroyCoupon => '$baseUrl/market/coupon/destroy';
  static  String get getCoupon => '$baseUrl/market/coupon/get_coupon';

  // Whatsapp
  static  String get addWhatsappCampaign => '$baseUrl/market/add_whatsapp_campaign';

  // Customer (different subdomain - kept as full URL)
  static  String get customerCategories => '$baseUrl/customer/categories/get_categories';

}