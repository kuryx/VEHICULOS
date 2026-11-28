# Investigación de widgets de Flutter

**Nombre del estudiante:** Juan Pablo Bustos Sepúlveda<br>
**Grupo:** 602<br>
**Fecha:** 28 de noviembre de 2026<br>

**Mis widgets:** `Drawer`, `DropdownMenu`, `SearchBar`

> Los ejemplos usan datos del proyecto VEHICULOS (la Suzuki Gixxer 250 placa ABC12D, el Renault Logan, y las pantallas y reglas del documento de definición). Cada ejemplo es un archivo independiente que se pega en DartPad: no importa ni modifica el código del proyecto.


## 1. `Drawer`

### Qué es y para qué sirve

`Drawer` es un panel que se desliza desde el borde de la pantalla y muestra un menú de opciones. Se pasa a la propiedad `drawer` del `Scaffold`, y este agrega por su cuenta el botón de las tres rayas que lo abre.

Resuelve el problema de las pantallas saturadas: el `Drawer` mantiene ocultas las secciones de la app hasta que el usuario las necesita. Sin él, todas las secciones tendrían que estar a la vista al mismo tiempo y la interfaz se vería recargada.

### Cuándo usarlo y cuándo no

El `Drawer` es buena opción cuando la app tiene varias secciones que no se necesitan todo el tiempo, por ejemplo en VEHICULOS un menú con Mis vehículos, Taller y Cerrar sesión. No conviene cuando son pocas secciones principales y el usuario cambia entre ellas a cada rato, como Resumen, Mantenimientos y Documentos de un vehículo. Ahí es mejor un `NavigationBar`, porque queda siempre visible abajo y se cambia con un solo toque.

### Ejemplo mínimo

```dart
import 'package:flutter/material.dart';

void main() => runApp(const MaterialApp(home: Prueba()));

class Prueba extends StatelessWidget {
  const Prueba({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mis vehículos')),
      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(child: Text('Menú')),
            ListTile(
              leading: const Icon(Icons.two_wheeler),
              title: const Text('Mis vehículos'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.build),
              title: const Text('Taller'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Cerrar sesión'),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
      body: const Center(child: Text('Abre el menú')),
    );
  }
}
```

### Explicación del ejemplo

- El `Drawer` se pasa a la propiedad `drawer` del `Scaffold`. Con eso, el `Scaffold` agrega solo el botón de las tres rayas en el `AppBar`.
- Dentro del `Drawer` uso un `ListView` para que el menú se pueda desplazar si tiene muchas opciones.
- `DrawerHeader` es el encabezado del panel, y cada `ListTile` es una opción del menú.
- `onTap` define qué pasa al tocar una opción. `Navigator.pop(context)` cierra el panel, porque el `Drawer` se abre encima de la pantalla, en la misma pila de navegación.
- Los `ListTile` no llevan `const` porque `onTap` es una función.

### Propiedades importantes

| Propiedad | Qué hace | Ejemplo |
|---|---|---|
| `child` | Contenido del panel; casi siempre un `ListView`. | `child: ListView(children: [...])` |
| `backgroundColor` | Color de fondo del panel. | `backgroundColor: Colors.green.shade100` |
| `width` | Ancho del panel. | `width: 250` |
| `elevation` | Qué tan marcada se ve la sombra del panel sobre la pantalla. | `elevation: 8` |

### Ejemplo personalizado

```dart
import 'package:flutter/material.dart';

void main() => runApp(const MaterialApp(home: Prueba()));

class Prueba extends StatefulWidget {
  const Prueba({super.key});

  @override
  State<Prueba> createState() => _PruebaState();
}

class _PruebaState extends State<Prueba> {
  String _seccion = 'Mis vehículos';

  void _ir(String seccion) {
    setState(() => _seccion = seccion);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_seccion)),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.green.shade100),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text('ABC12D', style: TextStyle(fontSize: 24)),
                  Text('Suzuki Gixxer 250'),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.two_wheeler),
              title: const Text('Mis vehículos'),
              selected: _seccion == 'Mis vehículos',
              onTap: () => _ir('Mis vehículos'),
            ),
            ListTile(
              leading: const Icon(Icons.build),
              title: const Text('Taller'),
              selected: _seccion == 'Taller',
              onTap: () => _ir('Taller'),
            ),
          ],
        ),
      ),
      body: Center(child: Text('Sección: $_seccion')),
    );
  }
}
```

Este ejemplo usa los datos del proyecto VEHICULOS. El encabezado muestra la placa y el modelo de la moto. Al elegir una opción, `_ir` guarda la sección con `setState` y cierra el panel. La opción activa queda resaltada gracias a `selected`, que es una propiedad del `ListTile`, no del `Drawer`.

**Lo que probé al romperlo:**

- Cambié `drawer` por `endDrawer` y el menú pasó al lado derecho, con su botón en la esquina derecha del `AppBar`.
- Sin `onTap`, tocar una opción no hace nada y el panel no se cierra solo.
- Con `width: 200` no vi cambio en DartPad, porque la vista previa es muy angosta y el panel no puede ser más ancho que la pantalla.

### Dónde lo usarías en VEHICULOS

En la pantalla **Mis vehículos (P-02)**, que hoy tiene el botón "Cerrar sesión" en el `AppBar`. Con un `Drawer`, esa opción quedaría dentro de un menú lateral junto con otras secciones, y la pantalla principal quedaría más limpia. Hay que tener en cuenta que esa pantalla tiene `automaticallyImplyLeading: false` para quitar la flecha de volver, y con eso el `Scaffold` tampoco muestra el botón de las tres rayas, así que habría que cambiarlo. No lo usaría en el login ni en el formulario de registrar vehículo, porque ahí no hay secciones entre las que moverse.

### Fuentes y ayudas usadas

- Documentación oficial: https://api.flutter.dev/flutter/material/Drawer-class.html
- Catálogo de widgets: https://docs.flutter.dev/ui/widgets
- Datos del proyecto: `docs/definicion.md` de https://github.com/kuryx/VEHICULOS (solo lo leí para tomar los datos; no modifiqué su código).
- Probé y modifiqué los ejemplos en DartPad.
- Usé inteligencia artificial (Claude) como apoyo para organizar la investigación, preparar los ejemplos de código y mejorar la redacción.


## 2. `DropdownMenu`

### Qué es y para qué sirve

`DropdownMenu` es un campo que despliega una lista de opciones para elegir una sola. Es la versión de Material 3 del menú desplegable, y cada opción es un `DropdownMenuEntry` con un valor y una etiqueta.

Resuelve el problema de pedir un dato que solo puede tener ciertos valores, como la ciudad o el tipo de vehículo. En vez de dejar que el usuario escriba y se equivoque, le muestra las opciones válidas.

### Cuándo usarlo y cuándo no

Es buena opción cuando hay una lista corta de opciones fijas, como las ciudades en el formulario de Registrar vehículo de VEHICULOS. No conviene cuando las opciones son muchas, como las marcas y modelos: ahí es mejor `Autocomplete`, porque el usuario escribe y le sugiere. Tampoco para dos opciones que conviene ver siempre a la vista, donde `ChoiceChip` o `Radio` son más rápidos.

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
  String _tipo = 'Moto';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registrar vehículo')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DropdownMenu<String>(
              initialSelection: 'Moto',
              label: const Text('Tipo de vehículo'),
              dropdownMenuEntries: const [
                DropdownMenuEntry(value: 'Moto', label: 'Moto'),
                DropdownMenuEntry(value: 'Carro', label: 'Carro'),
              ],
              onSelected: (v) => setState(() => _tipo = v ?? _tipo),
            ),
            const SizedBox(height: 24),
            Text('Elegiste: $_tipo'),
          ],
        ),
      ),
    );
  }
}
```

### Explicación del ejemplo

- `DropdownMenu<String>`: el tipo entre `<>` es el tipo de los valores de las opciones, aquí texto.
- `dropdownMenuEntries` es la lista de opciones. Cada `DropdownMenuEntry` tiene un `value` (lo que se guarda) y un `label` (lo que se ve).
- `initialSelection` es la opción que aparece elegida al abrir la pantalla.
- `onSelected` se ejecuta cuando el usuario elige algo y recibe el valor elegido. Con `setState` lo guardo en `_tipo`, y por eso el texto de abajo cambia.
- Recibe el valor como `String?`, por eso uso `v ?? _tipo`: si llega vacío, dejo el valor anterior.

### Propiedades importantes

| Propiedad | Qué hace | Ejemplo |
|---|---|---|
| `dropdownMenuEntries` | Lista de opciones. Es obligatoria. | `DropdownMenuEntry(value: 'Moto', label: 'Moto')` |
| `initialSelection` | Opción elegida al empezar. | `initialSelection: 'Moto'` |
| `onSelected` | Se ejecuta al elegir una opción y recibe su valor. | `onSelected: (v) => setState(() => _tipo = v ?? _tipo)` |
| `label` | Texto que describe el campo. | `label: Text('Ciudad')` |
| `leadingIcon` | Ícono al inicio del campo. | `leadingIcon: Icon(Icons.two_wheeler)` |
| `width` | Ancho del campo. | `width: 250` |
| `errorText` | Mensaje de error debajo del campo. | `errorText: 'Solo disponible en Medellín'` |

### Ejemplo personalizado

```dart
import 'package:flutter/material.dart';

void main() => runApp(const MaterialApp(home: Prueba()));

class Prueba extends StatefulWidget {
  const Prueba({super.key});

  @override
  State<Prueba> createState() => _PruebaState();
}

class _PruebaState extends State<Prueba> {
  String _tipo = 'Moto';
  String _ciudad = 'Medellín';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registrar vehículo')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DropdownMenu<String>(
              initialSelection: _tipo,
              label: const Text('Tipo de vehículo'),
              leadingIcon: Icon(
                _tipo == 'Moto' ? Icons.two_wheeler : Icons.directions_car,
              ),
              dropdownMenuEntries: const [
                DropdownMenuEntry(
                  value: 'Moto',
                  label: 'Moto',
                  leadingIcon: Icon(Icons.two_wheeler),
                ),
                DropdownMenuEntry(
                  value: 'Carro',
                  label: 'Carro',
                  leadingIcon: Icon(Icons.directions_car),
                ),
              ],
              onSelected: (v) => setState(() => _tipo = v ?? _tipo),
            ),
            const SizedBox(height: 16),
            DropdownMenu<String>(
              initialSelection: _ciudad,
              label: const Text('Ciudad'),
              leadingIcon: const Icon(Icons.location_city),
              errorText: _ciudad == 'Medellín'
                  ? null
                  : 'El pico y placa solo está disponible en Medellín',
              dropdownMenuEntries: const [
                DropdownMenuEntry(value: 'Medellín', label: 'Medellín'),
                DropdownMenuEntry(value: 'Bogotá', label: 'Bogotá'),
                DropdownMenuEntry(value: 'Cali', label: 'Cali'),
              ],
              onSelected: (v) => setState(() => _ciudad = v ?? _ciudad),
            ),
            const SizedBox(height: 24),
            Text('Registrarías: $_tipo en $_ciudad'),
          ],
        ),
      ),
    );
  }
}
```

Este ejemplo usa los datos del formulario de Registrar vehículo de VEHICULOS. En el primer campo, el ícono del inicio depende de `_tipo`, así que cambia de moto a carro al elegir "Carro". En el segundo, `errorText` solo tiene valor cuando la ciudad no es Medellín, y entonces aparece el aviso debajo del campo. Eso representa la regla de que el pico y placa solo se soporta en Medellín (RN-04).

**Lo que probé al romperlo:**

- Con `onSelected` vacío, el campo mostraba la opción elegida, pero el texto "Elegiste" de la pantalla no cambiaba, porque `_tipo` nunca se actualizaba.
- Con `leadingIcon` fijo, el ícono no depende de lo elegido. Por eso en el ejemplo personalizado lo hago depender de `_tipo`, y cambia al elegir "Carro".
- Al elegir "Bogotá" en el campo de ciudad, apareció el aviso debajo del campo.

### Dónde lo usarías en VEHICULOS

En el formulario **Registrar vehículo (P-04)**, para el campo **Ciudad**. Según el mockup, la ciudad es un campo donde el conductor puede escribir cualquier cosa, pero el pico y placa solo funciona en Medellín (RN-04). Con `DropdownMenu`, solo puede elegir ciudades válidas. También serviría para el tipo de vehículo (moto o carro). No lo usaría en el login ni en el Taller, porque ahí no hay datos que se elijan de una lista fija.

### Fuentes y ayudas usadas

- Documentación oficial: https://api.flutter.dev/flutter/material/DropdownMenu-class.html
- Catálogo de widgets: https://docs.flutter.dev/ui/widgets
- Datos del proyecto: `docs/definicion.md` de https://github.com/kuryx/VEHICULOS (solo lo leí para tomar los datos; no modifiqué su código).
- Probé y modifiqué los ejemplos en DartPad.
- Usé inteligencia artificial (Claude) como apoyo para organizar la investigación, preparar los ejemplos de código y mejorar la redacción.


## 3. `SearchBar`

### Qué es y para qué sirve

`SearchBar` es una barra de búsqueda de Material 3: un campo de texto con forma de píldora, que puede llevar una lupa al inicio y botones al final. Avisa lo que el usuario va escribiendo, y con eso la app decide qué mostrar.

Resuelve el problema de encontrar un dato en una lista larga. En vez de recorrerla completa, el usuario escribe y la lista se reduce.

### Cuándo usarlo y cuándo no

Es buena opción cuando la lista puede crecer y el usuario sabe qué busca, como los vehículos que atiende un taller, que se buscan por placa. No conviene cuando la lista es corta (unos pocos elementos) o cuando el usuario debe elegir entre opciones ya definidas: ahí es mejor un `DropdownMenu`. Tampoco si necesitas sugerencias mientras escribe, porque para eso está `Autocomplete`.

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
  String _texto = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Taller')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SearchBar(
              hintText: 'Buscar por placa',
              onChanged: (v) => setState(() => _texto = v),
            ),
            const SizedBox(height: 24),
            Text('Escribiste: $_texto'),
          ],
        ),
      ),
    );
  }
}
```

### Explicación del ejemplo

- `hintText` es el texto de ayuda que se ve mientras la barra está vacía.
- `onChanged` se ejecuta con cada letra que escribe el usuario y recibe el texto completo. Con `setState` lo guardo en `_texto`, y por eso el texto de abajo cambia al instante.
- Si uso `onSubmitted` en vez de `onChanged`, el texto solo cambia cuando el usuario confirma con Enter.

### Propiedades importantes

| Propiedad | Qué hace | Ejemplo |
|---|---|---|
| `hintText` | Texto de ayuda cuando la barra está vacía. | `hintText: 'Buscar por placa'` |
| `onChanged` | Se ejecuta con cada cambio del texto. | `onChanged: (v) => setState(() => _texto = v)` |
| `onSubmitted` | Se ejecuta al confirmar con Enter. | `onSubmitted: (v) => buscar(v)` |
| `controller` | Permite leer y borrar el texto desde el código. | `controller: _controller` |
| `leading` | Widget al inicio de la barra, como una lupa. | `leading: Icon(Icons.search)` |
| `trailing` | Lista de widgets al final, como un botón para borrar. | `trailing: [IconButton(...)]` |
| `backgroundColor` | Color de fondo, envuelto en `WidgetStatePropertyAll`. | `backgroundColor: WidgetStatePropertyAll(Colors.green.shade100)` |
| `elevation` | Sombra de la barra, también envuelta en `WidgetStatePropertyAll`. | `elevation: WidgetStatePropertyAll(0)` |

### Ejemplo personalizado

```dart
import 'package:flutter/material.dart';

void main() => runApp(const MaterialApp(home: Prueba()));

class Vehiculo {
  final String placa;
  final String modelo;
  final bool esMoto;
  const Vehiculo(this.placa, this.modelo, this.esMoto);
}

// Las dos primeras son los vehículos del proyecto; las otras dos son de ejemplo.
const _vehiculos = [
  Vehiculo('ABC12D', 'Suzuki Gixxer 250', true),
  Vehiculo('KLM456', 'Renault Logan', false),
  Vehiculo('HIJ56K', 'Yamaha FZ 250', true),
  Vehiculo('LMN78P', 'Chevrolet Spark', false),
];

class Prueba extends StatefulWidget {
  const Prueba({super.key});

  @override
  State<Prueba> createState() => _PruebaState();
}

class _PruebaState extends State<Prueba> {
  String _busqueda = '';

  @override
  Widget build(BuildContext context) {
    final resultados = _vehiculos
        .where((v) => v.placa.toLowerCase().contains(_busqueda.toLowerCase()))
        .toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Taller')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SearchBar(
              hintText: 'Buscar por placa',
              leading: const Icon(Icons.search),
              onChanged: (v) => setState(() => _busqueda = v),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: resultados.isEmpty
                  ? const Center(child: Text('Sin resultados'))
                  : ListView(
                      children: [
                        for (final v in resultados)
                          ListTile(
                            leading: Icon(
                              v.esMoto ? Icons.two_wheeler : Icons.directions_car,
                            ),
                            title: Text(v.placa),
                            subtitle: Text(v.modelo),
                          ),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
```

Este ejemplo simula la pantalla del Taller de VEHICULOS, con una lista fija de vehículos. Cada vez que el usuario escribe, `onChanged` guarda el texto en `_busqueda` y `setState` vuelve a construir la pantalla. En `build`, `.where(...)` deja solo los vehículos cuya placa contiene lo escrito, y `toLowerCase()` hace que la búsqueda no distinga mayúsculas. Si no queda ninguno, se muestra "Sin resultados".

**Lo que probé al romperlo:**

- Con `onSubmitted` en vez de `onChanged`, el texto de abajo solo cambiaba al confirmar con Enter, no mientras escribía.
- Con un `controller` y un botón con la X, `_controller.clear()` borraba el texto de la barra, y `setState` borraba el texto de abajo.
- Al agregar `backgroundColor`, la barra cambió de color, y al tocarla se veía un tono más oscuro, porque el valor va dentro de `WidgetStatePropertyAll`, que aplica el mismo valor a todos los estados.
- Al escribir `abc` quedó solo la Gixxer, y al escribir `zzz` apareció "Sin resultados".

### Dónde lo usarías en VEHICULOS

En la pantalla **Taller (P-06)**, que según el documento de definición muestra la lista de vehículos atendidos con placa, modelo y dueño. Hoy es solo una lista, pero un taller puede atender muchos vehículos, y recorrerla completa se vuelve lento. Con un `SearchBar`, el mecánico escribiría la placa y la lista se reduciría a los que coinciden, que es justo lo que hace el ejemplo personalizado. No lo usaría en **Mis vehículos (P-02)**, porque un conductor tiene pocos vehículos y la lista cabe completa en pantalla.

### Fuentes y ayudas usadas

- Documentación oficial: https://api.flutter.dev/flutter/material/SearchBar-class.html
- Catálogo de widgets: https://docs.flutter.dev/ui/widgets
- Datos del proyecto: `docs/definicion.md` de https://github.com/kuryx/VEHICULOS (solo lo leí para tomar los datos; no modifiqué su código).
- Probé y modifiqué los ejemplos en DartPad.
- Usé inteligencia artificial (Claude) como apoyo para organizar la investigación, preparar los ejemplos de código y mejorar la redacción.