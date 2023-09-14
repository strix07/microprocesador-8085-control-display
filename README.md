# Desarrollo de un Programa para Leer Números de una Cédula de Identidad Utilizando el micorprocesador Intel 8085

En esta página, mostraremos el resultado de la implementación de un código diseñado para el simulador Granada, y en base a este diseñaremos un código para su implementación en caso real, ya que, como veremos más adelante, el simulador Granada no contempla la utilización de periféricos. El objetivo principal de este proyecto es desarrollar un programa capaz de leer los números de una cédula a través de un teclado numérico y almacenarlos en una región de memoria llamada "lista". Luego, al presionar la tecla "*" en el teclado, podremos mostrar cada uno de los números presionados previamente en un display.

## Video del programa simulado en granada:

https://drive.google.com/file/d/1g_87pHcdl1Lza3LHfqnQmHLzU5hzYqMc/view?usp=drive_web

<br>

## Circuito deseñado para la implementación del progragrama realizado con el software de granada en un caso real

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

El programa adjuntado fue diseñado para un caso específico, utilizando el simulador Granada, el cual no toma en cuenta los dispositivos externos al 8085. En esta sección se tomarán en cuenta los dispositivos que se mostraron en el diagrama diseñado y los cambios que se deben realizar al programa.

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

```
; PROGRAMA DE INICIO: se encarga de inicializar el programa apagando el display,
; primero configurando los puertos, luego los registros que se utilizarán como contadores
; y apuntando la dirección donde se comenzará a guardar los números de la C.I,
; luego de esto entrará en un bucle hasta que se presione una tecla, que
; finalizará guardando en el registro E el código ASCII de la tecla presionada
; ------------------------------------------------------------------------------
.org 0000h      ; Configuración de puertos
		MVI A,0FH		; Mitad entrada, mitad salida
		OUT 02H			; Configuro el puerto A
		MVI A,FFH		; Todo salida
		OUT 03H			; Configuro el puerto 		              
		MVI A,FFH    ; Apagar el display
		OUT 05H
		MVI A,08H		; Contador 1 (indica cuántos datos he guardado)
		MOV C,A		
		MVI A,08H		; Contador 2 (indica cuántos datos he mostrado en el display)
		MOV B,A
		LXI H,2000H  ; Apuntar la dirección donde guardaré los números de la C.I

BUCLE: 
		MVI A,0FFh    ; Desseleccionar todas las columnas y filas
    OUT 00H
		
		MVI A,0EFh  ; Escanear columna 1
    OUT 00H
		IN 00H			; Leer el puerto A
		CPI 0FEH		; Si el pin A0=0, envía el número 0, de lo contrario, salta a la fila siguiente
		JZ UNO1		
		CPI 0FDH		; Si el pin A1=0, envía el número 2, de lo contrario, salta a la fila siguiente
		JZ DOS1
		CPI 0FBH		; Si el pin C2=0, envía el número 4, de lo contrario, salta a la fila siguiente
		JZ TRES1
				
		MVI A,06Fh  ; Escanear columna 2
    OUT 00H
		IN 00H
		CPI 0FEH
		JZ CUATRO1
		CPI 0FDH
		JZ CINCO1
		CPI 0FBH
		JZ SEIS1
		
		MVI A,0BFh  ; Escanear columna 3
    OUT 00H
		IN 00H
		CPI 0FEH
		JZ SIETE1
		CPI 0FDH
		JZ OCHO1
		CPI 0FBH
		JZ NUEVE1

		OUT 00H
		IN 00H
		CPI 0FEH
		JZ ASTERISCO
		CPI 0FDH
		JZ CERO1
		CPI 0FBH
		JZ NUMERAL
		JMP BUCLE		; vuelvo a inicio

CERO1:
    MVI E,'0'
		JMP GUARDAR
UNO1:
    MVI E,'1'
		JMP GUARDAR
DOS1:
	  MVI E,'2'
		JMP GUARDAR
TRES1:
  	MVI E,'3'
		JMP GUARDAR
CUATRO1:
  	MVI E,'4'
		JMP GUARDAR
CINCO1:
    MVI E,'5'
		JMP GUARDAR
SEIS1:
    MVI E,'6'
		JMP GUARDAR
SIETE1:
  	MVI E,'7'
		JMP GUARDAR
OCHO1:
    MVI E,'8'
		JMP GUARDAR
NUEVE1:
    MVI E,'9'
		JMP GUARDAR
ASTERISCO:
  	MVI E,'*'
		JMP GUARDAR
NUMERAL:
    MVI E,'#'
		JMP GUARDAR

; ------------------------------------------------------------------------------
; SUBRUTINA GUARDAR: se encarga de guardar en una lista los dígitos
; de un número de cedula y luego mostrarlos en un display
; -----------------------------------------------------------------------------

GUARDAR:
		DI			      ; deshabilito interrupciones
		DCR C		    	; indico que guarde el primer dígito
		MOV A,C

		CPI 00H			  ; si es el dígito que guarde es el 8 
		JZ  CEDULA		; pasar a mostrar los dígitos introducidos

		CPI 55H			  ; si ya intruduje los 8 dígitos
		JZ  CEDULA2		; ver si la tecla que se presionó es *

		MOV A,E			; sino leer el dígito
		MOV M,A			; guardo el dígito
		INX H			  ; aviso que ya leí el dígito
		JMP BUCLE		; espero a que se introduzca el siguiente

; SUBRUTINAS CEDULA Y CEDULA1: se encargan de avisar al programa principal que ya se introdujeron los 8 dígitos de la cédula y ahora debe mostrarlos en el display
; ---------------------------------------------------------------------------------

CEDULA:	MOV A,E		; leo el último dígito
		MOV M,A			  ; guardo el último dígito
		LXI H,2000H		; apunto al inicio de la lista
		MVI A,56H	  	; indico que ya se guardaron todos los dígitos
		MOV C,A
		JMP BUCLE		  ; espero a que se presione *

CEDULA2:	MVI A,56H		; indico que ya se guardaron todos los dígitos
		MOV C,A
		MOV A,E		      	; veo qué tecla se pulsó
		CPI '*'
		JZ MOSTRAR	    	; si se pulsó el *, mostrar el dígito en el display
		JMP BUCLE		      ; sino esperar a que se pulse *

; ---------------------------------------------------------------------------
; SUBRUTINA MOSTRAR: se encarga de transformar el código ASCII de los dígitos
; de la lista en su equivalente 7seg y mostrarlos en el display.
; ---------------------------------------------------------------------------

MOSTRAR:
    MOV A,M			; veo el dígito que indica la pila
		CPI '0'			; veo cuál de los 10 dígitos posibles
		JZ CERO			; fue el pulsado
		CPI '1'
		JZ UNO
		CPI '2'
		JZ DOS
		CPI '3'
		JZ TRES
		CPI '4'
		JZ CUATRO
		CPI '5'
		JZ CINCO
		CPI '6'
		JZ SEIS
		CPI '7'
		JZ SIETE
		CPI '8'
		JZ OCHO
		CPI '9'
		JZ NUEVE
		JMP BUCLE

CERO:
  	MVI A,C0H	        	; si fue 0
		OUT 07H		        	; mostrar el código 7seg en el display
		INX H			          ; apunto al siguiente dígito
		CALL RETARDO      	; espero un momento
		DCR B			          ; indico que ya mostré un dígito
		CPI 00H		        	; veo si ya mostré todos los dígitos
		JZ FIN		         	; si es así, ir a finalizar
		JMP BUCLE

UNO:
  	MVI A,FAH		;se repite lo mismo para los demas numeros
		OUT 07H
		INX H
		CALL RETARDO
		DCR B
		MOV A,B
		CPI 00H
		JZ  FIN
		JMP BUCLE

DOS:
  	MVI A,0A4H
		OUT 07H
		INX H
		CALL RETARDO
		DCR B
		MOV A,B
		CPI 00H
		JZ  FIN
		JMP BUCLE

TRES:
  	MVI A,0B0H
		OUT 07H
		INX H
		CALL RETARDO
		DCR B
		MOV A,B
		CPI 00H
		JZ  FIN
		JMP BUCLE

CUATRO:
  	MVI A,099H
		OUT 07H
		INX H
		CALL RETARDO
		DCR B
		MOV A,B
		CPI 00H
		JZ  FIN
		JMP BUCLE

CINCO:
  	MVI A,92H
		OUT 07H
		INX H
		CALL RETARDO
		DCR B
		MOV A,B
		CPI 00H
		JZ  FIN
		JMP BUCLE

SEIS:
    MVI A,82H
		OUT 07H
		INX H
		CALL RETARDO		
		DCR B
		MOV A,B
		CPI 00H
		JZ  FIN
		JMP BUCLE
		OUT 07H
		INX H
		CALL RETARDO
		DCR B
		MOV A,B
		CPI 00H
		JZ  FIN
		JMP BUCLE

OCHO:
  	MVI A,00H
		OUT 07H
		INX H
		CALL RETARDO
		DCR B
		MOV A,B
		CPI 00H
		JZ  FIN
		JMP BUCLE

NUEVE:
  	MVI A,10H
		OUT 07H
		INX H
		CALL RETARDO
		DCR B
		MOV A,B
		CPI 00H
		JZ  FIN
		JMP BUCLE
	

;-----------------------------------------------------------------
;subrutina FIN: se encarga de apagar y encender el display 5 veces
;para indicar el fin del programa.
;-----------------------------------------------------------------

FIN:
		MVI A,08H
		OUT 05H
		CALL RETARDO
		MVI A,00H
		OUT 05H
		CALL RETARDO

		MVI A,08H
		OUT 05H
		CALL RETARDO
		MVI A,00H
		OUT 05H
		CALL RETARDO

		MVI A,08H
		OUT 05H
		CALL RETARDO
		MVI A,00H
		OUT 05H
		CALL RETARDO

    MVI A,08H
    OUT 05H
    CALL RETARDO
    MVI A,00H
    OUT 05H
    CALL RETARDO
    HLT

; -----------------------------------------------------------------
; Subrutina RETARDO
; -----------------------------------------------------------------

RETARDO:
MVI E,FFH		      ; cargo en el registro E FFh
NEXT:	MVI D,20H		; cargo en el registro D 20h
BACK:	DCR D			  ; decremento el registro D
JNZ BACK		      ; sino es 0 el registro, seguir decrementando
DCR E			        ; si es 0, decrementar el registro E
JNZ NEXT	    	  ; sino es 0 el registro E, volver a decrementar el registro D hasta que sea 0
RET			          ; si es 0 el registro E, retornamos

```

## CONCLUSIÓN
En este proyecto, hemos logrado diseñar y desarrollar un programa altamente funcional que demuestra la capacidad de leer números de una cédula introducidos en un microprocesador 8085 a través de un teclado numérico. Este programa ha demostrado ser eficiente al almacenar los números en una región de memoria y permitir la visualización de los dígitos presionados en un display al presionar la tecla o "*".

REFERENCIAS CONSULTADAS
Armengol, A. (2020). Tarea conexión del 8355. Caracas, Venezuela: Universidad Simón Bolívar.
Vázquez, Celestino (1999) "Microprocesador 8085, Curso del microprocesador 8085 fabricado por Intel."







  
