class AppConfig {
  // Backend API URL
  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://localhost:5000/api',
  );

  // Mapbox Public Access Token
  static const String mapboxAccessToken = String.fromEnvironment(
    'MAPBOX_TOKEN',
    defaultValue: 'pk.eyJ1IjoicGF2YW5rdW1hcnN3YW15IiwiYSI6ImNtNnc1c3ZpdTBkdGgyanM5b25rN2ZqcncifQ',
  );

  // Razorpay Key
  static const String razorpayKeyId = 'rzp_live_StBUehIpeULYuL';

  // Agora WebRTC App ID
  static const String agoraAppId = '7c9641fb497543d2b01fe6fe5fe0af15';

  // Firebase Configuration (Web & Mobile)
  static const String firebaseApiKey = 'AIzaSyCU7Psyt8Rl5kQScIDAavvleuyNjkhVFxo';
  static const String firebaseAuthDomain = 'healthexpress-1.firebaseapp.com';
  static const String firebaseProjectId = 'healthexpress-1';
  static const String firebaseStorageBucket = 'healthexpress-1.firebasestorage.app';
  static const String firebaseMessagingSenderId = '575738669292';
  static const String firebaseAppId = '1:575738669292:web:305a1fce4415b605c3ddc9';
  static const String firebaseMeasurementId = 'G-11RHHGM6T0';
}
