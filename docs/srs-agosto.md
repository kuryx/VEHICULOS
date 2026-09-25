Hoy en día los conductores tienden a tener malas prácticas al momento de hacer revisar o evaluar su vehículo, entre estas se incluye la medida de desgaste en tiempo y no en kilómetros. Al hacer esto arriesgan a desgastar de más el estado interno(mecánico) y externo(visual) del vehículo generando gastos innecesarios a futuro. 

El comprador tiene solo una opción que sería ir al mecánico dependiendo de un externo que puede o no decir la verdad. 

 

StakeHolders 

    Usuarios 

    Mecanicos 

    Secretaria de Movilidad 

    Distribuidoras de repuestos/llantas 

 

Objetivos 
 

    Medición para cambios 

        Actual: Depende de lo que se conozca popularmente  sobre el tiempo que se tarda el vehículo en necesitar algún cambio mecánico 

        Objetivo: Calcular precisamente el tiempo en el que el conductor consume los kilómetros necesarios para necesitar algún cambio con respecto a lo sugerido por el fabricante y predecir futuros cambios con datos dados previamente.

    Dependencia de externos 

        Actual: Los conductores deben de ir donde un mecanico o “llevarse por la intuición” 

        Objetivo: Segun el modelo, el uso y los kilometros del vehiculo la aplicacion sugerira en cuento tiempo debera de hacerse los cambios en cualquier momento del dia

    Sugerencias de cambios 

        Actual: Los conductores dependen de sugerencias externas de personas que no conocen al 100% la forma de conduccion del piloto 

        Objetivo: La aplicacion sugerira cambios a hacer para que el vehiculo tenga un mayor rendimiento gracias a componentes diferentes en un tiempo maximo de 20 segundos.  

Restricciones

    Calculo
        Se calculara segun lo recomendado por el fabricante el tiempo en el que se deben hacer los cambios al vehiculo.
    
    información
        Los datos de los vehiculos pueden ser diferentes segun la informacion recolectada entre fabricantes o por los diseñadores de las APIs.
    
    sin informacion
        Si la aplicación no puede recoectar informacion del usuario tratara de dar un estimado según el vehiculo que el usuario posea.


Alcance
    Incluye:

        Calculos Automaticos
        Bases de datos variadas de vehiculos terrestres
        chatbot
        Información adicional de los vehiculos

    No incluye

        compras en la app

Conceptos del dominio

    -Usuario/Conductor. Persona dueña o encargada de un vehiculo, que registra su uso para recibir estimaciones.

    -Vehiculo. Automovil o motocicleta con una ficha tecnica (marca, modelo, año) asociada a un usuario.

    -Kilometraje. Distancia recorrida acumulada por el vehiculo, base real del calculo (no el tiempo).

    -Cambio/Mantenimiento. Una intervencion mecanica sugerida por el fabricante (aceite, llantas, filtros, etc.) asociada a un intervalo de kilometros.

    -Recomendacion del fabricante. El intervalo oficial (en km) en que un cambio debe hacerse, segun el fabricante del vehiculo.

    -Estimacion. Prediccion que hace la app sobre cuando (en tiempo o km) el usuario llegara al proximo cambio, segun su ritmo de uso.

    Un Usuario posee uno o varios Vehiculos, cada uno acumula Kilometraje, y sobre cada Vehiculo la app calcula Estimaciones de Cambios segun la Recomendacion del fabricante correspondiente.

Reglas del negocio

    RN-01. un vehiculo necesita ser usado para poder hacer estimaciones concretas

    RN-02. un usuario debe de estar seguro cuanto usa en su vehiculo en un tiempo estadar (semanal/mensual/anual)

    RN-03. Los fabricantes deben de dar informacion concreta sobre las necesidades del vehiculo

    RN-04. Un cambio sugerido solo se muestra si existe una recomendacion del fabricante para ese modelo de vehiculo; si no existe, la app usa el estimado generico que mencionas en (sin informacion).

Actores

    -Actor principal: el Conductor/Usuario. Registra su vehiculo y su uso, y recibe las estimaciones.
    
    -Actor secundario: el Mecanico. No necesariamente usa la app directamente, pero podria confirmar o corregir cambios ya hechos (segun que tan lejos quieras llevar el alcance).

    -Sistema externo: API de datos del fabricante / base de datos de vehiculos. Provee las recomendaciones de cambio por modelo.

    -Sistema externo: chatbot. es otro "actor" en el sentido de que interactua con el usuario dentro de la app.

    Nota:la Secretaria de Movilidad y las Distribuidoras son stakeholders (les interesa el proyecto) pero no interactuan directamente con la app.

Historias de usuario

    -Como conductor, quiero registrar mi vehiculo y su kilometraje actual, para que la app calcule cuando necesitare el proximo cambio.

    -Como conductor, quiero ver en cuanto tiempo o kilometros debo hacer el proximo mantenimiento, para planear el gasto con anticipacion.

    -Como conductor, quiero recibir sugerencias de repuestos o componentes alternativos, para mejorar el rendimiento de mi vehiculo.

    -Como conductor, quiero preguntarle al chatbot dudas sobre mi vehiculo, para resolver inquietudes sin depender de un mecanico externo.

Casos de uso

    Caso de uso: Calcular el proximo cambio sugerido

        Actor. Conductor.

        Precondicion. El vehiculo ya esta registrado con marca, modelo y kilometraje actual.

        Flujo principal

            1.El conductor actualiza el kilometraje de su vehiculo.

            2.La app consulta la recomendacion del fabricante para ese modelo.

            3.La app calcula el tiempo/kilometros restantes para el proximo cambio.

            4.La app muestra la estimacion al conductor.

        Excepcion. Si no hay informacion del fabricante para ese modelo, la app muestra un estimado generico en vez de la estimacion precisa.

    Caso de uso: Registrar un vehiculo nuevo

        Actor. Conductor.

        Precondicion. El conductor tiene una cuenta creada en la app, pero aun no ha registrado el vehiculo.

        Flujo principal

            1.El conductor ingresa a la opcion "agregar vehiculo". 

            2.El conductor indica marca, modelo, año y kilometraje actual.

            3.La app busca en su base de datos las recomendaciones del fabricante para ese modelo.

            4-La app confirma el registro y muestra el vehiculo en la lista con sus primeros cambios sugeridos.
        
        Excepcion. Si la marca o modelo no existe en la base de datos de la app, el vehiculo se registra igual, pero sin recomendaciones especificas del fabricante — la app aclara que dara solo estimados genericos hasta tener mas informacion.

    Caso de uso: Consultar al chatbot

        Actor. Conductor.

        Precondicion. El conductor tiene al menos un vehiculo registrado en la app.

        Flujo principal

            1.El conductor abre el chatbot desde cualquier pantalla de la app.

            2.El conductor escribe su pregunta sobre su vehiculo (por ejemplo, sobre un cambio o un ruido).

            3.El chatbot cruza la pregunta con los datos del vehiculo (modelo, kilometraje, historial de cambios).

            4.El chatbot responde en un maximo de 20 segundos, segun lo definido en tus objetivos.
        
        Excepcion. Si la pregunta no esta relacionada con el vehiculo o el chatbot no tiene informacion suficiente para responder, sugiere contactar a un mecanico en vez de dar una respuesta imprecisa.

Flujo de pantallas

    Flujo principal (registro + consulta de estimaciones):

        1.Pantalla de inicio / login → el conductor entra a la app.

        2.Mis vehiculos (lista) → si no tiene vehiculos registrados, la app lo lleva directo a "agregar vehiculo"; si ya tiene, ve la lista con su kilometraje actual.

        3.Agregar vehiculo (marca, modelo, año, kilometraje) → confirma el registro → vuelve a "Mis vehiculos" con el vehiculo nuevo en la lista.

        4.Detalle del vehiculo → el conductor toca un vehiculo de la lista y ve su kilometraje, historial y proximos cambios sugeridos.

        5.Estimacion de un cambio especifico → el conductor toca un cambio puntual (por ejemplo, "aceite") y ve el detalle: kilometros/tiempo restante, recomendacion del fabricante, y sugerencias de repuestos alternativos.

    Rama secundaria (chatbot):   

        Desde cualquier pantalla, un boton fijo abre el chatbot, que responde usando los datos del vehiculo activo, y desde ahi el conductor puede volver a donde estaba. 

    Rama de actualizacion:

        Desde "Detalle del vehiculo", el conductor puede ir a actualizar kilometraje, lo que recalcula las estimaciones y lo regresa al detalle actualizado.

Propuestas de diseño y mockups

    Mis vehiculos (lista)

        -Arriba: un encabezado simple ("Mis vehiculos") y un boton "+" para agregar uno nuevo.

        -En medio: tarjetas, una por vehiculo, con marca/modelo, kilometraje actual y un icono de alerta si algun cambio esta proximo o vencido.

        -Accion principal: tocar una tarjeta para ir al detalle del vehiculo.

    Detalle del vehiculo

        -Arriba: nombre del vehiculo (marca/modelo/año) y su kilometraje actual, con un boton para actualizarlo.

        -En medio: una lista de los proximos cambios (aceite, llantas, filtros, etc.), cada uno con una barra o indicador de que tan cerca esta (en km o tiempo).

        -Accion principal: tocar un cambio especifico para ver su estimacion detallada.

    Estimacion de un cambio especifico

        -Arriba: el nombre del cambio (por ejemplo, "Cambio de aceite") y cuanto falta, en tiempo y en kilometros.

        -En medio: la recomendacion del fabricante (intervalo oficial) comparada con el ritmo real de uso del conductor, y debajo, sugerencias de repuestos o componentes alternativos.

        -Accion principal: boton para marcar el cambio como "ya realizado", lo que actualiza el historial.

    Chatbot
+
        -Arriba: cuadro de conversacion tipo chat, con el vehiculo activo indicado en un encabezado pequeño.

        -En medio: el historial de la conversacion.

        -Accion principal: campo de texto fijo abajo para escribir la pregunta, con respuesta en maximo 20 segundos.