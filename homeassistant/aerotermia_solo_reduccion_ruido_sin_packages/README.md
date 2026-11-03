# Calendario de reducción de ruido

Se crea desde la interfaz. No usa packages ni sensores MQTT propios.

Los scripts preguntan a ebusd (`ebusd/bass2/SilentTimer_…`) y guardan la última lectura en helpers. Escribir en el bus solo ocurre al ejecutar el script de aplicar.

No toca la automatización que ya cambia el porcentaje: `automation.aerothermal_set_noise_reduction_level`, ni `input_datetime.aerothermal_noise_reduction_low_level` / `high_level`, ni los dos `input_number` del mismo nombre.

El panel lee el estado que ya existe: `binary_sensor.ebusd_broadcast_noisereduction_onoff` y `number.ebusd_full_noisereductionlevel_value`.

Al crear cada helper o script, el nombre de abajo genera el id. Si Home Assistant le añade un sufijo, cámbialo en los ajustes de la entidad para que coincida.

## 1. Helpers

Ajustes → Dispositivos y servicios → Helpers → Crear helper.

**Lista desplegable**

- Nombre: `Aerothermal noise reduction schedule day`
- Id: `input_select.aerothermal_noise_reduction_schedule_day`
- Icono: `mdi:calendar-week`
- Opciones, en este orden: Lunes, Martes, Miércoles, Jueves, Viernes, Sábado, Domingo

**Fecha y/u hora**, solo hora, seis veces:

| Nombre | Id |
|---|---|
| Aerothermal noise reduction schedule slot 1 from | `input_datetime.aerothermal_noise_reduction_schedule_slot_1_from` |
| Aerothermal noise reduction schedule slot 1 to | `input_datetime.aerothermal_noise_reduction_schedule_slot_1_to` |
| Aerothermal noise reduction schedule slot 2 from | `input_datetime.aerothermal_noise_reduction_schedule_slot_2_from` |
| Aerothermal noise reduction schedule slot 2 to | `input_datetime.aerothermal_noise_reduction_schedule_slot_2_to` |
| Aerothermal noise reduction schedule slot 3 from | `input_datetime.aerothermal_noise_reduction_schedule_slot_3_from` |
| Aerothermal noise reduction schedule slot 3 to | `input_datetime.aerothermal_noise_reduction_schedule_slot_3_to` |

**Texto**, longitud máxima 255, siete veces. Son la última lectura de cada día:

| Nombre | Id |
|---|---|
| Aerothermal noise reduction schedule Monday | `input_text.aerothermal_noise_reduction_schedule_monday` |
| Aerothermal noise reduction schedule Tuesday | `input_text.aerothermal_noise_reduction_schedule_tuesday` |
| Aerothermal noise reduction schedule Wednesday | `input_text.aerothermal_noise_reduction_schedule_wednesday` |
| Aerothermal noise reduction schedule Thursday | `input_text.aerothermal_noise_reduction_schedule_thursday` |
| Aerothermal noise reduction schedule Friday | `input_text.aerothermal_noise_reduction_schedule_friday` |
| Aerothermal noise reduction schedule Saturday | `input_text.aerothermal_noise_reduction_schedule_saturday` |
| Aerothermal noise reduction schedule Sunday | `input_text.aerothermal_noise_reduction_schedule_sunday` |

## 2. Scripts

Ajustes → Automatizaciones y escenas → Scripts → Crear script → Editar en YAML. Pega el fichero y guarda. El orden importa: load antes que select.

| Fichero | Id |
|---|---|
| `scripts/refresh.yaml` | `script.aerothermal_noise_reduction_schedule_refresh` |
| `scripts/load.yaml` | `script.aerothermal_noise_reduction_schedule_load` |
| `scripts/select.yaml` | `script.aerothermal_noise_reduction_schedule_select` |
| `scripts/apply.yaml` | `script.aerothermal_noise_reduction_schedule_apply` |

`apply` escribe en el bus. Los otros solo leen.

## 3. Vista

En el dashboard, editor de código, pega `dashboard/vista_reduccion_ruido.yaml` dentro de `views:`. Usa las tarjetas mushroom que ya tienes en el panel principal.
