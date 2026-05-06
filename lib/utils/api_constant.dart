import 'package:dieaya_user/config/environment.dart';

class ApiConstants {
  static  String
  baseUrl = Environment.PROD_BASE_URL;
  static  String shareBaseUrl = Environment.PROD_SHARE_BASE_URL;

  // Settings endpoints
  static  String get settingsBase => '$baseUrl/customer/settings';
  static  String get aboutUs => '$settingsBase/about_us';
  static  String get privacyPolicy => '$settingsBase/privacy_policy';
  static  String get termsConditions => '$settingsBase/terms_conditions';

  // Auth
  static  String get login => '$baseUrl/customer/login';
  static  String get register => '$baseUrl/customer/register';
  static  String get sendOTP => '$baseUrl/customer/send_otp';
  static  String get verifyOTP => '$baseUrl/customer/verify_otp';

  // Account
  static  String get deleteAccount => '$baseUrl/customer/delete';
  static  String get profile => '$baseUrl/customer/profile';
  static  String get updateProfile => '$baseUrl/customer/update_profile';
  static  String get logout => '$baseUrl/customer/logout';

  //App
  static  String get getBanners => '$baseUrl/customer/banners/get_banners';
  static  String get getCategories => '$baseUrl/customer/categories/get_categories';
  static  String get getMarketCoupons => '$baseUrl/customer/market_coupons/get_market_coupons';
  static  String get addFav => '$baseUrl/customer/favorite/add_favorite';
  static  String get removeFav => '$baseUrl/customer/favorite/remove_favorite';
  static  String get getFav => '$baseUrl/customer/favorite/get_favorites';

  //Markets
  static  String get bestMarkets => '$baseUrl/customer/markets/get_best_markets';
  static  String get mostViewsMarkets => '$baseUrl/customer/markets/get_most_viewed_markets';
  static  String get marketData => '$baseUrl/customer/markets/get_market_data';
  static  String get marketOffers => '$baseUrl/customer/market_offers/get_market_offers';
  static  String get getProducts => '$baseUrl/customer/products/get_products';
  static  String get marketBanners => '$baseUrl/customer/market_banners/get_market_banners';
  static  String get marketCategoryDetails => '$baseUrl/customer/categories/get_market_and_products_by_category';
  static  String get showCategoryHomeScreen => '$baseUrl/customer/categories/get_home_categories';
  static  String get marketVisit => '$baseUrl/customer/increase_count/market/visitors';
  static  String get marketSurfer => '$baseUrl/customer/increase_count/market/surfer';
  static  String get marketShareIncreaseCount=> '$baseUrl/customer/increase_count/market/share';



  //Splash
  static  String get onBoarding => '$settingsBase/get_splash';

  // products
  static  String get productVisit => '$baseUrl/customer/increase_views_count/product';
  static  String get productDetails => '$baseUrl/customer/products/get_product_details';


  //offers
  static  String get offerVisit => '$baseUrl/customer/increase_views_count/market_offer';
  static  String get offerDetails => '${ApiConstants.baseUrl.replaceAll('/api', "")}/offer-details';




  //coupon
  static  String get couponVisit => '$baseUrl/customer/increase_views_count/market_coupon';

  //notification

  static  String get notification => '$baseUrl/customer/notification';
  static  String get deleteNotification => '$baseUrl/customer/delete/notification';
  static  String get deleteAllNotification => '$baseUrl/customer/delete-all/notification';


}
