import 'package:flutter/widgets.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/http_exception.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

class Authentication with ChangeNotifier {
  String? _token;
  DateTime? _expireyDate;
  String? _userId;
  Timer? _timer;
  bool get isAuthenticated {
    return token != null ? true : false;
  }

  String get userId {
    return _userId!;
  }

  String? get token {
    if (_token != null &&
        _expireyDate != null &&
        _expireyDate!.isAfter(DateTime.now())) {
      return _token;
    }
    return null;
  }

  Future<void> _authenticate(
      String email, String password, String authType) async {
    final uri = Uri.https(
        'identitytoolkit.googleapis.com',
        '/v1/accounts:$authType',
        {'key': 'AIzaSyDFRetIkdXDUmqD9Dt7kbBPRATTLuxfMb0'});

    final response = await http.post(uri,
        body: json.encode(
            {'email': email, 'password': password, 'returnSecureToken': true}));

    final resBod = json.decode(response.body);

    if (resBod['error'] != null) {
      throw HttpException(resBod['error']['message']);
    }

    _token = resBod['idToken'];
    _userId = resBod['localId'];
    _expireyDate =
        DateTime.now().add(Duration(seconds: int.parse(resBod['expiresIn'])));

    setLogout_timer();
    notifyListeners();

    final pref = await SharedPreferences.getInstance();

    final encodedAuthInfo = json.encode({
      'token': _token,
      'userId': _userId,
      'timeToExpiry': _expireyDate!.toIso8601String()
    });
    pref.setString('auth', encodedAuthInfo);
  }

  Future<void> signUp(String email, String password) async {
    return _authenticate(email, password, 'signUp');
  }

  Future<void> logIn(String email, String password) async {
    
    return _authenticate(email, password, 'signInWithPassword');
  }

  Future<void> logout() async {
    _token = '';
    _expireyDate = DateTime.now();
    _userId = '';
    if (_timer != null) {
      _timer!.cancel();
      _timer = null;
    }
    notifyListeners();
    final pref = await SharedPreferences.getInstance();
    // pref.remove('key');

    pref.clear();
  }

  void setLogout_timer() {
    if (_timer != null) {
      _timer!.cancel();
      _timer = null;
    }

    int timeToExpiry = _expireyDate!.difference(DateTime.now()).inMilliseconds;
    _timer = Timer(Duration(milliseconds: timeToExpiry), () {
      logout();
    });
  }

  Future<void> tryAutoLogin() async {
    final pref = await SharedPreferences.getInstance();

    if (pref.containsKey('auth')) {
      final auth = json.decode(pref.getString('auth')!) as Map<String, dynamic>;

      final DateTime expiryDate = DateTime.parse(auth['timeToExpiry']);

      if (expiryDate.isAfter(DateTime.now())) {
        _expireyDate = expiryDate;
        _token = auth['token'];
        _userId = auth['userId'];

        notifyListeners();

        setLogout_timer();
      }
    }
  }
}
