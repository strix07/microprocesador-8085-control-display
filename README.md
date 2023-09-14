# Desarrollo de un Programa en el Simulador Granada para Leer Números de una Cédula de Identidad

En esta página, exploraremos la creación de un emocionante proyecto que involucra la programación en el simulador Granada. El objetivo principal de este proyecto es desarrollar un programa capaz de leer los números de una cédula a través de un teclado numérico y almacenarlos en una región de memoria llamada "lista". Luego, al presionar la tecla "*" en el teclado, podremos mostrar cada uno de los números presionados previamente en un display.

<br>

<div align="center">
  <img src="https://github.com/strix07/microprocesador-8085-control-display/assets/142692042/f81a7b0e-66ce-4643-a9dc-0a6c905563d1" alt="Texto Alternativo de la Imagen">
</div>

<br>

## Características Destacadas del Microprocesador 8085

El microprocesador 8085 es conocido por sus características distintivas, y una de las más notables es la multiplexación de su bus de datos de 8 líneas con la parte baja del bus de direcciones de 16 bits. Esta característica significa que en un momento determinado, las 8 líneas del bus contendrán información de una dirección, y un instante después, contendrán información de datos. Esto presenta un desafío importante en la circuitería externa para garantizar una separación adecuada de estas señales y evitar interferencias en el sistema.

### Multiplexación de Datos y Direcciones

El proceso de multiplexación implica que las mismas líneas del bus se utilizan para transmitir tanto datos como direcciones. Para lograr una separación total, se requiere un diseño cuidadoso en la circuitería externa. El microprocesador 8085 cuenta con una línea de control llamada ALE (Address Latch Enable) que juega un papel fundamental en este proceso.

### Utilizando la Señal ALE

La señal ALE se utiliza para indicar cuándo se presenta la parte baja de una dirección en el bus de direcciones (AD0,...,AD7) y cuándo aparece un dato. Cuando se presenta una dirección, la señal ALE se encuentra en estado lógico 1, y cuando aparece un dato, ALE pasa al estado lógico 0. Esta señal de control es esencial para separar las informaciones utilizando un circuito integrado conocido como cerrojo (latch), que realiza la separación física entre datos y direcciones.

### Configuración de Puertos

Para configurar los puertos de entrada/salida, es importante tener en cuenta la conexión de CE (Chip Enable) a la línea 11 del bus de direcciones. Dado que el direccionamiento de entrada/salida es de 8 bits y se duplica en el bus de direcciones de 16 bits, A11 (Address Line 11) y A3 deben ser iguales a 0 para establecer la configuración correcta de los puertos.

### Comunicación con Dispositivos Externos

Finalmente, el microprocesador 8085 se comunica con dispositivos externos a través de señales como IO/M (Input/Output Memory), RD (Read), y WR (Write). Estas señales permiten al microprocesador indicar al circuito periférico, como el 8355 en este caso, qué tipo de instrucción se está ejecutando.

<br>

<div align="center">
  <img src="https://github.com/strix07/microprocesador-8085-control-display/assets/142692042/52fa2ccc-3419-4153-9567-3384c19f507f" alt="Texto Alternativo de la Imagen">
</div>

<br>

Por último, podemos ver en la figura de abajo que en el puerto B del 8355 se conectó el display ánodo común (cuadro rojo) y en el puerto A el teclado (cuadro verde).

<br>

<div align="center">
  <img src="https://github.com/strix07/microprocesador-8085-control-display/assets/142692042/96686a98-f26b-48de-9fe4-87fcb013828b" alt="Texto Alternativo de la Imagen">
</div>

<br>

## CONSIDERACIONES ACERCA DE LOS DISPOSITIVOS EXTERNOS AL 8085 Y CAMBIOS AL PROGRAMA

El programa hecho anteriormente fue para un caso específico utilizando el simulador Granada, el cual no toma en cuenta los dispositivos externos al 8085. En esta sección se tomarán en cuenta los dispositivos que se mostraron en el diagrama diseñado y los cambios que se deben realizar al programa.

Primero, como vimos, para sustituir el teclado del simulador se usará uno tipo matriz numérico de 12 teclas (habría que hacer una pequeña rutina en el 8085 para transformar la salida de ese teclado a su correspondiente código ASCII para hacerlo compatible con el resto del programa ya hecho en la sección anterior).

Además, se deberán hacer un cambio en la configuración de los puertos ya que estamos utilizando el 8355, recordando que la configuración de puertos se hace con los bits A1 y A2:

<br>

<div align="center">
  <img src="https://github.com/strix07/microprocesador-8085-control-display/assets/142692042/d41ddb24-7866-4a9f-9520-3a4c23afd5b8" alt="Texto Alternativo de la Imagen">
</div>

<br>

Donde cada línea de cada puerto se puede programar independientemente con un 0 para entrada o un 1 para salida. Las salidas tienen su latch interior, o sea, la salida permanece hasta que se cambie.

Por último, se realizarán cambios en el código 7 segmentos ya que el simulador utiliza un código diferente al de un display 7 segmentos real ánodo común.

Todos estos cambios se muestran en el programa rediseñado tomando en cuenta factores externos al 8085 en las páginas siguientes:

## CONCLUSIÓN
En este proyecto, hemos logrado diseñar y desarrollar un programa altamente funcional que demuestra la capacidad de leer números de una cédula introducidos en un microprocesador 8085 a través de un teclado numérico. Este programa ha demostrado ser eficiente al almacenar los números en una región de memoria y permitir la visualización de los dígitos presionados en un display al presionar la tecla o "*".

REFERENCIAS CONSULTADAS
Armengol, A. (2020). Tarea conexión del 8355. Caracas, Venezuela: Universidad Simón Bolívar.
Vázquez, Celestino (1999) "Microprocesador 8085, Curso del microprocesador 8085 fabricado por Intel."







  
