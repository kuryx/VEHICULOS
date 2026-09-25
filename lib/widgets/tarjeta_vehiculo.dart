import 'package:flutter/material.dart';
import 'package:vehiculos/modelos/vehiculo.dart';

class TarjetaVehiculo extends StatelessWidget {
  const TarjetaVehiculo({
    super.key,
    required this.vehiculo,
    required this.onTap,
  });

  final Vehiculo vehiculo;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        title: Text(vehiculo.placa),
        subtitle: Text('${vehiculo.marca} ${vehiculo.modelo}'),
        trailing: Text('${vehiculo.kmActual} km'),
        onTap: onTap,
      ),
    );
  }
}
