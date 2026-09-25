import 'package:flutter/material.dart';
import '../modelos/vehiculo.dart';
 
/// Pantalla P-06 — Taller.
///
/// Usa las listas fijas `usuarios` y `vehiculos` de lib/modelos/vehiculo.dart.
/// Por defecto toma el primer Usuario con rol 'mecanico' y todos los
/// vehículos registrados (el modelo aún no vincula un vehículo a un taller
/// específico, así que por ahora se muestran todos).
///
/// Para cada vehículo calcula, con la misma lógica de RN-01/RN-06 que la
/// pantalla de Mantenimientos, cuál es su ítem más urgente, y permite
/// registrar un mantenimiento hecho (RN-05), que reinicia ese ítem.
class Taller extends StatefulWidget {
  final Usuario mecanico;
  final List<Vehiculo> vehiculosAtendidos;
 
  Taller({super.key, Usuario? mecanico, List<Vehiculo>? vehiculosAtendidos})
      : mecanico =
            mecanico ?? usuarios.firstWhere((u) => u.rol == 'mecanico'),
        vehiculosAtendidos = vehiculosAtendidos ?? vehiculos;
 
  @override
  State<Taller> createState() => _TallerState();
}
 
class _EstadoItem {
  final int kmRestantes;
  final double progreso;
  final String estado; // 'ok' | 'proximo' | 'vencido'
  final DateTime fechaEstimada;
 
  _EstadoItem({
    required this.kmRestantes,
    required this.progreso,
    required this.estado,
    required this.fechaEstimada,
  });
}
 
class _TallerState extends State<Taller> {
  static const Color azulPrincipal = Color(0xFF0D4A8F);
  static const Color rojoUrgente = Color(0xFFD32F2F);
 
  String filtro = '';
  String? itemSeleccionado;
  final TextEditingController kmController = TextEditingController();
 
  /// Misma fórmula de RN-01/RN-06 usada en la pantalla de Mantenimientos.
  _EstadoItem _calcularEstado(Vehiculo v, ItemMantenimiento item) {
    final int kmConsumidos = v.kmActual - item.ultimoKm;
    final int kmRestantes = item.intervaloKm - kmConsumidos;
    final DateTime fechaVenceMeses = DateTime(
      item.ultimaFecha.year,
      item.ultimaFecha.month + item.intervaloMeses,
      item.ultimaFecha.day,
    );
    final DateTime hoy = DateTime.now();
    final bool vencidoPorKm = kmRestantes <= 0;
    final bool vencidoPorFecha = !hoy.isBefore(fechaVenceMeses);
 
    final int diasTranscurridos =
        v.fechaKm.difference(item.ultimaFecha).inDays;
    final double promedioKmDia =
        diasTranscurridos > 0 ? kmConsumidos / diasTranscurridos : 0;
    DateTime fechaEstimadaPorKm = fechaVenceMeses;
    if (promedioKmDia > 0 && kmRestantes > 0) {
      fechaEstimadaPorKm =
          v.fechaKm.add(Duration(days: (kmRestantes / promedioKmDia).round()));
    }
    final DateTime fechaEstimada = fechaEstimadaPorKm.isBefore(fechaVenceMeses)
        ? fechaEstimadaPorKm
        : fechaVenceMeses;
 
    double progreso = kmRestantes / item.intervaloKm;
    if (progreso < 0) progreso = 0;
    if (progreso > 1) progreso = 1;
 
    String estado;
    if (vencidoPorKm || vencidoPorFecha) {
      estado = 'vencido';
    } else if (progreso <= 0.15 || fechaEstimada.difference(hoy).inDays <= 30) {
      estado = 'proximo';
    } else {
      estado = 'ok';
    }
 
    return _EstadoItem(
      kmRestantes: kmRestantes < 0 ? 0 : kmRestantes,
      progreso: progreso,
      estado: estado,
      fechaEstimada: fechaEstimada,
    );
  }
 
  /// El ítem más urgente de un vehículo: primero busca uno vencido, luego
  /// uno próximo; si no hay ninguno, devuelve el de menor porcentaje restante.
  MapEntry<ItemMantenimiento, _EstadoItem> _itemMasUrgente(Vehiculo v) {
    final calculados = v.items
        .map((item) => MapEntry(item, _calcularEstado(v, item)))
        .toList();
    calculados.sort((a, b) => a.value.progreso.compareTo(b.value.progreso));
    return calculados.first;
  }
 
  Color _colorEstado(String estado) {
    switch (estado) {
      case 'vencido':
      case 'proximo':
        return rojoUrgente;
      default:
        return azulPrincipal;
    }
  }
 
  String _textoPill(String estado) {
    switch (estado) {
      case 'vencido':
        return 'Vencido';
      case 'proximo':
        return 'Próximo';
      default:
        return 'Al día';
    }
  }
 
  void _abrirFormulario(Vehiculo vehiculo) {
    itemSeleccionado = null;
    kmController.text = vehiculo.kmActual.toString();
 
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 20,
                bottom: MediaQuery.of(context).viewInsets.bottom + 20,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${vehiculo.marca} ${vehiculo.modelo} · ${vehiculo.placa}',
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: 'Ítem de mantenimiento',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    value: itemSeleccionado,
                    items: vehiculo.items
                        .map((i) => DropdownMenuItem(
                            value: i.nombre, child: Text(i.nombre)))
                        .toList(),
                    onChanged: (valor) =>
                        setModalState(() => itemSeleccionado = valor),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: kmController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Kilometraje',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    initialValue: widget.mecanico.nombre,
                    readOnly: true,
                    decoration: InputDecoration(
                      labelText: 'Taller',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: azulPrincipal,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      onPressed: itemSeleccionado == null
                          ? null
                          : () => _guardarMantenimiento(vehiculo),
                      child: const Text('Guardar',
                          style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
 
  /// RN-05: reinicia el contador del ítem seleccionado desde el kilometraje
  /// y la fecha que reporta el mecánico.
  void _guardarMantenimiento(Vehiculo vehiculo) {
    final int index =
        vehiculo.items.indexWhere((i) => i.nombre == itemSeleccionado);
    if (index == -1) return;
 
    final anterior = vehiculo.items[index];
    final int kmReportado =
        int.tryParse(kmController.text) ?? vehiculo.kmActual;
 
    setState(() {
      vehiculo.items[index] = ItemMantenimiento(
        nombre: anterior.nombre,
        intervaloKm: anterior.intervaloKm,
        intervaloMeses: anterior.intervaloMeses,
        ultimoKm: kmReportado,
        ultimaFecha: DateTime.now(),
      );
    });
 
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Mantenimiento registrado')),
    );
  }
 
  @override
  Widget build(BuildContext context) {
    final List<Vehiculo> filtrados = widget.vehiculosAtendidos
        .where((v) => v.placa.toLowerCase().contains(filtro.toLowerCase()))
        .toList();
 
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(widget.mecanico.nombre,
            style: const TextStyle(color: Colors.black87)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            decoration: InputDecoration(
              hintText: 'Buscar por placa',
              prefixIcon: const Icon(Icons.search),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
            ),
            onChanged: (valor) => setState(() => filtro = valor),
          ),
          const SizedBox(height: 16),
          ...filtrados.map((v) => Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: _tarjetaVehiculo(v),
              )),
        ],
      ),
    );
  }
 
  Widget _tarjetaVehiculo(Vehiculo vehiculo) {
    final urgente = _itemMasUrgente(vehiculo);
    final item = urgente.key;
    final est = urgente.value;
 
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: _colorEstado(est.estado).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(Icons.two_wheeler, color: _colorEstado(est.estado)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  '${vehiculo.marca} ${vehiculo.modelo} · ${vehiculo.placa}'
                      .toUpperCase(),
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      letterSpacing: 0.5),
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: _colorEstado(est.estado),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(_textoPill(est.estado),
                    style: const TextStyle(color: Colors.white, fontSize: 12)),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text('Próximo ítem sugerido: ${item.nombre}',
              style: TextStyle(color: Colors.grey[700])),
          const SizedBox(height: 4),
          Text('Kilometraje actual: ${vehiculo.kmActual} km',
              style: TextStyle(color: Colors.grey[700])),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                side: BorderSide(color: Colors.grey[300]!),
              ),
              onPressed: () => _abrirFormulario(vehiculo),
              icon: const Icon(Icons.add, color: azulPrincipal),
              label: const Text('Registrar mantenimiento',
                  style: TextStyle(color: azulPrincipal)),
            ),
          ),
        ],
      ),
    );
  }
}