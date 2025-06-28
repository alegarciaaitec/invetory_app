import 'package:flutter/material.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Usuarios'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: () => _loadUsers,
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
              itemBuilder: (context, index) =>
                  UserCard(user: provider.users[index]),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.add_rounded),
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
      builder: (context) => AlertDialog(
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
