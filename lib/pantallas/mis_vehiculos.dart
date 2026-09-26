import 'package:flutter/material.dart';
import 'package:vehiculos/modelos/vehiculo.dart';
import 'package:vehiculos/pantallas/panel_vehiculo.dart';
import 'package:vehiculos/pantallas/registrar_vehiculo.dart';
import 'package:vehiculos/widgets/tarjeta_vehiculo.dart';

class MisVehiculos extends StatelessWidget {
  const MisVehiculos({super.key, required this.correo});

  final String correo;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis vehículos'),
        automaticallyImplyLeading: false,
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cerrar sesión'),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'Hola, $correo',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: vehiculos.length,
              itemBuilder: (context, index) {
                final vehiculo = vehiculos[index];
                return TarjetaVehiculo(
                  vehiculo: vehiculo,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PanelVehiculo(vehiculo: vehiculo),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const RegistrarVehiculo()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
