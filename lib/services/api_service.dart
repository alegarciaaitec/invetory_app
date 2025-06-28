import 'package:dio/dio.dart';
import 'package:invetory_app/models/usuario_dto.dart';

class ApiService {
  static const String baseUrl = 'https://8wd326v5-3000.use.devtunnels.ms';
  final Dio _dio = Dio();

  Future<List<UsuarioDto>> getUsers() async {
    try {
      final response = await _dio.get(
        '$baseUrl/usuario',
        options: Options(
          receiveTimeout: const Duration(seconds: 5),
          sendTimeout: const Duration(seconds: 5),
        ),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;

        return data.map((json) => UsuarioDto.fromJson(json)).toList();
      } else {
        throw _handleStatusCodeError(response.statusCode);
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw 'Error desconocido: ${e.toString()}';
    }
  }

  String _handleDioError(DioException e) {
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.sendTimeout) {
      return 'Tiempo de espera agotado. Verifique su conexión a internet.';
    } else if (e.type == DioExceptionType.unknown) {
      return 'No se puede conectar al servidor. Verifique su conexión a internet.';
    } else if (e.response != null) {
      return _handleStatusCodeError(e.response!.statusCode);
    }

    return 'Error de conexión: ${e.message}';
  }

  String _handleStatusCodeError(int? statusCode) {
    switch (statusCode) {
      case 404:
        return 'Recurso no encontrado';
      case 500:
        return 'Error interno del servidor';
      case 401:
        return 'No autorizado';
      case 403:
        return 'Acceso prohibido';
      default:
        return 'Error del servidor (código $statusCode)';
    }
  }
}
