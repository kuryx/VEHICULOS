import 'package:flutter/material.dart';
import '../modelos/vehiculo.dart';
 
/// Pantalla P-05 — Mantenimientos.
///
/// Recibe un [Vehiculo] del modelo de datos (lib/modelos/vehiculo.dart).
/// Para cada [ItemMantenimiento] del vehículo, esta pantalla calcula:
///  - cuántos km faltan y qué porcentaje de vida útil queda,
///  - si el ítem ya venció por km o por fecha (RN-01: vence lo que se
///    cumpla primero),
///  - una fecha estimada de vencimiento usando el promedio de km por día
///    del vehículo (RN-06).
///
/// El historial de mantenimientos realizados (entidad MantenimientoRealizado
/// de la sección 9) todavía no está en vehiculo.dart, así que se recibe
/// como lista opcional mientras se agrega al modelo compartido.

class Mantenimientos extends StatefulWidget {
  final Vehiculo vehiculo;
  final List<Map<String, dynamic>> historial;
 
  const Mantenimientos({
    super.key,
    required this.vehiculo,
    this.historial = const [],
  });
 
  @override
  State<Mantenimientos> createState() => _MantenimientosState();
}
 
class _EstadoItem {
  final int kmRestantes;
  final double progreso; // 0.0 a 1.0 = vida útil restante
  final String estado; // 'ok' | 'proximo' | 'vencido'
  final DateTime fechaEstimada;
 
  _EstadoItem({
    required this.kmRestantes,
    required this.progreso,
    required this.estado,
    required this.fechaEstimada,
  });
}
 
class _MantenimientosState extends State<Mantenimientos> {
  static const Color azulPrincipal = Color(0xFF0D4A8F);
  static const Color rojoUrgente = Color(0xFFD32F2F);
 
  @override
  Widget build(BuildContext context) {
    final Vehiculo v = widget.vehiculo;
 
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('${v.marca} ${v.modelo} · ${v.placa}',
            style: const TextStyle(color: Colors.black87)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ...List.generate(v.items.length, (index) {
            final item = v.items[index];
            final estado = _calcularEstado(v, item);
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: _tarjetaItem(item, estado, index),
            );
          }),
          if (widget.historial.isNotEmpty) _tarjetaHistorial(widget.historial),
        ],
      ),
    );
  }
 
  /// RN-01, RN-06: estado, porcentaje restante y fecha estimada de un ítem.
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
 
    // RN-06: promedio de km/día desde la última actualización del ítem.
    final int diasTranscurridos =
        v.fechaKm.difference(item.ultimaFecha).inDays;
    final double promedioKmDia =
        diasTranscurridos > 0 ? kmConsumidos / diasTranscurridos : 0;
 
    DateTime fechaEstimadaPorKm = fechaVenceMeses;
    if (promedioKmDia > 0 && kmRestantes > 0) {
      fechaEstimadaPorKm =
          v.fechaKm.add(Duration(days: (kmRestantes / promedioKmDia).round()));
    }
    // Vence lo que ocurra primero (RN-01).
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
        return 'Bien';
    }
  }
 
  String _formatearFecha(DateTime f) {
    const meses = [
      'ene', 'feb', 'mar', 'abr', 'may', 'jun',
      'jul', 'ago', 'sep', 'oct', 'nov', 'dic',
    ];
    return '${f.day} ${meses[f.month - 1]} ${f.year}';
  }
 
  /// RN-05: al marcar como hecho, el ítem reinicia su contador desde el
  /// kilometraje actual del vehículo y la fecha de hoy.
  void _marcarComoHecho(int index) {
    setState(() {
      final anterior = widget.vehiculo.items[index];
      widget.vehiculo.items[index] = ItemMantenimiento(
        nombre: anterior.nombre,
        intervaloKm: anterior.intervaloKm,
        intervaloMeses: anterior.intervaloMeses,
        ultimoKm: widget.vehiculo.kmActual,
        ultimaFecha: DateTime.now(),
      );
    });
  }
 
  Widget _tarjetaItem(ItemMantenimiento item, _EstadoItem est, int index) {
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
                child: Icon(Icons.build_circle, color: _colorEstado(est.estado)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  item.nombre.toUpperCase(),
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
          Text('${(est.progreso * 100).round()}%',
              style:
                  const TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
          Text('Vida útil restante', style: TextStyle(color: Colors.grey[600])),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: est.progreso,
              minHeight: 8,
              backgroundColor: Colors.grey[200],
              color: _colorEstado(est.estado),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Último: ${item.ultimoKm} km'),
              Text('Próximo: ${item.ultimoKm + item.intervaloKm} km'),
            ],
          ),
          const SizedBox(height: 4),
          Text('Estimado: ${_formatearFecha(est.fechaEstimada)}',
              style: TextStyle(color: Colors.grey[600], fontSize: 12)),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                side: BorderSide(color: Colors.grey[300]!),
              ),
              onPressed: () => _marcarComoHecho(index),
              icon: const Icon(Icons.add, color: azulPrincipal),
              label: const Text('Registrar nuevo',
                  style: TextStyle(color: azulPrincipal)),
            ),
          ),
        ],
      ),
    );
  }
 
  Widget _tarjetaHistorial(List<Map<String, dynamic>> historial) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text('Historial de servicio',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
          const Divider(height: 1),
          ...historial.map((h) => Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: azulPrincipal,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(h['icono'] ?? Icons.build,
                              color: Colors.white),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(h['nombre'] ?? '',
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold)),
                                  ),
                                  Text(h['km'] ?? '',
                                      style: TextStyle(
                                          color: Colors.grey[600],
                                          fontFamily: 'monospace')),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(h['detalle'] ?? '',
                                  style: TextStyle(color: Colors.grey[700])),
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  const Icon(Icons.calendar_today, size: 14),
                                  const SizedBox(width: 4),
                                  Text(h['fecha'] ?? '',
                                      style:
                                          TextStyle(color: Colors.grey[600])),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 1),
                ],
              )),
        ],
      ),
    );
  }
}