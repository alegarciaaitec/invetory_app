import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:invetory_app/providers/user_provider.dart';
import 'package:invetory_app/widgets/user_card.dart';
import 'package:provider/provider.dart';

class UserListScreen extends StatefulWidget {
  const UserListScreen({super.key});

  @override
  State<UserListScreen> createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => _loadUsers());
  }

  Future<void> _loadUsers() async {
    await Provider.of<UserProvider>(context, listen: false).fetchUsers();
  }

  void _addUser() {
    context.push('/add-user');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Usuarios'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: _loadUsers,
          ),
        ],
      ),
      body: Consumer<UserProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.error != null) {
            return _builErrorScreen(provider.error!);
          }

          if (provider.users.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'No hay usuarios registrados',
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: () {},
                    label: Text('Agregar primer usuario'),
                    icon: Icon(Icons.add_rounded),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: _loadUsers,
            color: Colors.blue,
            child: ListView.builder(
              itemCount: provider.users.length,
              itemBuilder: (context, index) {
                final user = provider.users[index];

                return GestureDetector(
                  onTap: () {
                    context.push('/edit-user', extra: user);
                  },
                  child: user.estado!
                   ? Dismissible(
                    key: Key(user.id.toString()),
                    direction: DismissDirection.endToStart,
                    background: Container(
                      color: Colors.red,
                      alignment: Alignment.centerRight,
                      padding: EdgeInsets.only(right: 20),
                      child: Icon(
                        Icons.block_rounded,
                        color: Colors.white,
                        size: 36,
                      ),
                    ),
                    confirmDismiss:
                        (direction) =>
                            _confirmDeactivation(context, user.email),
                    onDismissed:
                        (direction) => _handleDeactivation(context, user.id!),
                    child: UserCard(user: user),
                  )
                   : UserCard(user: user)
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addUser,
        child: Icon(Icons.add_rounded),
      ),
    );
  }

  Future<bool?> _confirmDeactivation(BuildContext context, String email) async {
    return await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => AlertDialog(
            title: Text('Desactivar Usuario'),
            content: Text('¿Esta seguro que desea desactivar a $email?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text('Cancelar'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: Text('Desactivar', style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
    );
  }

  void _handleDeactivation(BuildContext context, int userId) {
    final provider = Provider.of<UserProvider>(context, listen: false);
    provider.deleteUser(userId);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Usuario desactivado exitosamente'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  Widget _builErrorScreen(String error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.wifi_off_rounded, color: Colors.orange, size: 48),
            SizedBox(height: 16),
            Text(
              error,
              style: TextStyle(fontSize: 16, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _loadUsers,
              icon: Icon(Icons.refresh_rounded),
              label: Text('Reintentar conexión'),
            ),
            SizedBox(height: 10),
            OutlinedButton.icon(
              onPressed: () => _showErrorDetails(error),
              icon: Icon(Icons.info_outline_rounded),
              label: Text('Ver detalles técnicos'),
            ),
          ],
        ),
      ),
    );
  }

  void _showErrorDetails(String error) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Detalles del error'),
            content: SingleChildScrollView(child: Text(error)),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Cerrar'),
              ),
            ],
          ),
    );
  }
}
