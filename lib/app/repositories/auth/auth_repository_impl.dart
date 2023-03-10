import 'dart:developer';

import 'package:vakinha_burger_mobile/app/core/exeptions/user_notfound_exeption.dart';
import 'package:vakinha_burger_mobile/app/core/rest_client/rest_client.dart';
import 'package:vakinha_burger_mobile/app/models/user_model.dart';

import 'auth_repository.dart';

class AuthRepositoryImp implements AuthRepository {
  final RestClient _restClient;

  AuthRepositoryImp({
    required RestClient restClient,
  }) : _restClient = restClient;

  @override
  Future<UserModel> register(String name, String email, String password) async {
    final result = await _restClient.post(
        '/auth/register', {'name': name, 'email': email, 'password': password});

    if (result.hasError) {
      var message = 'Erro ao registrar usuário';

      if (result.statusCode == 400) {
        message = result.body['error'];
      }

      log(
        message,
        error: result.statusText,
        stackTrace: StackTrace.current,
      );

      throw RestClientExeption(message);
    }

    return login(email, password);
  }

  @override
  Future<UserModel> login(String email, String password) async {
    final result = await _restClient.post(
      '/auth/',
      {'email': email, 'password': password},
    );

    if (result.hasError) {
      if (result.statusCode == 403) {
        log('Usuário ou senha inválidos',
            error: result.statusText, stackTrace: StackTrace.current);

        throw UserNotFoundExeption();
      }

      log('Erro ao autenticar usuário (${result.statusCode})',
          error: result.statusText, stackTrace: StackTrace.current);

      throw RestClientExeption('Erro ao autenticar usuário');
    }

    return UserModel.fromMap(result.body);
  }
}
