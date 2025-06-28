import 'package:flutter/material.dart';
import 'package:invetory_app/models/usuario_dto.dart';

class UserCard extends StatelessWidget {
  final UsuarioDto user;
  const UserCard({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final bool isActive = user.estado!;
    final Color cardColor = isActive ? Colors.white : Colors.grey[200]!;
    final Color contentColor = isActive ? Colors.black87 : Colors.grey;

    return Card(
      color: cardColor,
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: isActive ? Colors.blue : Colors.grey,
              child: Icon(Icons.person_rounded, color: Colors.white),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user.email!,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: contentColor,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Registrado: ${_formatDate(user.createdAt!)}',
                    style: TextStyle(color: contentColor),
                  ),
                ],
              ),
            ),
            Icon(
              isActive ? Icons.check_circle_rounded : Icons.block_rounded,
              color: isActive ? Colors.green : Colors.red,
              size: 28,
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}";
  }
}
