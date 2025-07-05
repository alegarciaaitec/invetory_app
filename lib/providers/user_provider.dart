import 'package:flutter/material.dart';
import 'package:invetory_app/models/usuario_dto.dart';
import 'package:invetory_app/services/api_service.dart';

class UserProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  List<UsuarioDto> _users = [];
  bool _isloading = false;
  String? _error;

  List<UsuarioDto> get users => _users;
  bool get isLoading => _isloading;
  String? get error => _error;

  Future<void> fetchUsers() async {
    _isloading = true;
    _error = null;
    notifyListeners();

    try {
      _users = await _apiService.getUsers();
    } catch (e) {
      _error = e.toString();

      if (e.toString().contains('conexión') ||
          e.toString().contains('conectar') ||
          e.toString().contains('espera')) {
        _error =
            "No se puede conectar al servidor. Verifique su conexión a internet.";
      }
    } finally {
      _isloading = false;
      notifyListeners();
    }
  }

  Future<void> createUser(UsuarioDto user) async {
    try {
      await _apiService.createUser(user);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteUser(int userId) async {
    int userIndex = -1;
    UsuarioDto? originalUser;

    try {
      userIndex = _users.indexWhere((user) => user.id == userId);
      if (userIndex == -1) return;

      originalUser = _users[userIndex];

      _users[userIndex] = originalUser.copyWith(estado: false);
      notifyListeners();

      await _apiService.deleteUser(userId);
    } catch (e) {
      if (originalUser != null && userIndex != -1) {
        _users[userIndex] = originalUser;
        notifyListeners();
      }

      rethrow;
    }
  }
}
