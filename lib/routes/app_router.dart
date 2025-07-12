import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:invetory_app/models/usuario_dto.dart';
import 'package:invetory_app/screens/add_user_screen.dart';
import 'package:invetory_app/screens/edit_user_screen.dart';
import 'package:invetory_app/screens/user_list_screen.dart';

class AppRouter {
  static final router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => UserListScreen(),
        routes: [
          GoRoute(
            path: 'add-user',
            builder: (context, state) => AddUserScreen(),
          ),
          GoRoute(
            path: 'edit-user',
            builder: (context, state) {
              final user = state.extra as UsuarioDto;
              return EditUserScreen(user: user);
            },
          ),
        ],
      ),
    ],
    errorBuilder:
        (context, state) =>
            Scaffold(body: Center(child: Text('Error: ${state.error}'))),
  );
}
