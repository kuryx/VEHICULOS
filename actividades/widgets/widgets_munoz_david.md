# Investigación de widgets de Flutter

**Nombre del estudiante:** Nombre Apellido<br>
**Grupo:** 602<br>
**Fecha:** 26 de noviembre de 2026<br>

**Mis widgets:** `NavigationBar`, `Autocomplete`, `AnimatedSwitcher`

> Los ejemplos usan los datos fijos del proyecto VEHICULOS (la Suzuki Gixxer 250 placa ABC12D, el Renault Logan, sus ítems de mantenimiento y documentos). Cada ejemplo es un archivo independiente que se pega en DartPad: no importa ni modifica el código del proyecto.


## 1. `NavigationBar`

### Qué es y para qué sirve

`NavigationBar` es la barra inferior de Material 3 que permite saltar entre las secciones principales de una app (entre 2 y 5 destinos). Cada destino tiene un ícono y una etiqueta, y el elegido se resalta con un "indicador" en forma de píldora.

Resuelve el problema de la navegación de primer nivel: sin ella tendría que armar una `Row` de botones y manejar a mano cuál está seleccionado, el resalte y la accesibilidad.

### Cuándo usarlo y cuándo no

Es la mejor opción en celulares cuando hay entre 3 y 5 secciones de igual importancia, como Resumen, Mantenimientos y Documentos de un vehículo. No conviene si hay muchas secciones o es una pantalla ancha (tablet, web): ahí es mejor un `Drawer` o un `NavigationRail`. Tampoco para acciones puntuales, para eso van los botones.

### Ejemplo mínimo

```dart
import 'package:flutter/material.dart';

void main() => runApp(const MaterialApp(home: Prueba()));

class Prueba extends StatefulWidget {
  const Prueba({super.key});

  @override
  State<Prueba> createState() => _PruebaState();
}

class _PruebaState extends State<Prueba> {
  int _indice = 0;
  static const _secciones = ['Resumen', 'Mantenimientos', 'Documentos'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ABC12D')),
      body: Center(child: Text('Sección: ${_secciones[_indice]}')),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _indice,
        onDestinationSelected: (i) => setState(() => _indice = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.dashboard), label: 'Resumen'),
          NavigationDestination(icon: Icon(Icons.build), label: 'Mantenimientos'),
          NavigationDestination(icon: Icon(Icons.description), label: 'Documentos'),
        ],
      ),
    );
  }
}
```

### Explicación del ejemplo

- `_indice` guarda qué destino está activo; por eso la clase es `StatefulWidget`.
- `selectedIndex` le dice a la barra cuál pintar como seleccionado.
- `onDestinationSelected` se llama cuando el usuario toca un destino y entrega su posición; con `setState` actualizo `_indice` y la barra se redibuja. Si no lo actualizo, el indicador no se mueve.
- `destinations` es la lista de `NavigationDestination`; necesita mínimo 2.
- Se pone en `Scaffold.bottomNavigationBar`.
- El `Text` del centro usa `_indice` para mostrar el nombre de la sección activa.

### Propiedades importantes

| Propiedad | Qué hace | Ejemplo |
|---|---|---|
| `destinations` | Lista de destinos (ícono + etiqueta). Mínimo 2. | `destinations: [NavigationDestination(...), ...]` |
| `selectedIndex` | Posición del destino activo. | `selectedIndex: _indice` |
| `onDestinationSelected` | Se ejecuta al tocar un destino y recibe su índice. | `onDestinationSelected: (i) => setState(() => _indice = i)` |
| `labelBehavior` | Cuándo se muestran las etiquetas. | `NavigationDestinationLabelBehavior.onlyShowSelected` |
| `indicatorColor` | Color de la píldora del destino activo. | `indicatorColor: Color(0xFFDCE6FA)` |
| `backgroundColor` | Color de fondo de la barra. | `backgroundColor: Colors.white` |
| `height` | Alto de la barra. | `height: 70` |

Y en cada `NavigationDestination`: `icon`, `selectedIcon` (ícono distinto al estar activo) y `label`.

### Ejemplo personalizado

Un panel de la Suzuki Gixxer 250 con las tres secciones y el contenido real de cada una.

```dart
import 'package:flutter/material.dart';

void main() => runApp(const MaterialApp(home: PanelPrueba()));

class PanelPrueba extends StatefulWidget {
  const PanelPrueba({super.key});

  @override
  State<PanelPrueba> createState() => _PanelPruebaState();
}

class _PanelPruebaState extends State<PanelPrueba> {
  int _indice = 0;

  static const _titulos = ['Resumen', 'Mantenimientos', 'Documentos'];

  static const _items = [
    ('Cambio de aceite', 'cada 3.000 km o 3 meses'),
    ('Filtro de aire', 'cada 6.000 km o 6 meses'),
    ('Bujía', 'cada 6.000 km o 6 meses'),
    ('Kit de arrastre', 'cada 12.000 km o 12 meses'),
    ('Llantas', 'cada 12.000 km o 12 meses'),
  ];

  static const _documentos = [
    ('SOAT', 'vence el 6 de octubre de 2026'),
    ('Técnico-mecánica', 'vence el 10 de enero de 2028'),
    ('Impuesto', 'vence el 30 de junio de 2027'),
  ];

  Widget _contenido() {
    switch (_indice) {
      case 0:
        return const Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('ABC12D',
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
              Text('Suzuki Gixxer 250 - 2023'),
              SizedBox(height: 16),
              Text('4.800 km', style: TextStyle(fontSize: 24)),
            ],
          ),
        );
      case 1:
        return ListView(
          children: [
            for (final (nombre, regla) in _items)
              ListTile(
                leading: const Icon(Icons.build_circle_outlined),
                title: Text(nombre),
                subtitle: Text(regla),
              ),
          ],
        );
      default:
        return ListView(
          children: [
            for (final (tipo, vence) in _documentos)
              ListTile(
                leading: const Icon(Icons.description_outlined),
                title: Text(tipo),
                subtitle: Text(vence),
              ),
          ],
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_titulos[_indice])),
      body: _contenido(),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _indice,
        onDestinationSelected: (i) => setState(() => _indice = i),
        backgroundColor: Colors.white,
        indicatorColor: const Color(0xFFDCE6FA),
        height: 70,
        labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard),
            label: 'Resumen',
          ),
          NavigationDestination(
            icon: Icon(Icons.build_outlined),
            selectedIcon: Icon(Icons.build),
            label: 'Mantenimientos',
          ),
          NavigationDestination(
            icon: Icon(Icons.description_outlined),
            selectedIcon: Icon(Icons.description),
            label: 'Documentos',
          ),
        ],
      ),
    );
  }
}
```

La barra tiene fondo blanco, indicador azul claro (el azul de los botones del proyecto en versión suave), solo muestra la etiqueta del destino activo y cada ícono pasa de contorno a relleno al activarse (`selectedIcon`). El método `_contenido()` elige qué mostrar según `_indice`: los datos del vehículo, los cinco ítems de mantenimiento con su regla de "kilómetros o meses" o los tres documentos con su vencimiento.

**Lo que hay que probar al romperlo:** con un solo destino, la app lanza un error de aserción (mínimo 2). Si dejo `onDestinationSelected` vacío, tocar no mueve el indicador. Si `selectedIndex` es mayor que la cantidad de destinos, también falla.

### Dónde lo usarías en VEHICULOS

En el **Panel del vehículo (P-03)**. Hoy se llega a Mantenimientos (P-05) con un botón "Ver mantenimientos" y `Navigator.push`. Con `NavigationBar` el conductor tendría tres destinos fijos abajo del panel: **Resumen** (kilometraje, SOAT, pico y placa), **Mantenimientos** y **Documentos**. Así cambia de sección con un toque, sin ir y volver entre pantallas, lo que ayuda con RNF-04 (actualizar el kilometraje en máximo dos toques). No lo usaría en el login (P-01) ni en el formulario de registro (P-04), porque ahí no hay secciones de igual importancia.

### Fuentes y ayudas usadas

- Documentación oficial: https://api.flutter.dev/flutter/material/NavigationBar-class.html
- Catálogo de widgets: https://docs.flutter.dev/ui/widgets
- Datos del proyecto: README y `docs/definicion.md` de https://github.com/kuryx/VEHICULOS (solo los leí para tomar los datos; no modifiqué su código).
- Probé los ejemplos en DartPad.
- Usé inteligencia artificial (Claude) como apoyo para organizar la investigación y revisar el borrador del código; luego lo probé y lo modifiqué yo.


## 2. `Autocomplete`

### Qué es y para qué sirve

`Autocomplete` es un campo de texto que, mientras escribes, muestra una lista de sugerencias para elegir. Tú le dices cómo calcular las opciones según lo escrito y él se encarga de mostrar la lista, manejar el foco y devolver lo que el usuario elige.

Resuelve el problema de escribir datos exactos (marcas, modelos, ciudades): sugiere y evita errores de digitación.

### Cuándo usarlo y cuándo no

Es la mejor opción cuando hay muchas opciones posibles (decenas o cientos), como la marca o el modelo de un vehículo. No conviene con pocas opciones fijas (2 a 6), como elegir entre "Moto" y "Carro": ahí es mejor `ChoiceChip`, `Radio` o `DropdownMenu`, porque se ven todas a la vez. Tampoco si el usuario puede escribir cualquier texto libre, sin opciones válidas.

### Ejemplo mínimo

```dart
import 'package:flutter/material.dart';

const _marcas = [
  'AKT', 'Bajaj', 'Chevrolet', 'Honda', 'Kia',
  'Mazda', 'Renault', 'Suzuki', 'Yamaha',
];

void main() => runApp(const MaterialApp(home: Prueba()));

class Prueba extends StatelessWidget {
  const Prueba({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Marca del vehículo')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Autocomplete<String>(
          optionsBuilder: (TextEditingValue valor) {
            if (valor.text.isEmpty) return const Iterable<String>.empty();
            return _marcas.where(
              (m) => m.toLowerCase().contains(valor.text.toLowerCase()),
            );
          },
          onSelected: (String elegida) => debugPrint('Marca: $elegida'),
        ),
      ),
    );
  }
}
```

### Explicación del ejemplo

- `Autocomplete<String>`: el tipo entre `<>` es el tipo de las opciones (aquí texto).
- `optionsBuilder` se ejecuta cada vez que cambia el texto. Recibe lo escrito (`valor.text`) y devuelve las marcas que coinciden. Si el campo está vacío devuelvo una lista vacía para que no muestre nada.
- Uso `toLowerCase()` en ambos lados para que "su" encuentre "Suzuki" sin importar mayúsculas.
- `onSelected` se llama cuando el usuario toca una sugerencia; recibe la opción elegida. El mensaje sale en la consola de DartPad.

### Propiedades importantes

| Propiedad | Qué hace | Ejemplo |
|---|---|---|
| `optionsBuilder` | Obligatoria. Calcula las sugerencias según el texto escrito. | `optionsBuilder: (v) => marcas.where(...)` |
| `onSelected` | Se ejecuta al elegir una opción. | `onSelected: (o) => setState(() => _elegida = o)` |
| `displayStringForOption` | Cómo se muestra como texto una opción (útil con objetos). | `displayStringForOption: (o) => '${o.marca} ${o.modelo}'` |
| `fieldViewBuilder` | Personaliza el campo de texto (decoración, ícono, etc.). | `fieldViewBuilder: (ctx, ctrl, foco, enviar) => TextField(...)` |
| `optionsViewBuilder` | Personaliza cómo se ve la lista desplegable. | `optionsViewBuilder: (ctx, onSel, opciones) => ...` |
| `optionsMaxHeight` | Alto máximo de la lista de sugerencias. | `optionsMaxHeight: 160` |
| `initialValue` | Texto con el que arranca el campo. | `initialValue: TextEditingValue(text: 'Su')` |

### Ejemplo personalizado

Un campo "Marca y modelo" que busca entre vehículos y, al elegir, muestra qué campos del formulario se llenarían.

```dart
import 'package:flutter/material.dart';

class Opcion {
  final String tipo;
  final String marca;
  final String modelo;
  const Opcion(this.tipo, this.marca, this.modelo);
}

const _opciones = [
  Opcion('moto', 'Suzuki', 'Gixxer 250'),
  Opcion('moto', 'Suzuki', 'Gixxer 150'),
  Opcion('moto', 'Yamaha', 'FZ 250'),
  Opcion('moto', 'Honda', 'CB 190R'),
  Opcion('moto', 'AKT', 'NKD 125'),
  Opcion('carro', 'Renault', 'Logan'),
  Opcion('carro', 'Renault', 'Sandero'),
  Opcion('carro', 'Chevrolet', 'Spark'),
  Opcion('carro', 'Mazda', '3'),
];

void main() => runApp(const MaterialApp(home: Prueba()));

class Prueba extends StatefulWidget {
  const Prueba({super.key});

  @override
  State<Prueba> createState() => _PruebaState();
}

class _PruebaState extends State<Prueba> {
  Opcion? _elegida;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registrar vehículo')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Autocomplete<Opcion>(
              displayStringForOption: (o) => '${o.marca} ${o.modelo}',
              optionsMaxHeight: 160,
              optionsBuilder: (TextEditingValue valor) {
                final texto = valor.text.toLowerCase();
                if (texto.isEmpty) return const Iterable<Opcion>.empty();
                return _opciones.where(
                  (o) =>
                      o.marca.toLowerCase().contains(texto) ||
                      o.modelo.toLowerCase().contains(texto),
                );
              },
              fieldViewBuilder: (context, controller, focusNode, onSubmit) {
                return TextField(
                  controller: controller,
                  focusNode: focusNode,
                  onSubmitted: (_) => onSubmit(),
                  decoration: InputDecoration(
                    labelText: 'Marca y modelo',
                    prefixIcon: const Icon(Icons.two_wheeler),
                    filled: true,
                    fillColor: Colors.grey.shade100,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                );
              },
              onSelected: (o) => setState(() => _elegida = o),
            ),
            const SizedBox(height: 24),
            if (_elegida == null)
              const Text('Escribe "su", "log" o "250" para ver sugerencias')
            else
              Text(
                'Tipo: ${_elegida!.tipo}\n'
                'Marca: ${_elegida!.marca}\n'
                'Modelo: ${_elegida!.modelo}',
              ),
          ],
        ),
      ),
    );
  }
}
```

Aquí las opciones son objetos `Opcion` (tipo, marca y modelo), no texto simple. `displayStringForOption` indica qué texto mostrar al elegir ("Suzuki Gixxer 250"). El `optionsBuilder` busca por marca o por modelo, así "250" encuentra la Gixxer y la FZ. `fieldViewBuilder` reemplaza el campo por uno con el mismo estilo del formulario del proyecto (fondo gris claro y borde redondeado de 8) y es obligatorio usar el `controller` y el `focusNode` que entrega. Al elegir, `setState` guarda la opción y se muestra qué campos se llenarían.

**Lo que hay que probar al romperlo:** si en `fieldViewBuilder` no paso el `controller` o el `focusNode` al `TextField`, las sugerencias no aparecen o no reaccionan. Si uso objetos y olvido `displayStringForOption`, el campo muestra algo como `Instance of 'Opcion'`.

### Dónde lo usarías en VEHICULOS

En el formulario **Registrar vehículo (P-04)**, que hoy usa `TextField` simples para Marca, Modelo y Ciudad. Con `Autocomplete`, el conductor escribe "su" y le sugiere "Suzuki"; escribe "log" y le sugiere "Logan". Se evitan marcas mal escritas ("Suzuky"), algo que importa porque el plan de mantenimiento se carga por modelo (sección 14 del documento de definición). También sirve para la Ciudad, ya que el pico y placa (RN-04) solo aplica a Medellín, y en el Taller (P-06) para buscar un vehículo por placa.

### Fuentes y ayudas usadas

- Documentación oficial: https://api.flutter.dev/flutter/material/Autocomplete-class.html
- Catálogo de widgets: https://docs.flutter.dev/ui/widgets
- Datos del proyecto: README y `docs/definicion.md` de https://github.com/kuryx/VEHICULOS (solo los leí para tomar los datos; no modifiqué su código).
- Probé los ejemplos en DartPad.
- Usé inteligencia artificial (Claude) como apoyo para organizar la investigación y revisar el borrador del código; luego lo probé y lo modifiqué yo.


## 3. `AnimatedSwitcher`

### Qué es y para qué sirve

`AnimatedSwitcher` anima el cambio de un widget por otro. Cuando su `child` cambia, el viejo sale y el nuevo entra con una transición (por defecto, un desvanecimiento).

Resuelve el problema de los cambios bruscos: sin él, un número, un ícono o un mensaje cambia de golpe; con él, el cambio es suave sin tener que manejar un `AnimationController` a mano.

### Cuándo usarlo y cuándo no

Es la mejor opción cuando un widget se reemplaza por otro distinto: un kilometraje que cambia, un ícono de alerta que pasa a check, un mensaje de "tienes pico y placa" que pasa a "puedes circular". No conviene si solo cambia una propiedad del mismo widget (color, tamaño): ahí es mejor `AnimatedContainer` o `AnimatedOpacity`.

### Ejemplo mínimo

```dart
import 'package:flutter/material.dart';

void main() => runApp(const MaterialApp(home: Prueba()));

class Prueba extends StatefulWidget {
  const Prueba({super.key});

  @override
  State<Prueba> createState() => _PruebaState();
}

class _PruebaState extends State<Prueba> {
  int _km = 4800;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Kilometraje de ABC12D')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 400),
              child: Text(
                '$_km km',
                key: ValueKey(_km),
                style: const TextStyle(fontSize: 40),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => setState(() => _km += 100),
              child: const Text('Sumar 100 km'),
            ),
          ],
        ),
      ),
    );
  }
}
```

### Explicación del ejemplo

- `duration` define cuánto dura la transición (400 ms).
- `child` es el widget actual; cuando `_km` cambia, el `Text` nuevo reemplaza al viejo con animación.
- `key: ValueKey(_km)` es la parte clave: `AnimatedSwitcher` solo anima si detecta que el hijo es "distinto", y para dos `Text` seguidos eso lo decide la `key`. Si cambia la `key`, se anima.
- El botón suma 100 al kilometraje con `setState`.

### Propiedades importantes

| Propiedad | Qué hace | Ejemplo |
|---|---|---|
| `child` | El widget actual; al cambiar, se anima el reemplazo. | `child: Text('$_km km', key: ValueKey(_km))` |
| `duration` | Duración de la animación de entrada. | `duration: Duration(milliseconds: 500)` |
| `reverseDuration` | Duración de la animación de salida (si es distinta). | `reverseDuration: Duration(milliseconds: 200)` |
| `transitionBuilder` | Define el tipo de transición (escala, deslizar, etc.). | `transitionBuilder: (w, anim) => ScaleTransition(scale: anim, child: w)` |
| `switchInCurve` | Curva con la que entra el nuevo widget. | `switchInCurve: Curves.easeOutBack` |
| `switchOutCurve` | Curva con la que sale el viejo widget. | `switchOutCurve: Curves.easeIn` |

### Ejemplo personalizado

Dos usos de la app en una pantalla: la tarjeta de pico y placa de hoy, y el ícono de un ítem de mantenimiento que pasa de alerta a "hecho".

```dart
import 'package:flutter/material.dart';

void main() => runApp(const MaterialApp(home: Prueba()));

class Prueba extends StatefulWidget {
  const Prueba({super.key});

  @override
  State<Prueba> createState() => _PruebaState();
}

class _PruebaState extends State<Prueba> {
  bool _tienePico = true;
  bool _aceiteHecho = false;

  Widget _tarjetaPico() {
    final color = _tienePico ? Colors.red : Colors.green;
    return Container(
      key: ValueKey(_tienePico),
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(_tienePico ? Icons.block : Icons.check_circle, color: color),
          const SizedBox(width: 12),
          Text(
            _tienePico
                ? 'ABC12D: hoy tienes pico y placa'
                : 'ABC12D: hoy puedes circular',
            style: TextStyle(color: color, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Suzuki Gixxer 250')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 350),
              transitionBuilder: (child, animation) => FadeTransition(
                opacity: animation,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, 0.3),
                    end: Offset.zero,
                  ).animate(animation),
                  child: child,
                ),
              ),
              child: _tarjetaPico(),
            ),
            TextButton(
              onPressed: () => setState(() => _tienePico = !_tienePico),
              child: const Text('Simular otro día'),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 350),
                  switchInCurve: Curves.elasticOut,
                  transitionBuilder: (child, animation) =>
                      ScaleTransition(scale: animation, child: child),
                  child: Icon(
                    _aceiteHecho
                        ? Icons.check_circle
                        : Icons.warning_amber_rounded,
                    key: ValueKey(_aceiteHecho),
                    color: _aceiteHecho ? Colors.green : Colors.orange,
                    size: 36,
                  ),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text('Cambio de aceite (cada 3.000 km o 3 meses)'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: () => setState(() => _aceiteHecho = !_aceiteHecho),
              child: Text(_aceiteHecho ? 'Deshacer' : 'Marcar como hecho'),
            ),
          ],
        ),
      ),
    );
  }
}
```

El primer `AnimatedSwitcher` cambia la tarjeta de pico y placa con una transición propia: aparece con desvanecimiento y deslizándose un poco hacia arriba (`FadeTransition` con `SlideTransition`). El segundo cambia el ícono del ítem de alerta naranja a check verde con rebote (`ScaleTransition` y `Curves.elasticOut`). En ambos la `key` depende del estado (`ValueKey(_tienePico)`, `ValueKey(_aceiteHecho)`), por eso detectan el cambio. El botón "Simular otro día" solo alterna el estado para poder ver la animación; la regla real del pico y placa (RN-04) depende de la placa y de la ciudad y no se implementa aquí.

**Lo que hay que probar al romperlo:** si quito la `key` en el ejemplo mínimo, el número cambia pero sin animación, porque ambos hijos son `Text` y Flutter los considera "el mismo". Esa es la confusión típica de este widget. En el ejemplo personalizado, si quito la `key` del `Icon`, el check aparece de golpe.

### Dónde lo usarías en VEHICULOS

En el **Panel del vehículo (P-03)**, en la tarjeta de **pico y placa de hoy (RF-11)**: cuando cambia de "Hoy tienes pico y placa" a "Hoy puedes circular", el mensaje y el ícono se reemplazan con una transición. También en **Mantenimientos (P-05)**, cuando el conductor marca un ítem como hecho (RF-08): el ícono de alerta pasa a un check verde de forma animada y se nota que el contador se reinició (RN-05). Cada estado debe llevar una `key` distinta, o no se anima.

### Fuentes y ayudas usadas

- Documentación oficial: https://api.flutter.dev/flutter/widgets/AnimatedSwitcher-class.html
- Catálogo de widgets: https://docs.flutter.dev/ui/widgets
- Datos del proyecto: README y `docs/definicion.md` de https://github.com/kuryx/VEHICULOS (solo los leí para tomar los datos; no modifiqué su código).
- Probé los ejemplos en DartPad.
- Usé inteligencia artificial (Claude) como apoyo para organizar la investigación y revisar el borrador del código; luego lo probé y lo modifiqué yo.
