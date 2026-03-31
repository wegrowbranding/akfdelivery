class ApiConstants {
  static const String baseUrl =
      'https://wegrowbranding.com/akflowers/public/api/v1/delivery-app';
  static String storageUrl(int id) =>
      'https://wegrowbranding.com/akflowers/public/api/v1/media/$id/view';

  static const String login = '/login';
  static const String dashboard = '/dashboard';
  static const String updateAvailability = '/update-availability';
  static const String updateOrderStatus = '/update-order-status';
  static const String confirmDeliveryPhoto = '/confirm-delivery-photo';
  static String orderDetails(int id) => '/orders/$id';
  static const String updateTracking = '/update-tracking';
  static const String orderHistory = '/order-history';

  // Auth/Profile related
  static const String profile = '/profile'; // Note: check if needed in routes
  static const String logout = '/logout';
}
