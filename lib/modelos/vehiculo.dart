class Usuario {
  const Usuario({
    required this.nombre,
    required this.correo,
    required this.clave,
    required this.rol,
  });

  final String nombre;
  final String correo;
  final String clave;
  final String rol;
}

class Documento {
  const Documento({required this.tipo, required this.fechaVencimiento});

  final String tipo;
  final DateTime fechaVencimiento;
}

class ItemMantenimiento {
  const ItemMantenimiento({
    required this.nombre,
    required this.intervaloKm,
    required this.intervaloMeses,
    required this.ultimoKm,
    required this.ultimaFecha,
  });

  final String nombre;
  final int intervaloKm;
  final int intervaloMeses;
  final int ultimoKm;
  final DateTime ultimaFecha;
}

class Vehiculo {
  const Vehiculo({
    required this.placa,
    required this.tipo,
    required this.marca,
    required this.modelo,
    required this.anio,
    required this.ciudad,
    required this.kmActual,
    required this.fechaKm,
    required this.items,
    required this.documentos,
  });

  final String placa;
  final String tipo;
  final String marca;
  final String modelo;
  final int anio;
  final String ciudad;
  final int kmActual;
  final DateTime fechaKm;
  final List<ItemMantenimiento> items;
  final List<Documento> documentos;
}

final List<Usuario> usuarios = [
  Usuario(
    nombre: 'Anderson',
    correo: 'conductor@correo.com',
    clave: '1234',
    rol: 'conductor',
  ),
  Usuario(
    nombre: 'Taller Moto Center',
    correo: 'taller@correo.com',
    clave: '1234',
    rol: 'mecanico',
  ),
];

final List<Vehiculo> vehiculos = [
  Vehiculo(
    placa: 'ABC12D',
    tipo: 'moto',
    marca: 'Suzuki',
    modelo: 'Gixxer 250',
    anio: 2023,
    ciudad: 'Medellín',
    kmActual: 4800,
    fechaKm: DateTime(2026, 9, 20),
    items: [
      ItemMantenimiento(
        nombre: 'Cambio de aceite',
        intervaloKm: 3000,
        intervaloMeses: 3,
        ultimoKm: 3000,
        ultimaFecha: DateTime(2026, 6, 15),
      ),
      ItemMantenimiento(
        nombre: 'Filtro de aire',
        intervaloKm: 6000,
        intervaloMeses: 6,
        ultimoKm: 0,
        ultimaFecha: DateTime(2026, 1, 10),
      ),
      ItemMantenimiento(
        nombre: 'Bujía',
        intervaloKm: 6000,
        intervaloMeses: 6,
        ultimoKm: 0,
        ultimaFecha: DateTime(2026, 1, 10),
      ),
      ItemMantenimiento(
        nombre: 'Kit de arrastre',
        intervaloKm: 12000,
        intervaloMeses: 12,
        ultimoKm: 0,
        ultimaFecha: DateTime(2026, 1, 10),
      ),
      ItemMantenimiento(
        nombre: 'Llantas',
        intervaloKm: 12000,
        intervaloMeses: 12,
        ultimoKm: 0,
        ultimaFecha: DateTime(2026, 1, 10),
      ),
    ],
    documentos: [
      Documento(tipo: 'SOAT', fechaVencimiento: DateTime(2026, 10, 6)),
      Documento(
        tipo: 'Tecnico-mecanica',
        fechaVencimiento: DateTime(2028, 1, 10),
      ),
      Documento(tipo: 'Impuesto', fechaVencimiento: DateTime(2027, 6, 30)),
    ],
  ),
  Vehiculo(
    placa: 'KLM456',
    tipo: 'carro',
    marca: 'Renault',
    modelo: 'Logan',
    anio: 2019,
    ciudad: 'Medellín',
    kmActual: 61200,
    fechaKm: DateTime(2026, 9, 18),
    items: [
      ItemMantenimiento(
        nombre: 'Cambio de aceite',
        intervaloKm: 5000,
        intervaloMeses: 6,
        ultimoKm: 60000,
        ultimaFecha: DateTime(2026, 8, 1),
      ),
      ItemMantenimiento(
        nombre: 'Llantas',
        intervaloKm: 40000,
        intervaloMeses: 48,
        ultimoKm: 30000,
        ultimaFecha: DateTime(2024, 3, 15),
      ),
    ],
    documentos: [
      Documento(tipo: 'SOAT', fechaVencimiento: DateTime(2026, 12, 15)),
      Documento(
        tipo: 'Tecnico-mecanica',
        fechaVencimiento: DateTime(2027, 2, 20),
      ),
      Documento(tipo: 'Impuesto', fechaVencimiento: DateTime(2027, 6, 30)),
    ],
  ),
];
