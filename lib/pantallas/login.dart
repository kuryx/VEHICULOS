import 'package:flutter/material.dart';
import 'mis_vehiculos.dart';
import 'taller.dart';
import '../modelos/vehiculo.dart';

class PantallaLogin extends StatefulWidget {
  const PantallaLogin({super.key});

  @override
  State<PantallaLogin> createState() => _PantallaLoginState();
}

class _PantallaLoginState extends State<PantallaLogin> {
  final _correo = TextEditingController();
  final _clave = TextEditingController();
  bool _ocultar = true;

  void _iniciarSesion() {
    if (_correo.text.trim().isEmpty || _clave.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ingrese su correo y contraseña')),
      );
      return;
    }

    Usuario? encontrado;
    for (final Usuario usuario in usuarios) {
      if (usuario.correo == _correo.text.trim() &&
          usuario.clave == _clave.text) {
        encontrado = usuario;
        break;
      }
    }

    if (encontrado == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Correo o contraseña incorrectos')),
      );
      return;
    }

    final Usuario usuario = encontrado;
    if (usuario.rol == 'conductor') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MisVehiculos(correo: usuario.correo),
        ),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Taller(mecanico: usuario)),
      );
    }
  }

  @override
  void dispose() {
    _correo.dispose();
    _clave.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'VEHICULOS',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 32),

              // CORREO
              const Text('Correo', style: TextStyle(color: Colors.grey)),
              const SizedBox(height: 6),
              TextField(
                controller: _correo,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 14,
                  ),
                ),
              ),

              // CONTRASEÑA
              const SizedBox(height: 20),
              const Text('Contraseña', style: TextStyle(color: Colors.grey)),
              const SizedBox(height: 6),
              TextField(
                controller: _clave,
                obscureText: _ocultar,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 14,
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _ocultar ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        _ocultar = !_ocultar;
                      });
                    },
                  ),
                ),
              ),

              // INICIAR SESION
              const SizedBox(height: 28),
              SizedBox(
                height: 46,
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFF1E50C8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: _iniciarSesion,
                  child: const Text('Iniciar sesión'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
