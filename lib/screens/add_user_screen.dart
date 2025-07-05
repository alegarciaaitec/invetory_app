import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:invetory_app/models/usuario_dto.dart';
import 'package:invetory_app/providers/user_provider.dart';
import 'package:provider/provider.dart';

class AddUserScreen extends StatefulWidget {
  const AddUserScreen({super.key});

  @override
  State<AddUserScreen> createState() => _AddUserScreenState();
}

class _AddUserScreenState extends State<AddUserScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    try {
      final newUser = UsuarioDto(
        email: _emailController.text,
        password: _passwordController.text,
      );

      await Provider.of<UserProvider>(
        context,
        listen: false,
      ).createUser(newUser);

      if (mounted) {
        _showSuccessDialog();
      }
    } catch (e) {
      if (mounted) {
        _showErrorDialog(e.toString());
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => AlertDialog(
            title: Row(
              children: [
                Icon(Icons.check_circle_rounded, color: Colors.green),
                SizedBox(width: 10),
                Text('Exito'),
              ],
            ),
            content: Text('Usuario creado exitosamente.'),
            actions: [
              TextButton(
                onPressed: () {
                  context.pop();
                  context.pop();
                  Provider.of<UserProvider>(
                    context,
                    listen: false,
                  ).fetchUsers();
                },
                child: Text('OK'),
              ),
            ],
          ),
    );
  }

  void _showErrorDialog(String error) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Row(
              children: [
                Icon(Icons.error_outline_rounded, color: Colors.red),
                SizedBox(width: 10),
                Text('Error'),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('No se puede crear el usuario:'),
                SizedBox(height: 10),
                Text(
                  _simplifyErrorMesssage(error),
                  style: TextStyle(color: Colors.red),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Aceptar'),
              ),
            ],
          ),
    );
  }

  String _simplifyErrorMesssage(String error) {
    if (error.contains('timeout')) return 'Tiempo de espera agotado';
    if (error.contains('connection')) return 'Error de conexion';
    if (error.contains('404')) return 'Recurso no encontrado';
    if (error.contains('500')) return 'Error interno del servidor';
    return error;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Agregar Usuario'),
        leading: IconButton(
          onPressed: _isLoading ? null : () => context.pop(),
          icon: Icon(Icons.arrow_back_rounded),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Correo Electronico',
                  prefixIcon: Icon(Icons.email_rounded),
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese un correo';
                  }
                  if (!value.contains('@')) {
                    return 'Ingrese un correo valido';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  prefixIcon: Icon(Icons.lock_rounded),
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese una contraseña';
                  }
                  if (value.length < 6) {
                    return 'La contraseña debe tener al menos 6 caracteres';
                  }
                  return null;
                },
              ),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: _isLoading ? null : _submit,
                child:
                    _isLoading
                        ? SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(),
                        )
                        : Text(
                          'Guardar Usuario',
                          style: TextStyle(fontSize: 16),
                        ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
