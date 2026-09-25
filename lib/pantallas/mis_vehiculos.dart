import 'package:flutter/material.dart';
import 'package:vehiculos/modelos/vehiculo.dart';
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
              // TODO: volver a P-01 con Navigator.pop.
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
                    // TODO: abrir P-03 con PanelVehiculo(vehiculo: vehiculo).
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: abrir P-04 para registrar un vehículo.
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
