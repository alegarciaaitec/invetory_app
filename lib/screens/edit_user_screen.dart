import 'package:flutter/material.dart';
import 'package:invetory_app/models/usuario_dto.dart';

class EditUserScreen extends StatefulWidget {
  final UsuarioDto user;
  const EditUserScreen({super.key, required this.user});

  @override
  State<EditUserScreen> createState() => _EditUserScreenState();
}

class _EditUserScreenState extends State<EditUserScreen> {
  late final _formKey = GlobalKey<FormState>();
  late final TextEditingController _emailController;
  late bool _estado;
  bool _isLoading = false;
  bool _hasChanges = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _emailController = TextEditingController(text: widget.user.email);
    _estado = widget.user.estado!;
    _emailController.addListener(_checkForChanges);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _emailController.removeListener(_checkForChanges);
    _emailController.dispose();
    super.dispose();
  }

  void _checkForChanges() {
    final emailChanged = _emailController.text != widget.user.email;
    final estadoChanged = _estado != widget.user.estado;

    setState(() {
      _hasChanges = emailChanged || estadoChanged;
    });
  }

  Future<void> _submit() async {}

  void _showNoChangeDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Sin cambios'),
            content: Text('No se han realizado modificaciones en los datos.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Aceptar'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Volver'),
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
            content: Text(
              'No se puede actualizar el usuario:\n${_simplifyErrorMessage(error)}',
              style: TextStyle(color: Colors.red),
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

  String _simplifyErrorMessage(String error) {
    if (error.contains('timeout')) return 'Tiempo de espera agotado';
    if (error.contains('connection')) return 'Error de conexion';
    if (error.contains('404')) return 'Recurso no encontrado';
    if (error.contains('500')) return 'Error interno del servidor';
    return error;
  }

  @override
  Widget build(BuildContext context) {
    final bool isActive = widget.user.estado!;

    return Scaffold(
      appBar: AppBar(
        title: Text('Editar Usuario'),
        leading: IconButton(
          onPressed: _isLoading ? null : () => Navigator.pop(context),
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
                onChanged: (value) => _checkForChanges,
              ),
              const SizedBox(height: 20),

              if (!isActive) ...[
                SwitchListTile(
                  value: _estado,
                  onChanged: null,
                  title: Text('Activar usuario'),
                ),
              ] else ...[
                ListTile(
                  leading: Icon(Icons.check_circle, color: Colors.green),
                  title: Text('Estado del usuario'),
                  subtitle: Text('Activo'),
                  trailing: Icon(Icons.lock, color: Colors.grey),
                ),
              ],

              SizedBox(height: 30),
              ElevatedButton(
                onPressed: null,
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: _hasChanges ? null : Colors.grey,
                ),
                child:
                    _isLoading
                        ? SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(),
                        )
                        : Text(
                          _hasChanges ? 'Actualizar Usuario' : 'Sin Cambios',
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
