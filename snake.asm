.data

display: .word 0:262144
snake: .word -1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1
contador: 3

.text
la $t0, display
la $s0, display
la $t1, snake
la $s1, snake

#contador
addi $s4, $zero, 0

#colores
addi $t2, $zero, 0xffd90f	#color obstaculos
addi $s6, $zero, 0x0064ff	#color snake
addi $s7, $zero, 0xffffff	#color comida


#muestra snake en la pantalla (posici�n inicial)
sw $s6 , 200($t0)
sw $s6 , 204($t0)
sw $s6 , 208($t0)

sw $s7 , 128($t0)
sw $s7 , 380($t0)
sw $s7 , 84($t0)
sw $s7 , 1004($t0)


#carga posici�n inicial de snake en el arreglo de posici�n
addi $t3, $zero, 200
sw $t3, 0($t1)
addi $t3, $zero, 204
sw $t3, 4($t1)
addi $t3, $zero, 208
sw $t3, 8($t1)


teclado:
addi $a0, $zero, 100	# cada 100 ms
addi $v0, $zero, 32     # esperamos (syscall 32 sleep)
syscall	

addi $t6, $zero, 0xffff0004		# los caracteres del teclado se guardan en la dir de mem 0xffff0004
lw $s3, 0($t6)


beq $s3, 100, mover_derecha #d

beq $s3, 97, mover_izquierda #a

beq $s3, 119, mover_arriba #w

beq $s3, 115, mover_abajo #s

beq $s3, 113, salir #q

j teclado


mover_derecha:
addi $a0, $zero, 124
addi $a1, $zero, 64
addi $a2, $zero, 1084
jal evaluar_siguiente
beq $v0, 1, teclado

jal borrar_cola
addi $a0, $zero, 4	#lo que se suma en un movimiento normal
addi $a1, $zero, 124	#la "pared minima"
addi $a2, $zero, 64	#lo que se suma para hacer todas las comparaciones
addi $a3, $zero, -60 	#lo que se sumaria si fuera borde
addi $t4, $zero, 1084	#si se llega a ser este valor al estar moviendo hacia la derecha, es borde
jal desplazar_cuerpo
j teclado

mover_izquierda:
addi $a0, $zero, 64
addi $a1, $zero, 64
addi $a2, $zero, 1024
jal evaluar_siguiente
beq $v0, 1, teclado

jal borrar_cola
addi $a0, $zero, -4	#lo que se suma en un movimiento normal
addi $a1, $zero, 64	#la "pared minima"
addi $a2, $zero, 64	#lo que se suma para hacer todas las comparaciones
addi $a3, $zero, 60 	#lo que se sumaria si fuera borde
addi $t4, $zero, 1024	#si se llega a ser este valor al estar moviendo hacia la izquierda, es borde
jal desplazar_cuerpo
j teclado

mover_arriba:
addi $a0, $zero, 64
addi $a1, $zero, 4
addi $a2, $zero, 128
jal evaluar_siguiente
beq $v0, 1, teclado

jal borrar_cola
addi $a0, $zero, -64	#lo que se suma en un movimiento normal
addi $a1, $zero, 64	#la "pared minima"
addi $a2, $zero, 4	#lo que se suma para hacer todas las comparaciones
addi $a3, $zero, 896 	#lo que se sumaria si fuera borde
addi $t4, $zero, 128	#si se llega a ser este valor al estar moviendo hacia arriba, es borde
jal desplazar_cuerpo
j teclado

mover_abajo:
addi $a0, $zero, 960
addi $a1, $zero, 4
addi $a2, $zero, 1024
jal evaluar_siguiente
beq $v0, 1, teclado

jal borrar_cola
addi $a0, $zero, 64	#lo que se suma en un movimiento normal
addi $a1, $zero, 960	#la "pared minima"
addi $a2, $zero, 4	#lo que se suma para hacer todas las comparaciones
addi $a3, $zero, -896 	#lo que se sumaria si fuera borde
addi $t4, $zero, 1024	#si se llega a ser este valor al estar moviendo hacia abajo, es borde
jal desplazar_cuerpo
j teclado

borrar_cola:
lw $t2, 0($s1)
add $t2, $s0, $t2
sw $zero, 0($t2)
jr $ra

desplazar_cuerpo:
addi $t5, $zero, 0
copiando:
sll $t7, $t5, 2 	#multiplico iteraci�n por 4
add $t3, $s1, $t7	#base snake + espacios a correr
lw $t2, 4($t3)
beq $t2, -1, fin_desplazar_cuerpo
lw $t2, 4($t3)		#cargo nuevo cola (la cola de antes del desplazamiento fue eliminada)
sw $t2, 0($t3)
addi $t5, $t5, 1
j copiando
fin_desplazar_cuerpo:
#add $v0, $zero, $t3	#retorno la direcci�n de la �ltima posici�n
add $t2, $a0, $zero	#guardo en t2 el 4 que corresponde al desplazamiento normal (sin borde)
#lw $v0, ($t3)
lw $a0, 0($t3)		#guardo en a0 lo que hay en la ultima posici�n del snake
#jal insertar_cabeza_borde
#jr $ra

insertar_cabeza_borde:
while_cabeza:
beq $a0, $a1, hay_borde
add $a1, $a1, $a2	#recorro el tablero
beq $a1, $t4, no_hay_borde
j while_cabeza

hay_borde:
add $a0, $a0, $a3
sw $a0, 0($t3)
add $a0, $s0, $a0
sw $s6, 0($a0)
j fin_cabeza

no_hay_borde:
add $a0,$a0,$t2
sw $a0, 0($t3)
add $a0, $s0, $a0
sw $s6, 0($a0)
j fin_cabeza

fin_cabeza:
jr $ra

#############################################################################################
####################################FUNCION##################################################
#############################################################################################
evaluar_siguiente:
add $v0, $zero, $zero	# v0 = 0: no comi�  ---- v0 = 1: comi�
addi $t4, $s4, 2	#accedo a la cabeza de snake (en el arreglo snake)
sll $t4, $t4, 2		#contador por 4
add $t4, $s1, $t4	#se ubica en la posici�n
lw $t5, 0($t4)		#cargamos lo contenido en $t4, para despues evaluarlo en el tablero
#sll $t5, $t5, 2	#mutiplica por 4
#add $t5, $s0, $t5	#se suma a la base del tablero



beq $s3, 100, evaluar_a_la_derecha #d
beq $s3, 97, evaluar_a_la_izquierda #a
beq $s3, 119, evaluar_arriba #w
beq $s3, 115, evaluar_abajo #s

evaluar_a_la_derecha:
while_derecha:
beq $a0, $t5, con_borde_a_la_derecha
add $a0, $a0, $a1	#recorro el tablero
beq $a2, $a0, sin_borde_a_la_derecha
j while_derecha
#beq $t5, 124, con_borde_a_la_derecha

sin_borde_a_la_derecha:
add $t5, $s0, $t5	#se suma a la base del tablero
addi $s5, $t5, 4	#accedo al elemento a la derecha de la cabeza de snake
j seguir_evaluando_derecha

con_borde_a_la_derecha:
add $t5, $s0, $t5	#se suma a la base del tablero
addi $s5, $t5, -60	#accedo al elemento a la derecha de la cabeza de snake

seguir_evaluando_derecha:
lw $t5, 0($s5)		#cargo lo que haya en ese espacio
beq $t5, 16767247, salir#si es obstaculo, salir
beq $t5, $s6, salir	#si es cuerpo, salir
beq $t5, $s7, comer	#si es comida, comer
#no hay obstaculo	
j fin_evaluar_siguiente	#si no haby obstaculo, terminar para desplazar


evaluar_a_la_izquierda:
while_izquierda:
beq $a0, $t5, con_borde_a_la_izquierda
add $a0, $a0, $a1	#recorro el tablero
beq $a2, $a0, sin_borde_a_la_izquierda
j while_izquierda

#beq $t5, 64, con_borde_a_la_izquierda

sin_borde_a_la_izquierda:
add $t5, $s0, $t5	#se suma a la base del tablero
addi $s5, $t5, -4	#accedo al elemento a la derecha de la cabeza de snake
j seguir_evaluando_izquierda

con_borde_a_la_izquierda:
add $t5, $s0, $t5	#se suma a la base del tablero
addi $s5, $t5, 60	#accedo al elemento a la derecha de la cabeza de snake

seguir_evaluando_izquierda:
	
lw $t5, 0($s5)
beq $t5, 16767247, salir
beq $t5, $s6, salir
beq $t5, $s7, comer
#no hay obstaculo
j fin_evaluar_siguiente

evaluar_arriba:
while_arriba:
beq $a0, $t5, con_borde_arriba
add $a0, $a0, $a1	#recorro el tablero
beq $a2, $a0, sin_borde_arriba
j while_arriba

#beq $t5, 64, con_borde_arriba

sin_borde_arriba:
add $t5, $s0, $t5	#se suma a la base del tablero
addi $s5, $t5, -64	#accedo al elemento a la derecha de la cabeza de snake
j seguir_evaluando_arriba

con_borde_arriba:
add $t5, $s0, $t5	#se suma a la base del tablero
addi $s5, $t5, 896	#accedo al elemento a la derecha de la cabeza de snake

seguir_evaluando_arriba:
	
	
lw $t5, 0($s5)
beq $t5, 16767247, salir
beq $t5, $s6, salir
beq $t5, $s7, comer
#no hay obstaculo
j fin_evaluar_siguiente

evaluar_abajo:
while_abajo:
beq $a0, $t5, con_borde_abajo
add $a0, $a0, $a1	#recorro el tablero
beq $a2, $a0, sin_borde_abajo
j while_abajo
#beq $t5, 64, con_borde_abajo

sin_borde_abajo:
add $t5, $s0, $t5	#se suma a la base del tablero
addi $s5, $t5, 64	#accedo al elemento a la derecha de la cabeza de snake
j seguir_evaluando_abajo

con_borde_abajo:
add $t5, $s0, $t5	#se suma a la base del tablero
addi $s5, $t5, -896	#accedo al elemento a la derecha de la cabeza de snake

seguir_evaluando_abajo:
	
lw $t5, 0($s5)
beq $t5, 16767247, salir
beq $t5, $s6, salir
beq $t5, $s7, comer
#no hay obstaculo
j fin_evaluar_siguiente

comer:
sw $s6, 0($s5)
addi $v0, $zero, 1
addi $s4, $s4, 1
sub $s5, $s5, $s0	#conseguimos la diferencia para guardarla en el arreglo snake
#srl $s5, $s5, 2
sw $s5, 4($t4)



fin_evaluar_siguiente:
jr $ra



#a0: lo que hay en la ultima posici�n de snake
#a1: la pared minima
#2: lo que se suma para hacer las compraciones
#a3: lo que se sumaria si fuera borde
#t4: si se llega a ser este valor al estar moviendo hacia arriba, es borde
#es_borde:
#while:
#beq $a0, $a1, si_es_borde
#add $a1, $a1, $a2	#recorro el tablero
#beq $a1, $t4, no_es_borde
#j while
#jr $ra

salir:
