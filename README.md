SimpleCos
========

SimpleCos es un sencillo aplicativo de software para tarificar
el consumo de minutos de los clientes. Actualmente
tiene la capacidad de administrar multiples terminales freeswitch
por medio del modulo xml_curl y mod_nibble_curl para tarificacion
remota.

Caracteristicas
==============

 * Rails 3.2.8
 * Thin(recomendado)

Caracteristicas Administracion
==============================

 * Gestion multiples terminales freeswitch con tarificacion distribuida
 * Gestion de clientes y cuentas de consumo.
 * Plan de consumo para clientes.
 * Sencillo CDR

Caracteristicas Clientes
==========

 * Peticion de recarga, consumo
 * CDR diario, semanal y mensual. (aun no implementado)
 * Ultimas 10 llamadas. (aun no implementado)

Recomendaciones
==============

 * You must ensure that the "accept-blind-reg" parameter is set to "false" in sofia.conf.xml, otherwise your web application will not get called. 

Freeswitch
==========

 * Modulos: mod_nibblebill_curl, mod_xml_curl, mod_xml_cdr

Configuracion
-------------
 * Activar modulo mod_xml_curl, configurar para que apunte a: app/dialplan.xml, app/directory.xml, app/configuration.xml
 * compilar y activar modulo mod_nibblebill_curl, configurar: url_lookup => app/bill/${nibble_account}, url_save => app/bill/${nibble_account}
