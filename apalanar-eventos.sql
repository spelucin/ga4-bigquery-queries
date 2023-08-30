-- 1. Aplanar parámetros de eventos --
---- Esta consulta te permite colocar de manera tabular
---- la data de parámetros de eventos de Google Analytics 4.

--- 1.1. Seleccionar un solo evento
----- #1: "proyecto.analytics_12345689.events_*": Nombre de la tabla a consultar.
----- #2: "nombre_evento": Nombre del evento a aplanar
----- #3: "param1_str": Nombre y valores del parámetro 1, donde el valor es de tipo string.
----- #4: "param2_double": Nombre y valores del parámetro 2, donde el valor es de tipo double.
----- #5: "param3_int": Nombre y valores del parámetro 2, donde el valor es de tipo int.
----- #6 Las dos últimas lineas se usan en Looker Studio para el funcionamiento de los controles de fechas. 

SELECT event_name, event_timestamp, user_pseudo_id, 
  (SELECT value.string_value FROM UNNEST(event_params) 
    WHERE key = "param1_str") AS param1_str, -- #3
  (SELECT value.double_value FROM UNNEST(event_params) 
    WHERE key = "param2_double") AS param2_double, -- #4
  (SELECT value.int_value FROM UNNEST(event_params) 
    WHERE key = "param3_int") AS param3_int -- #5
FROM `proyecto.analytics_12345689.events_*` -- #1
WHERE event_name = "nombre_evento" -- #2
AND
  _TABLE_SUFFIX BETWEEN @DS_START_DATE AND @DS_END_DATE -- #6

--- 1.2. Seleccionar varios eventos con los mismos parámetros
----- Para consultar por dos eventos de nombre distinto, debemos añadir una cláusula OR
----- luego del WHERE, de esta manera se llama un evento u otro.
------ #7 nombre_evento2: El nombre del segundo evento a consultar.

SELECT event_name, event_timestamp, user_pseudo_id, 
  (SELECT value.string_value FROM UNNEST(event_params) 
    WHERE key = "param1_str") AS param1_str,
  (SELECT value.double_value FROM UNNEST(event_params) 
    WHERE key = "param2_double") AS param2_double,
  (SELECT value.int_value FROM UNNEST(event_params) 
    WHERE key = "param3_int") AS param3_int
FROM `proyecto.analytics_12345689.events_*`
WHERE event_name = "nombre_evento1" OR event_name = "nombre_evento2" -- #7
AND
  _TABLE_SUFFIX BETWEEN @DS_START_DATE AND @DS_END_DATE