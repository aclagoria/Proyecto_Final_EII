# Proyecto Final - Electrónica II para ingenieria electrónica -2022

## Generador de señales VGA y presentación en pantalla de imagen
Una señal de video VGA contiene 5 señales activas. Se utilizan dos señales compatibles con niveles lógicos TTL, sincronización horizontal y sincronización vertical, para la sincronización de video. Se utilizan tres señales analógicas con niveles de pico a pico de 0,7 a 1 voltio para controlar el color.Las señales de color son rojo, verde y azul, conocidas como señales RGB, que al cambiar los niveles analógicos de estas se producen los demás colores.
En el formato VGA estandart, la pantalla contiene 640 por 480 pixeles y su frecuencia de actualización es de 60 Hz  

## Interantes del grupo
-Capilla Koehler, Patricio
-Lagoria, Alicia Carolina

## Objetivo
Este proyecto tiene la finalidad de generar señales VGA y presentar imagenes por pantalla mediante el uso de la placa de desarrollo edu-fpga-ciaa, volcando así los conocimientos adquiridos durante el cursado de la materia. 
## Descripcion
Nuestro proyecto muestra por pantalla un texto fijo (precargado en codigo ASCII) de 5 caracteres , centrado en la pantalla. A su vez posee dos lineas (de 20 caracteres) una superior y otra inferior que hacen de marco para nuestro texto.
Al decidir hacer una salida monocromatica en vez de tener 5 señales de salida constamos con 3, una de sinconización horizontal y otra vertical y una salida activa alta, que mediante el uso de 3 resistencias se conecta a los pines de la ficha hembra DB15 correspondientes a las señales RGB.
## Composición
Para llevar a cabo la implementación deseada contamos de los siguientes 6 modulos:
**SINCRONISMO:** Tiene como entradas una de reset y otra de reloj (clk) utilizamos uno de 25,175 MHz, que es la velocidad de datos por panta de 640 por 480 pixeles VGA de aproximadamente 40 ns, para controlar los contadores que generan las señales sincronización horizontal y vertical (las salidas sinc_h y sinc_v del módulo). Los contadores generan las salidas: fila y columna. Tambien tiene una salida activa alta cuando está en la zona de visualización de pantalla.
**GRILLA:** Este módulo tiene por finalidad determinar las zonas en las que estará el texto. Cuenta con las entradas de columna, fila y visible proporcionadas por el módulo anteriormente descripto. Y posee como salidas a: celda de 3 bit, fila_celda de 2 bit, columna_celda 2 bit, en_celda 1 bit (activa alta).
**TEXTO FIJO:**Aquí se le asigna un valor de dirección (su salida) según la posicion de las celdas (su entrada), que será enviado a la Tabla de caracteres para extraer de allí los códigos de las letras que se quieren mostrar.
**TABLA DE CARACTERES:**Es una memoria ROM que contiene en codigo ASCII la fuente ibmbios. Possee una entrada de dirección de 8 bit y una de salida de 64 bit. La generación de esta tabla fue en base al código proporcionado por el docente.
**IMPRESIÓN DE PANTALLA:**Como entradas de este tenemos las salidas dato del módulo anterior y las salidas fila_celda, columna_celda y en_caracter del módulo grilla. Mediante estas asignamos la posición en el dato que proviene de ROM que será asignado al valor pixel de salida en estado activo alto.
**TOP**: Este módulo nos posibilita la interconecxión de los demás, para hacer la respectiva sintetización a través del programa iCEcube2 que genera el bitmap necesario para configurar la FPGA mediante el programa Diamond Programer.
## Bibliografía consultada y creditos.
-Apuntes de la materia proporcionados por la cátedra de Electónica II para ingeniería electronica de la Facultad de ciencias Exactas y Tecnología-Universidad Nacional de Tucumán.
-Quick Start Guide to VHDL;Brock J. LaMeres;Ed.Springer
-Rapid Prototyping of Digital System; James Hamblen,Michel Furman;Ed.Springer

-Y el acompañamiento constante del docente a cargo de la práctica.