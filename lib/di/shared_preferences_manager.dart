import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesManager {

  static SharedPreferencesManager? _instance;
  final SharedPreferences _prefs;

  SharedPreferencesManager(this._prefs);

  static const _hasSeenOnboardingKey = "has_seen_onboarding_key";
  static const _hasSeenTermsnAndConditionsKey = "has_seen_terms_and_conditions_key";
  static const _isLoggedInKey = "is_logged_in_key";

  static const _profilePictureKey = "profile_picture_key";
  static const _nameKey = "name_key";
  static const _phoneNumberKey = "phone_number_key";

  static Future<SharedPreferencesManager> getInstance() async {
    if (_instance == null) {
      final prefs = await SharedPreferences.getInstance();
      _instance = SharedPreferencesManager(prefs);
    }
    return _instance!;
  }

  bool get hasSeenOnboarding => _prefs.getBool(_hasSeenOnboardingKey) ?? false;
  Future<void> setSeenOnboarding(bool value) async => await _prefs.setBool(_hasSeenOnboardingKey, value);

  bool get hasSeenTermsAndConditions => _prefs.getBool(_hasSeenTermsnAndConditionsKey) ?? false;
  Future<void> setSeenTermsAndCondition(bool value) async => await _prefs.setBool(_hasSeenTermsnAndConditionsKey, value);

  bool get isLoggedIn => _prefs.getBool(_isLoggedInKey) ?? false;
  Future<void> setLoggedIn(bool value) async => await _prefs.setBool(_isLoggedInKey, value);

  String get getProfilePicture => _prefs.getString(_profilePictureKey) ?? "";
  Future<void> setProfilePicture(String value) async => await _prefs.setString(_profilePictureKey, value);

  String get getName => _prefs.getString(_nameKey) ?? "";
  Future<void> setName(String value) async => await _prefs.setString(_nameKey, value);

  String get getPhoneNumber => _prefs.getString(_phoneNumberKey) ?? "";
  Future<void> setPhoneNumebr(String value) async => await _prefs.setString(_phoneNumberKey, value);
}