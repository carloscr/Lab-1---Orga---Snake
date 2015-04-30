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


#muestra snake en la pantalla (posición inicial)
sw $s6 , 1032($t0)
sw $s6 , 1036($t0)
sw $s6 , 1040($t0)

#muestra el primer alimento
li $a1, 862
li $v0, 42
syscall
addi $a0, $a0, 161
sll $a0, $a0, 2
add $a0, $s0, $a0
sw $s7 , 0($a0)



#carga posición inicial de snake en el arreglo de posición
addi $t3, $zero, 1032
sw $t3, 0($t1)
addi $t3, $zero, 1036
sw $t3, 4($t1)
addi $t3, $zero, 1040
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
addi $a0, $zero, 764
addi $a1, $zero, 128
addi $a2, $zero, 4220
jal evaluar_siguiente
beq $v1, 1, teclado

jal borrar_cola
addi $a0, $zero, 4	#lo que se suma en un movimiento normal
addi $a1, $zero, 764	#la "pared minima"
addi $a2, $zero, 128	#lo que se suma para hacer todas las comparaciones
addi $a3, $zero, -124 	#lo que se sumaria si fuera borde
addi $t4, $zero, 4220	#si se llega a ser este valor al estar moviendo hacia la derecha, es borde
jal desplazar_cuerpo
j teclado

mover_izquierda:
addi $a0, $zero, 640
addi $a1, $zero, 128
addi $a2, $zero, 4096
jal evaluar_siguiente
beq $v1, 1, teclado

jal borrar_cola
addi $a0, $zero, -4	#lo que se suma en un movimiento normal
addi $a1, $zero, 640	#la "pared minima"
addi $a2, $zero, 128	#lo que se suma para hacer todas las comparaciones
addi $a3, $zero, 124 	#lo que se sumaria si fuera borde
addi $t4, $zero, 4096	#si se llega a ser este valor al estar moviendo hacia la izquierda, es borde
jal desplazar_cuerpo
j teclado

mover_arriba:
addi $a0, $zero, 640
addi $a1, $zero, 4
addi $a2, $zero, 768
jal evaluar_siguiente
beq $v1, 1, teclado

jal borrar_cola
addi $a0, $zero, -128	#lo que se suma en un movimiento normal
addi $a1, $zero, 640	#la "pared minima"
addi $a2, $zero, 4	#lo que se suma para hacer todas las comparaciones
addi $a3, $zero, 3328 	#lo que se sumaria si fuera borde
addi $t4, $zero, 768	#si se llega a ser este valor al estar moviendo hacia arriba, es borde
jal desplazar_cuerpo
j teclado

mover_abajo:
addi $a0, $zero, 3968
addi $a1, $zero, 4
addi $a2, $zero, 4096
jal evaluar_siguiente
beq $v1, 1, teclado

jal borrar_cola
addi $a0, $zero, 128	#lo que se suma en un movimiento normal
addi $a1, $zero, 3968	#la "pared minima"
addi $a2, $zero, 4	#lo que se suma para hacer todas las comparaciones
addi $a3, $zero, -3328 	#lo que se sumaria si fuera borde
addi $t4, $zero, 4096	#si se llega a ser este valor al estar moviendo hacia abajo, es borde
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
sll $t7, $t5, 2 	#multiplico iteración por 4
add $t3, $s1, $t7	#base snake + espacios a correr
lw $t2, 4($t3)
beq $t2, -1, fin_desplazar_cuerpo
lw $t2, 4($t3)		#cargo nuevo cola (la cola de antes del desplazamiento fue eliminada)
sw $t2, 0($t3)
addi $t5, $t5, 1
j copiando
fin_desplazar_cuerpo:
#add $v0, $zero, $t3	#retorno la dirección de la última posición
add $t2, $a0, $zero	#guardo en t2 el 4 que corresponde al desplazamiento normal (sin borde)
#lw $v0, ($t3)
lw $a0, 0($t3)		#guardo en a0 lo que hay en la ultima posición del snake
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
add $v1, $zero, $zero	# v0 = 0: no comió  ---- v0 = 1: comió
addi $t4, $s4, 2	#accedo a la cabeza de snake (en el arreglo snake)
sll $t4, $t4, 2		#contador por 4
add $t4, $s1, $t4	#se ubica en la posición
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
addi $s5, $t5, -124	#accedo al elemento a la derecha de la cabeza de snake

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
addi $s5, $t5, 124	#accedo al elemento a la derecha de la cabeza de snake

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
addi $s5, $t5, -128	#accedo al elemento a la derecha de la cabeza de snake
j seguir_evaluando_arriba

con_borde_arriba:
add $t5, $s0, $t5	#se suma a la base del tablero
addi $s5, $t5, 3328	#accedo al elemento a la derecha de la cabeza de snake

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
addi $s5, $t5, 128	#accedo al elemento a la derecha de la cabeza de snake
j seguir_evaluando_abajo

con_borde_abajo:
add $t5, $s0, $t5	#se suma a la base del tablero
addi $s5, $t5, -3328	#accedo al elemento a la derecha de la cabeza de snake

seguir_evaluando_abajo:
	
lw $t5, 0($s5)
beq $t5, 16767247, salir
beq $t5, $s6, salir
beq $t5, $s7, comer
#no hay obstaculo
j fin_evaluar_siguiente

comer:
sw $s6, 0($s5)
addi $v1, $zero, 1
addi $s4, $s4, 1
sub $s5, $s5, $s0	#conseguimos la diferencia para guardarla en el arreglo snake
#srl $s5, $s5, 2
sw $s5, 4($t4)

insertar_comida:
li $a1, 862
li $v0, 42
syscall
addi $a0, $a0, 161
sll $a0, $a0, 2
add $a0, $s0, $a0

lw $a2, 0($a0)
beq $a2, 16767247, insertar_comida
beq $a2,$s6, insertar_comida
sw $s7 , 0($a0)

fin_evaluar_siguiente:
jr $ra



salir: