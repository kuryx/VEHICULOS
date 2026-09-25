import 'package:flutter/material.dart';

class RegistrarVehiculo extends StatefulWidget {
  const RegistrarVehiculo({super.key});

  @override
  State<RegistrarVehiculo> createState() => _RegistrarVehiculoState();
}

class _RegistrarVehiculoState extends State<RegistrarVehiculo> {
  String _tipo = 'moto';

  final _marca = TextEditingController();
  final _modelo = TextEditingController();
  final _anio = TextEditingController();
  final _placa = TextEditingController();
  final _ciudad = TextEditingController();
  final _km = TextEditingController();

  InputDecoration _decoracion(String etiqueta) {
    return InputDecoration(
      labelText: etiqueta,
      filled: true,
      fillColor: Colors.grey.shade100,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
    );
  }

  void _guardar() {
    if (_marca.text.trim().isEmpty ||
        _modelo.text.trim().isEmpty ||
        _anio.text.trim().isEmpty ||
        _placa.text.trim().isEmpty ||
        _ciudad.text.trim().isEmpty ||
        _km.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Completa todos los campos')),
      );
      return;
    }

    // Por ahora solo vuelve atrás; guardar de verdad viene después.
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _marca.dispose();
    _modelo.dispose();
    _anio.dispose();
    _placa.dispose();
    _ciudad.dispose();
    _km.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registrar vehículo')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          const Text('Tipo de vehículo', style: TextStyle(color: Colors.grey)),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _tipo == 'moto'
                    ? FilledButton(
                        onPressed: () => setState(() => _tipo = 'moto'),
                        child: const Text('Moto'),
                      )
                    : OutlinedButton(
                        onPressed: () => setState(() => _tipo = 'moto'),
                        child: const Text('Moto'),
                      ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _tipo == 'carro'
                    ? FilledButton(
                        onPressed: () => setState(() => _tipo = 'carro'),
                        child: const Text('Carro'),
                      )
                    : OutlinedButton(
                        onPressed: () => setState(() => _tipo = 'carro'),
                        child: const Text('Carro'),
                      ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          TextField(controller: _marca, decoration: _decoracion('Marca')),
          const SizedBox(height: 16),

          TextField(controller: _modelo, decoration: _decoracion('Modelo')),
          const SizedBox(height: 16),

          TextField(
            controller: _anio,
            decoration: _decoracion('Año'),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 16),

          TextField(controller: _placa, decoration: _decoracion('Placa')),
          const SizedBox(height: 16),

          TextField(controller: _ciudad, decoration: _decoracion('Ciudad')),
          const SizedBox(height: 16),

          TextField(
            controller: _km,
            decoration: _decoracion('Kilometraje actual'),
            keyboardType: TextInputType.number,
          ),
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
              onPressed: _guardar,
              child: const Text('Guardar'),
            ),
          ),
        ],
      ),
    );
  }
}
