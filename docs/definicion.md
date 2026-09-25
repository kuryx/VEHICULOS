# VEHICULOS

| | |
|---|---|
| Integrantes | David Muñoz Betancur, Juan Pablo Bustos Sepúlveda, Anderson Fabián Sánchez Benítez |
| Curso y grupo | Programación Móvil (IF2004), grupo 602 |
| Versión | 1.0, 23 de septiembre de 2026 |

## Tabla de contenido

1. [Descripción general](#1-descripción-general)
2. [Problema](#2-problema)
3. [Objetivos](#3-objetivos)
4. [Stakeholders, actores y roles](#4-stakeholders-actores-y-roles)
5. [Alcance](#5-alcance)
6. [Funcionalidades](#6-funcionalidades)
7. [Requerimientos funcionales](#7-requerimientos-funcionales)
8. [Requerimientos no funcionales](#8-requerimientos-no-funcionales)
9. [Reglas de negocio](#9-reglas-de-negocio)
10. [Modelo de datos](#10-modelo-de-datos)
11. [Pantallas y mapa de navegación](#11-pantallas-y-mapa-de-navegación)
12. [Mockup](#12-mockup)
13. [Historias de usuario, casos de uso, restricciones y supuestos](#13-historias-de-usuario-casos-de-uso-restricciones-y-supuestos)
14. [Arquitectura técnica y navegación implementada](#14-arquitectura-técnica-y-navegación-implementada)
- [Historial de cambios](#historial-de-cambios)
- [Referencias](#referencias)
- [Declaración de uso de inteligencia artificial](#declaración-de-uso-de-inteligencia-artificial)

## 1. Descripción general

VEHICULOS es una app móvil para que el dueño de una moto o un carro sepa qué le vence y cuándo, sin depender de la memoria ni del mecánico. El conductor registra su vehículo con el kilometraje actual, y la app le muestra en un solo panel el próximo mantenimiento (aceite, filtros, kit de arrastre, llantas), la fecha de vencimiento de sus documentos (SOAT, revisión técnico-mecánica e impuesto) y si hoy tiene pico y placa.

La app entiende que un mantenimiento vence por kilómetros **o** por tiempo, lo que llegue primero, como lo indican los fabricantes. Por eso funciona igual para una moto que se usa todos los días y para una secundaria que recorre pocos kilómetros al mes.

Un segundo rol, el mecánico o taller, registra los mantenimientos que realiza. Así el contador de cada ítem se reinicia con el kilometraje real del cambio y no con lo que el conductor recuerda.

## 2. Problema

Hoy el dueño de un vehículo lleva el control de su mantenimiento y sus documentos de memoria, en notas sueltas o en la calcomanía del último cambio de aceite. Eso falla de dos maneras:

- **Se pasan los kilómetros.** El conductor mide el desgaste en tiempo ("hace como tres meses cambié el aceite") y no en kilómetros, que es la medida real. Una moto que se usa a diario puede pasar los 3.000 km del cambio de aceite en seis semanas, mucho antes de los tres meses que dice el manual.
- **Se pasan las fechas.** El SOAT, la revisión técnico-mecánica y el impuesto vencen una vez al año, en fechas distintas, y no hay quien avise. Circular con el SOAT vencido implica multa e inmovilización del vehículo, y con la técnico-mecánica vencida, multa (Código Nacional de Tránsito, Ley 769 de 2002; ver referencias para el valor vigente). Salir un día de pico y placa también es multa.

**[PENDIENTE: un dato concreto del equipo, por ejemplo: "en el último año, a dos de los tres integrantes se les venció un documento sin darse cuenta" o "el cambio de aceite de la Gixxer 250 se hizo a los 4.800 km en vez de a los 3.000".]**

La única alternativa hoy es preguntarle al mecánico, que depende de lo que el conductor le cuente y tiene interés en que el vehículo vuelva al taller.

**Por qué una app móvil y no una hoja de cálculo o una página web:** el kilometraje se lee en el tablero, con el vehículo al frente y el teléfono en la mano. Y la alerta hay que verla antes de salir, no cuando uno se sienta frente al computador. Además, los datos se necesitan sin conexión: en un parqueadero o en carretera no siempre hay señal.

## 3. Objetivos

### 3.1 Objetivo general

Permitir que el conductor sepa, desde su teléfono y sin depender del taller, qué mantenimiento y qué documento le vence a cada vehículo y en cuánto tiempo.

### 3.2 Objetivos específicos

- Que ningún documento ni mantenimiento venza por olvido: cada uno tiene una fecha estimada visible en el panel del vehículo con al menos 15 días de anticipación.
- Que registrar un vehículo tome menos de dos minutos y máximo seis toques después del inicio de sesión.
- Que actualizar el kilometraje tome máximo dos toques desde el panel del vehículo.
- Que el conductor vea si hoy tiene pico y placa al abrir el panel, sin buscarlo en ninguna otra parte.
- Que el reinicio del contador de un mantenimiento lo haga quien lo realizó, el taller, con el kilometraje real del cambio.

## 4. Stakeholders, actores y roles

| Actor o stakeholder | Tipo | Qué hace o qué interés tiene |
|---|---|---|
| Conductor | Rol (usa la app) | Registra sus vehículos, actualiza el kilometraje, ve el panel de cada uno y marca un mantenimiento como hecho. |
| Mecánico o taller | Rol (usa la app) | Ve los vehículos que atiende y registra un mantenimiento realizado con tipo, kilometraje y fecha. Eso reinicia el contador de ese ítem. |
| Secretaría de Movilidad | Stakeholder | Define el pico y placa y cobra el impuesto. No usa la app. |
| Aseguradoras | Stakeholder | Expiden el SOAT, cuya fecha de vencimiento se registra en la app. No usan la app. |
| Fabricantes | Stakeholder | Publican el plan de mantenimiento de cada modelo, de donde salen los intervalos. No usan la app. |

**Login.** Correo y contraseña. El rol viene con la cuenta: una cuenta de conductor entra a Mis vehículos y una cuenta de mecánico entra al Taller. La sesión se mantiene abierta hasta que el usuario la cierra. En esta versión las cuentas son fijas en el código; no hay registro de usuarios.

## 5. Alcance

### 5.1 Incluye

- Inicio de sesión con dos roles: conductor y mecánico.
- Registro de uno o varios vehículos por conductor, de tipo moto o carro.
- Panel por vehículo con kilometraje actual, próximo mantenimiento, vencimiento de SOAT, técnico-mecánica e impuesto, y pico y placa del día.
- Lista de ítems de mantenimiento por vehículo, con intervalo en kilómetros y en meses y cuánto falta para cada uno.
- Actualización del kilometraje por el conductor.
- Registro de mantenimientos realizados por el taller.
- Datos guardados en el teléfono: la información se conserva entre una apertura y la siguiente.

### 5.2 No incluye

- Notificaciones push. En esta versión "avisar" significa mostrarlo en el panel al abrir la app.
- Chatbot, sugerencias de repuestos y comparación de componentes.
- Consulta automática de planes de mantenimiento a una API de fabricantes: los planes se cargan como datos fijos por modelo.
- Nivel de gasolina, estado de la batería, presión de llantas o cualquier dato que requiera sensores del vehículo.
- Registro de gastos, compras o pagos dentro de la app.
- Registro de nuevas cuentas de usuario y recuperación de contraseña.
- Versión para iOS y versión web.
- Pico y placa de ciudades distintas de Medellín.

## 6. Funcionalidades

**Conductor**

- Iniciar y cerrar sesión.
- Ver la lista de sus vehículos con la alerta más próxima de cada uno.
- Registrar un vehículo con tipo, marca, modelo, año, placa, ciudad y kilometraje actual.
- Ver el panel de un vehículo: kilometraje, próximo mantenimiento, documentos y pico y placa de hoy.
- Actualizar el kilometraje de un vehículo.
- Ver la lista de mantenimientos del vehículo y cuánto falta para cada uno.
- Marcar un mantenimiento como hecho.

**Mecánico**

- Iniciar y cerrar sesión.
- Ver la lista de vehículos que atiende.
- Registrar un mantenimiento realizado: vehículo, tipo, kilometraje y fecha.

## 7. Requerimientos funcionales

| ID | Requerimiento | Rol | Prioridad |
|---|---|---|---|
| RF-01 | La app debe permitir iniciar sesión con correo y contraseña y llevar al usuario a la pantalla de su rol. | Todos | Alta |
| RF-02 | La app debe permitir al conductor registrar un vehículo con tipo, marca, modelo, año, placa, ciudad y kilometraje actual. | Conductor | Alta |
| RF-03 | La app debe mostrar al conductor la lista de sus vehículos, cada uno con la alerta más próxima. | Conductor | Alta |
| RF-04 | La app debe mostrar, para el vehículo tocado en la lista, un panel con kilometraje actual, próximo mantenimiento, vencimiento de SOAT, técnico-mecánica e impuesto, y pico y placa de hoy. | Conductor | Alta |
| RF-05 | La app debe permitir al conductor actualizar el kilometraje de un vehículo. | Conductor | Alta |
| RF-06 | La app debe mostrar la lista de ítems de mantenimiento del vehículo con su intervalo en kilómetros y en meses y cuánto falta para cada uno. | Conductor | Alta |
| RF-07 | La app debe calcular el próximo vencimiento de cada ítem por kilómetros y por meses, y mostrar el que llegue primero. | Sistema | Alta |
| RF-08 | La app debe permitir marcar un mantenimiento como hecho, registrando kilometraje y fecha. | Conductor, Mecánico | Alta |
| RF-09 | La app debe mostrar al mecánico la lista de vehículos que atiende. | Mecánico | Media |
| RF-10 | La app debe permitir al mecánico registrar un mantenimiento realizado sobre un vehículo. | Mecánico | Media |
| RF-11 | La app debe indicar si el vehículo tiene pico y placa el día de hoy, según su placa y su ciudad. | Conductor | Media |
| RF-12 | La app debe conservar vehículos, ítems, documentos y mantenimientos entre una apertura y la siguiente. | Sistema | Alta |
| RF-13 | La app debe permitir al conductor ajustar el intervalo de un ítem de mantenimiento para su vehículo. | Conductor | Baja |

## 8. Requerimientos no funcionales

| ID | Categoría | Requerimiento |
|---|---|---|
| RNF-01 | Sin conexión | Toda la información se guarda en el teléfono. El panel, la lista de vehículos y los mantenimientos se ven completos sin conexión a internet. |
| RNF-02 | Rendimiento | La app abre y muestra la lista de vehículos en menos de 3 segundos en un teléfono de gama media. |
| RNF-03 | Usabilidad | Todo elemento táctil mide como mínimo 48 por 48 píxeles lógicos, y la alerta más próxima de cada vehículo se lee sin abrir el panel. |
| RNF-04 | Usabilidad | Actualizar el kilometraje toma máximo dos toques desde el panel del vehículo. |
| RNF-05 | Compatibilidad | Funciona desde Android 8.0 (API 26), en pantallas de 5 a 6,7 pulgadas, en orientación vertical. |
| RNF-06 | Seguridad | La contraseña nunca se guarda en el teléfono en texto plano. |
| RNF-07 | Consumo de datos | La app no usa la red en esta versión; no consume datos móviles. |

## 9. Reglas de negocio

- RN-01. Cada ítem de mantenimiento tiene un intervalo en kilómetros y otro en meses. Vence por el que se cumpla primero.
- RN-02. Los intervalos salen del plan de mantenimiento del modelo. El conductor puede ajustarlos para su vehículo, y el ajuste queda registrado.
- RN-03. El SOAT, la revisión técnico-mecánica y el impuesto vencen solo por fecha, una vez al año.
- RN-04. El pico y placa depende de la ciudad, del tipo de vehículo y del dígito de la placa que use la norma de cada ciudad. En esta versión solo se aplica la regla vigente de Medellín.
- RN-05. Al registrar un mantenimiento como hecho, el ítem vuelve a contar desde el kilometraje y la fecha de ese registro.
- RN-06. La fecha estimada de un vencimiento por kilómetros se calcula con el promedio de kilómetros por día del vehículo, obtenido de las actualizaciones de kilometraje del conductor. Mientras no haya al menos dos actualizaciones, se muestra solo el vencimiento por meses.
- RN-07. Un vehículo pertenece a un solo conductor. Un conductor puede tener varios vehículos.
- RN-08. Un mantenimiento registrado por el taller tiene prioridad sobre uno marcado por el conductor para el mismo ítem, porque trae el kilometraje real del cambio.

## 10. Modelo de datos

| Entidad | Atributos principales | Dónde se guarda |
|---|---|---|
| Usuario | id, nombre, correo, rol (conductor o mecánico) | Teléfono. En esta versión, cuentas fijas en el código |
| Vehículo | id, usuario_id, tipo (moto o carro), marca, modelo, año, placa, ciudad, km_actual, fecha_km | Teléfono |
| ItemMantenimiento | id, vehiculo_id, nombre, intervalo_km, intervalo_meses, ultimo_km, ultima_fecha | Teléfono |
| Documento | id, vehiculo_id, tipo (SOAT, técnico-mecánica, impuesto), fecha_vencimiento | Teléfono |
| MantenimientoRealizado | id, vehiculo_id, item_id, km, fecha, registrado_por (conductor o taller) | Teléfono |

**Relaciones.** Un usuario conductor tiene muchos vehículos. Cada vehículo tiene muchos ítems de mantenimiento, muchos documentos y muchos mantenimientos realizados. Cada mantenimiento realizado corresponde a un ítem.

```mermaid
erDiagram
  USUARIO ||--o{ VEHICULO : posee
  VEHICULO ||--o{ ITEM_MANTENIMIENTO : tiene
  VEHICULO ||--o{ DOCUMENTO : tiene
  VEHICULO ||--o{ MANTENIMIENTO_REALIZADO : registra
  ITEM_MANTENIMIENTO ||--o{ MANTENIMIENTO_REALIZADO : "se cumple con"
```

No hay servidor en esta versión: toda la información vive en el teléfono. Si en el futuro se agrega un servidor, el teléfono conservaría una copia local para cumplir RNF-01.

## 11. Pantallas y mapa de navegación

| ID | Pantalla | Rol | Para qué sirve | Atiende |
|---|---|---|---|---|
| P-01 | Inicio de sesión | Todos | Entrar con correo y contraseña. Según el rol, lleva a P-02 o a P-06. | RF-01, RNF-06 |
| P-02 | Mis vehículos | Conductor | Lista de vehículos del conductor con placa, modelo y la alerta más próxima de cada uno. Botón para registrar uno nuevo. | RF-03, RNF-03 |
| P-03 | Panel del vehículo | Conductor | Recibe el vehículo tocado en P-02. Muestra kilometraje actual, próximo mantenimiento, SOAT, técnico-mecánica, impuesto y pico y placa de hoy. Permite actualizar el kilometraje. | RF-04, RF-05, RF-07, RF-11 |
| P-04 | Registrar vehículo | Conductor | Formulario con tipo, marca, modelo, año, placa, ciudad y kilometraje actual. | RF-02 |
| P-05 | Mantenimientos | Conductor | Lista de ítems del vehículo con intervalo en km y meses y cuánto falta para cada uno. Permite marcar uno como hecho. | RF-06, RF-07, RF-08, RF-13 |
| P-06 | Taller | Mecánico | Lista de vehículos atendidos y formulario para registrar un mantenimiento realizado. | RF-09, RF-10, RF-08 |

```mermaid
flowchart LR
  P01[P-01 Inicio de sesión] -->|Ingresar como conductor| P02[P-02 Mis vehículos]
  P01 -->|Ingresar como mecánico| P06[P-06 Taller]
  P02 -->|Tocar un vehículo| P03[P-03 Panel del vehículo]
  P02 -->|Botón +| P04[P-04 Registrar vehículo]
  P03 -->|Ver mantenimientos| P05[P-05 Mantenimientos]
```

Todas las flechas son `Navigator.push`. Desde cada pantalla se vuelve a la anterior con `Navigator.pop`, con la flecha del `AppBar` y con el botón Atrás del sistema. Desde P-02 y P-06, "Cerrar sesión" hace `pop` hacia P-01.

## 12. Mockup

Las imágenes están en `docs/mockup/`, una por pantalla, con el mismo identificador de la sección 11.

**[PENDIENTE: renombrar las imágenes existentes y hacer las que faltan (P-01, P-02, P-06). Cada imagen va acompañada de dos o tres líneas que expliquen qué hay en ella.]**

### P-01 Inicio de sesión

![P-01 Inicio de sesión](mockup/p01-login.png)

Formulario centrado con correo, contraseña y botón "Iniciar sesión". Sin enlace de registro, porque las cuentas son fijas en esta versión.

### P-02 Mis vehículos

![P-02 Mis vehículos](mockup/p02-mis-vehiculos.png)

Lista de tarjetas, una por vehículo, con placa, marca y modelo y la alerta más próxima ("Cambio de aceite en 400 km", "SOAT vence en 12 días"). Botón flotante "+" para registrar un vehículo y "Cerrar sesión" en el `AppBar`.

### P-03 Panel del vehículo

![P-03 Panel del vehículo](mockup/p03-panel-vehiculo.png)

Kilometraje actual arriba, con botón para actualizarlo. Debajo, la alerta más próxima destacada, las tarjetas de SOAT, técnico-mecánica e impuesto con su fecha, y una franja que dice si hoy hay pico y placa. Botón "Ver mantenimientos".

### P-04 Registrar vehículo

![P-04 Registrar vehículo](mockup/p04-registrar-vehiculo.png)

Formulario con selector de tipo (moto o carro), campos de marca, modelo, año, placa, ciudad y kilometraje actual, y botón "Guardar".

### P-05 Mantenimientos

![P-05 Mantenimientos](mockup/p05-mantenimientos.png)

Lista de ítems del vehículo. Cada fila muestra el nombre, el intervalo ("cada 3.000 km o 3 meses"), cuánto falta por kilómetros y por fecha, y un botón "Hecho".

### P-06 Taller

![P-06 Taller](mockup/p06-taller.png)

Lista de vehículos atendidos por placa y modelo. Al tocar uno, formulario con tipo de mantenimiento, kilometraje y fecha, y botón "Registrar".

## 13. Historias de usuario, casos de uso, restricciones y supuestos

### 13.1 Historias de usuario

- **HU-01.** Como conductor, quiero registrar mi vehículo con su kilometraje actual, para que la app sepa desde dónde contar cada mantenimiento.
- **HU-02.** Como conductor, quiero ver en un solo panel qué le vence a mi vehículo y en cuánto, para no enterarme cuando ya pasó.
- **HU-03.** Como conductor, quiero actualizar el kilometraje en dos toques, para hacerlo cada vez que tanqueo sin que me dé pereza.
- **HU-04.** Como conductor, quiero saber si hoy tengo pico y placa antes de salir, para no llevarme la multa.
- **HU-05.** Como conductor con dos vehículos, quiero verlos en una sola lista con la alerta de cada uno, para no revisar uno por uno.
- **HU-06.** Como mecánico, quiero registrar el mantenimiento que acabo de hacer con el kilometraje real, para que el próximo aviso del cliente sea correcto.

### 13.2 Casos de uso

**Caso de uso 1: registrar un vehículo.**
Actor: conductor. Precondición: tiene sesión iniciada y está en Mis vehículos (P-02). Flujo: toca el botón "+", llena tipo, marca, modelo, año, placa, ciudad y kilometraje actual, y toca "Guardar"; la app crea el vehículo con los ítems de mantenimiento del plan de su modelo y vuelve a la lista, donde ya aparece. Excepción: si la placa ya está registrada, la app no guarda y muestra el mensaje "Esa placa ya existe".

**Caso de uso 2: registrar un mantenimiento realizado.**
Actor: mecánico. Precondición: tiene sesión iniciada como mecánico y el vehículo ya existe. Flujo: en Taller (P-06) toca el vehículo, elige el tipo de mantenimiento, escribe el kilometraje y la fecha, y toca "Registrar"; la app guarda el mantenimiento y reinicia el contador de ese ítem desde ese kilometraje y esa fecha (RN-05). Excepción: si el kilometraje es menor que el último registrado para ese vehículo, la app lo rechaza y lo explica.

**Caso de uso 3: ver el próximo vencimiento.**
Actor: conductor. Precondición: el vehículo tiene kilometraje registrado. Flujo: toca el vehículo en Mis vehículos; la app calcula, para cada ítem, cuánto falta por kilómetros y cuánto por meses, muestra el que llegue primero (RN-01) y destaca el más cercano en el panel. Excepción: si solo hay una actualización de kilometraje, la app no puede estimar el ritmo de uso y muestra solo el vencimiento por meses (RN-06).

### 13.3 Restricciones

- Solo Android en esta versión.
- Solo se implementa con lo visto en clase: `StatelessWidget`, `StatefulWidget`, `Scaffold`, `ListView.builder`, `TextField`, `Navigator.push` y `Navigator.pop`. Sin paquetes de navegación ni de manejo de estado.
- Los planes de mantenimiento se cargan como datos fijos por modelo; no hay consulta a fabricantes.
- El pico y placa se aplica solo con la regla de Medellín.

### 13.4 Supuestos

- El conductor conoce el kilometraje de su vehículo y lo actualiza al menos una vez al mes.
- El plan de mantenimiento del fabricante está disponible en el manual del propietario de cada modelo.
- El taller que atiende el vehículo está dispuesto a registrar el mantenimiento en la app.
- El teléfono tiene la fecha del sistema correcta; de ella dependen los vencimientos por meses y el pico y placa del día.

## 14. Arquitectura técnica y navegación implementada

**Entorno.** Flutter **[PENDIENTE: salida de `flutter --version`]**, Dart **[PENDIENTE]**.

**Paquetes previstos.** Ninguno adicional en esta versión: solo el SDK de Flutter. Para guardar los datos en el teléfono en una versión futura se prevé `shared_preferences` o `sqflite`, cuando se vean en clase.

**Estructura de `lib/`.**

```
lib/
  main.dart                       punto de entrada; home es P-01
  modelos/
    vehiculo.dart                 clases Vehiculo, ItemMantenimiento y Documento, y los datos fijos de ejemplo
  pantallas/
    login.dart                    P-01
    mis_vehiculos.dart            P-02
    panel_vehiculo.dart           P-03
    registrar_vehiculo.dart       P-04
    mantenimientos.dart           P-05
    taller.dart                   P-06
  widgets/
    tarjeta_vehiculo.dart         tarjeta reutilizada en P-02 y P-06
```

**Tabla de rutas.**

| Pantalla | Archivo | Se llega desde | Recibe |
|---|---|---|---|
| P-01 | `lib/pantallas/login.dart` | Es el `home` de `main.dart` | Nada |
| P-02 | `lib/pantallas/mis_vehiculos.dart` | P-01, con `Navigator.push` al ingresar como conductor | El correo del usuario |
| P-03 | `lib/pantallas/panel_vehiculo.dart` | P-02, con `Navigator.push` al tocar un vehículo | El vehículo tocado |
| P-04 | `lib/pantallas/registrar_vehiculo.dart` | P-02, con `Navigator.push` desde el botón + | Nada |
| P-05 | `lib/pantallas/mantenimientos.dart` | P-03, con `Navigator.push` desde "Ver mantenimientos" | El vehículo |
| P-06 | `lib/pantallas/taller.dart` | P-01, con `Navigator.push` al ingresar como mecánico | El correo del usuario |

**Cómo viaja el dato de la lista al detalle.** El vehículo tocado en P-02 se pasa por el constructor de P-03, como se hizo en la actividad de la semana 5:

```dart
onTap: () {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => PanelVehiculo(vehiculo: vehiculo),
    ),
  );
},
```

**Datos fijos de ejemplo.** Una moto Suzuki Gixxer 250, placa **[PENDIENTE]**, Medellín, con el plan de revisiones del manual: 1.000, 3.000, 6.000, 9.000 y 12.000 km, o 1, 3, 6, 9 y 12 meses, lo que ocurra primero. Con eso se muestra el cálculo de RN-01 en la sustentación.

## Historial de cambios

| Fecha | Qué cambió | Quién |
|---|---|---|
| 22/08/2026 | Primer commit del proyecto Flutter. | Anderson Sánchez |
| 29/08/2026 | SRS inicial en `docs/mockups/srs.md` y mockups del panel, documentación, mantenimiento y mi vehículo. | Anderson Sánchez, David Muñoz |
| 23/09/2026 | Migración del SRS a este documento con las 14 secciones. Se definen dos roles, seis pantallas y el mapa de navegación. Se saca del alcance el chatbot, la API de fabricantes y los datos de sensores. | **[PENDIENTE: quién hace el commit]** |

## Referencias

- Oscar Sánchez, "Semana 5. Navegación entre pantallas", curso IF2004, 2026-02. Usada para la sección 14 y para el patrón de paso de datos por constructor. Enlace: https://oscarleosanchez.github.io/sitio-iue-2026-02/movil/semana-05/
- Flutter, "Navigation and routing". Usada para la sección 14. Enlace: https://docs.flutter.dev/ui/navigation
- Congreso de Colombia, Ley 769 de 2002, Código Nacional de Tránsito. Usada para la sección 2 (consecuencias de circular sin SOAT o sin revisión técnico-mecánica). **[PENDIENTE: enlace y valor vigente de la multa en SMLDV]**
- Alcaldía de Medellín, Secretaría de Movilidad, decreto vigente de pico y placa. Usada para RN-04 y RF-11. **[PENDIENTE: enlace al decreto vigente]**
- Suzuki, manual del propietario de la Gixxer 250, plan de mantenimiento. Usada para RN-01, RN-02 y los datos fijos de la sección 14. **[PENDIENTE: año del manual]**

## Declaración de uso de inteligencia artificial

**Herramientas.** Claude (Anthropic), en la interfaz de chat y en Claude Code.

**Para qué se usó.**

- Estructura de este documento: Claude organizó en las 14 secciones de la plantilla el contenido del SRS que el equipo había escrito en agosto (problema, stakeholders, objetivos, reglas y casos de uso).
- Primer borrador de las secciones 4, 7, 8, 9, 10, 11 y 14, a partir de las decisiones que el equipo tomó en la reunión del 23 de septiembre: los dos roles, las seis pantallas, la regla "kilómetros o meses, lo que llegue primero" y el plan de mantenimiento de la Gixxer 250 que aportó un integrante.
- Código de navegación de la actividad de la semana 5, cuyo patrón se reutiliza en la sección 14.

**Qué aceptamos.** **[PENDIENTE: llenar después de revisar el documento. Por ejemplo: la separación de documentos (por fecha) y mantenimientos (por km o meses); el rol de mecánico como quien reinicia el contador.]**

**Qué corregimos.** **[PENDIENTE: llenar después de revisar. Por ejemplo: intervalos del plan, nombres de pantallas, datos del problema.]**

**Qué descartamos.** **[PENDIENTE: llenar después de revisar.]**

**Qué escribimos nosotros.** El problema original y los stakeholders del SRS de agosto, la elección del tema y de los roles, los mockups, el dato concreto de la sección 2, las referencias y el código de las pantallas.
