import 'package:flutter/material.dart';
import 'package:vehiculos/modelos/vehiculo.dart';

String formatearFecha(DateTime fecha) {
  final dia = fecha.day.toString().padLeft(2, '0');
  final mes = fecha.month.toString().padLeft(2, '0');
  return '$dia/$mes/${fecha.year}';
}

class PanelVehiculo extends StatelessWidget {
  const PanelVehiculo({super.key, required this.vehiculo});

  final Vehiculo vehiculo;

  @override
  Widget build(BuildContext context) {
    final primerItem = vehiculo.items[0];

    return Scaffold(
      appBar: AppBar(title: Text(vehiculo.placa)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              '${vehiculo.kmActual} km',
              style: Theme.of(context).textTheme.displaySmall,
            ),
            const SizedBox(height: 16),
            Card(
              child: ListTile(
                title: const Text('Próximo mantenimiento'),
                subtitle: Text(
                  '${primerItem.nombre}, cada ${primerItem.intervaloKm} km o ${primerItem.intervaloMeses} meses',
                ),
              ),
            ),
            for (final documento in vehiculo.documentos)
              Card(
                child: ListTile(
                  title: Text(documento.tipo),
                  subtitle: Text(
                    'Vence el ${formatearFecha(documento.fechaVencimiento)}',
                  ),
                ),
              ),
            const SizedBox(height: 16),
            const Text('Pico y placa hoy: consulta la rotación de Medellín'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // TODO: abrir P-05 con Mantenimientos(vehiculo: vehiculo).
              },
              child: const Text('Ver mantenimientos'),
            ),
          ],
        ),
      ),
    );
  }
}
