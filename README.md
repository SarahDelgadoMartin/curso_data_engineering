# 🚀 Proyecto de Data Engineering – dbt Cloud + Snowflake

Este repositorio contiene el proyecto final de mi formación en **Data Engineering** en **Cívica**, en el que he construido un pipeline completo utilizando **dbt Cloud** y **Snowflake** como herramientas principales del ecosistema moderno de datos.

---

## 🎯 Objetivo

Simular un flujo completo de datos en un entorno controlado, aplicando buenas prácticas de modelado, calidad, versionado y documentación. El pipeline incluye desde la ingestión de datos hasta su transformación en modelos analíticos listos para análisis.

---

## ⚙️ Tecnologías utilizadas

- **dbt Cloud** para la gestión de transformaciones y documentación
- **Snowflake** como Data Warehouse
- **Python con `snowflake-connector-python`** para ingestión de datos
- **Google Colab** para simular ingestión incremental
- **SQL + Jinja** para modelado declarativo
- **GitHub** para control de versiones

---

## 🔍 Aspectos destacados del proyecto

- ✅ Ingesta incremental simulada desde Python
- ✅ Uso de `snapshots` para mantener historial de cambios
- ✅ Modelo de capas (Medallion): Bronze (sources) → Silver (staging) → Gold (marts)
- ✅ Implementación de `tests` en dbt: unicidad, nulos, relaciones
- ✅ Tablas incrementales para eficiencia y ahorro de costes
- ✅ Documentación generada con `dbt docs`
- ✅ Uso de `macros` y `variables` para facilitar la reutilización y escalabilidad

---

## 📓 Notebooks y scripts relevantes

- 📘 [Ingesta incremental (Google Colab)](https://colab.research.google.com/drive/1cu5UXXt1PmP8xRNmWCegkAhwUUG0Jexg?usp=sharing)
- 📄 [`script_ingesta.sql`](./data/script_ingesta.sql) – Script SQL para cargar datos iniciales en Snowflake

---

## 🧪 Validación y calidad

Se han definido múltiples tests automáticos con dbt para asegurar la integridad de los datos, incluyendo:
- Tests de unicidad en claves primarias
- Tests de no nulos en campos obligatorios
- Tests de relaciones entre tablas
- Tests personalizados a través de macros

---

## 🧭 Documentación del proyecto

Puedes generar la documentación navegable ejecutando:

```bash
dbt docs generate
dbt docs serve
```

O consultarla directamente desde dbt Cloud si estás autenticado.


# 🎥 Presentación del proyecto

🎬 [Enlace a publicación en LinkedIn](https://www.linkedin.com/posts/sarah-delgado-martin-934667142_dataengineering-dbt-snowflake-activity-7337750305746354176-HeU3)

---

## 📫 Contacto

Si quieres saber más sobre el proyecto, colaborar o compartir ideas sobre ingeniería de datos, ¡estoy encantada de conectar!

🔗 [Mi perfil en LinkedIn](https://www.linkedin.com/in/sarah-delgado-martin-934667142/)

---

## 📄 Licencia

Este proyecto es de carácter educativo, orientado al aprendizaje de herramientas modernas de ingeniería de datos.

Distribuido bajo la licencia [Creative Commons Attribution-NonCommercial 4.0 International (CC BY-NC 4.0)](https://creativecommons.org/licenses/by-nc/4.0/deed.es).

Esto significa que puedes usar, compartir y adaptar este trabajo **siempre que**:
- Des crédito apropiado.
- No lo utilices con fines comerciales.
- Indiques si realizas cambios.

Para más detalles, consulta el texto completo de la licencia [aquí](https://creativecommons.org/licenses/by-nc/4.0/legalcode).
