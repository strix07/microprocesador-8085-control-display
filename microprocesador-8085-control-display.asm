; -------------------------------
;PROGRAMA DE INICIO: se encarga de ibicializar elprograma apagando el display,
;colocando configurando los  puerts, los registros que se utilizaran como contadores y 
;apuntando la direccion donde se comenzara a guardar los numeros de la C.I
;luego de esto entrara en un bucle hasta que se presione una tecla
; -------------------------------
		.org 0000h
		MVI A,0FH		;mitad entrada mitad salida
		OUT 02H		;configuro el puerto A
		MVI A,FFH		;todo salida
		OUT 03H		;configuro el puerto B	
	
		MVI A,FFH		;me aseguro que el display este apagado
		OUT 05H
		MVI A,08H		;contador 1 (indica cuantos datos he guardado)
		MOV C,A		
		MVI A,08H		;contador 2 (indica cuantos datos he mostrado en el display)
		MOV B,A
		LXI H,2000H		;apunto la direccion donde guardare los numeros de la C.I

BUCLE:
		MVI A,0FFh
   		OUT 00H		;descelecciono todas la colunas y filas

		MVI A,0EFh		;coloca en bajo el pin A4 (escaneo culmna 1)
   		OUT 00H		
		IN 00H		;leo el puerto A	
		CPI 0FEH		;si el pin A0=0 envia el numero 0 de lo contrario salta fila siguiente
		JZ  UNO1		
		CPI 0FDH 	      ;si el pin A1=0 envia el numero 2 de lo contrario salta fila siguiente
		JZ DOS1
		CPI 0FBH		;si el pin C2=0 envia el numero 4 de lo contrario salta fila siguiente
		JZ TRES1
		
		MVI A,06Fh		;coloco en B5 el pin A5 (escaneo columna 2)
   		OUT 00H
		IN 00H
		CPI 0FEH		
		JZ CUATRO1 		
		CPI 0FDH 	      
		JZ CINCO1
		CPI 0FBH		
		JZ SEIS1

		MVI A,0BFh		
   		OUT 00H
		IN 00H
		CPI 0FEH		
		JZ SIETE1 		
		CPI 0FDH 	      
		JZ OCHO1
		CPI 0FBH		
		JZ NUEVE1

		MVI A,07Fh		
   		OUT 00H
		IN 00H
		CPI 0FEH		
		JZ ASTERISCO		
		CPI 0FDH 	      
		JZ CERO1
		CPI 0FBH		
		JZ NUMERAL
		JMP BUCLE		;vuelvo a inicio

CERO1:	MVI E,'0'
		JMP GUARDAR
UNO1:		MVI E,'1'
		JMP GUARDAR
DOS1:		MVI E,'2'
		JMP GUARDAR
TRES1:	MVI E,'3'
		JMP GUARDAR
CUATRO1:	MVI E,'4'
		JMP GUARDAR
CINCO1:	MVI E,'5'
		JMP GUARDAR
SEIS1:	MVI E,'6'
		JMP GUARDAR
SIETE1:	MVI E,'7'
		JMP GUARDAR
OCHO1:	MVI E,'8'
		JMP GUARDAR
NUEVE1:	MVI E,'9'
		JMP GUARDAR
ASTERISCO:	MVI E,'*'
		JMP GUARDAR
NUMERAL:	MVI E,'#'
		JMP GUARDAR


; ------------------------------------------------------------------------------
;SUBRUTINA GUARDAR: se encarga  de gusardar en una lista los digitos
;de un numero de cedula y luego mostrarlos en un display
; -----------------------------------------------------------------------------									

GUARDAR:	
		DI			;desabilito interrupciones
		DCR C			;indico que guarde el primer digito
		MOV A,C

		CPI 00H		;si es el digito que guarde es el 8 
		JZ  CEDULA		;pasar a mostrar los digitos intrudcidos
	
		CPI 55H		;si ya intruduje lo 8 digitos
		JZ  CEDULA2		;ver si lo tacla que se presiono es *
	
		MOV A,E		;sino leer el digito
		MOV M,A		;guardo digito
		INX H			;aviso que ya lei el digito
		JMP BUCLE		;espero a que se intrudusca el siguiente


;-------------------------------------------------------------------------------------
;SUBRUTINAS CEDULA Y CEDILA1: se encargan de avisar al programa principal que ya se 
;intrudujeron los 8 digitos de la cedula y ahora debe mostrarlos en el display
;-------------------------------------------------------------------------------------


CEDULA:	MOV A,E		;leo el ultimo digito
		MOV M,A		;guardo el ultimo digito
		LXI H,2000H		;apunto al inicio de la lista
		MVI A,56H		;indico que ya se guardaron todos los digitos 	
		MOV C,A		
		JMP BUCLE		;espero a que  se presione *

CEDULA2:	MVI A,56H		;indico que ya se guararon todos los digitos	
		MOV C,A		
		MOV A,E		;veo que tecla se pulso
		CPI '*'
		JZ  MOSTRAR		;si se pulso el * mostrar el digito en el display
		JMP BUCLE		;sino esperrar a que se pulse *


;---------------------------------------------------------------------------
;subrutina MOSTRAR: se encarga de transformar el codigo ASCII de los digitos
;de la lista en su equivalente 7seg y mostrarlos en el display.
;---------------------------------------------------------------------------

MOSTRAR:	MOV A,M		;veo el digito que indique la pila
		CPI '0'		;veo cual de los 10 digitos posible
		JZ  CERO		;fue el pulsado
		CPI '1'
		JZ  UNO
		CPI '2'
		JZ  DOS
		CPI '3'
		JZ  TRES
		CPI '4'
		JZ  CUATRO
		CPI '5'
		JZ  CINCO
		CPI '6'
		JZ  SEIS
		CPI '7'
		JZ  SIETE
		CPI '8'
		JZ  OCHO
		CPI '9'
		JZ  NUEVE
		JMP BUCLE

CERO:		MVI A,C0H		;si fue 0
		OUT 05H		;mostrar el codigo 7seg en el display
		INX H			;apunto al siguiente digito
		CALL RETARDO	;espero un momento
		DCR B			;indico que ya mostre un digito
		CPI 00H		;veo si ya mostre todos los digitos
		JZ  FIN		;si es asi ir a finalizar
		JMP BUCLE		;sino esperar al siguiente pulso de *

UNO:		MVI A,FAH		;se repite lo mismo para los demas numeros
		OUT 05H
		INX H
		CALL RETARDO
		DCR B
		MOV A,B
		CPI 00H
		JZ  FIN
		JMP BUCLE

DOS:		MVI A,0A4H
		OUT 05H
		INX H
		CALL RETARDO
		DCR B
		MOV A,B
		CPI 00H
		JZ  FIN
		JMP BUCLE

TRES:		MVI A,0B0H
		OUT 05H
		INX H
		CALL RETARDO
		DCR B
		MOV A,B
		CPI 00H
		JZ  FIN
		JMP BUCLE

CUATRO:	MVI A,099H
		OUT 05H
		INX H
		CALL RETARDO
		DCR B
		MOV A,B
		CPI 00H
		JZ  FIN
		JMP BUCLE

CINCO:	MVI A,92H
		OUT 05H
		INX H
		CALL RETARDO
		DCR B
		MOV A,B
		CPI 00H
		JZ  FIN
		JMP BUCLE

SEIS:		MVI A,82H
		OUT 05H
		INX H
		CALL RETARDO		
		DCR B
		MOV A,B
		CPI 00H
		JZ  FIN
		JMP BUCLE

SIETE:	MVI A,46H
		OUT 05H
		INX H
		CALL RETARDO
		DCR B
		MOV A,B
		CPI 00H
		JZ  FIN
		JMP BUCLE

OCHO:		MVI A,00H
		OUT 05H
		INX H
		CALL RETARDO
		DCR B
		MOV A,B
		CPI 00H
		JZ  FIN
		JMP BUCLE

NUEVE:	MVI A,10H
		OUT 05H
		INX H
		CALL RETARDO
		DCR B
		MOV A,B
		CPI 00H
		JZ  FIN
		JMP BUCLE

;-----------------------------------------------------------------
;subrutina FIN: se encarga de apagar y encender el display 5 veces
;para indicar el fin del pograma.
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
		
		MVI A,08H
		OUT 05H
		CALL RETARDO
		MVI A,00H
		OUT 05H
		CALL RETARDO
		HLT

;-----------------------------------------------------------------
;subrutina RETARDO
;-----------------------------------------------------------------

RETARDO:
		MVI E,FFH		;cargo en el registro E FFh
NEXT:	 	MVI D,20H		;cargo en el registro D 20h
BACK:		DCR D			;decremento el registro D
		JNZ BACK		;sino es 0 el registro de seguir decrementando
		DCR E			;si es 0 decrementar el registro E
		JNZ NEXT		;sino es 0 el registro E volver a decrementar 
 					;el registro D hasta que sea 0
		RET			;si es 0 el registro E retornamos












