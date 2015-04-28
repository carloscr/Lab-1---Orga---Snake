.data

display: .word 0:262144
snake: .word -1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1
contador: 3

.text
la $t0, display
la $s0, display
la $t1, snake
la $s1, snake

#colores
addi $t2, $zero, 0xffffff	#color obstaculos
addi $s6, $zero, 0xff00ff	#color snake
addi $s7, $zero, 0xff0000	#color comida


#muestra snake en la pantalla (posición inicial)
sw $s6 , 200($t0)
sw $s6 , 204($t0)
sw $s6 , 208($t0)
#sw $s6 , 212($t0)
#sw $s6 , 216($t0)
#sw $s6 , 220($t0)

#carga posición inicial de snake en el arreglo de posición
addi $t5, $zero, 200
sw $t5, 0($t1)
addi $t5, $zero, 204
sw $t5, 4($t1)
addi $t5, $zero, 208
sw $t5, 8($t1)



#polling
teclado:
addi $a0, $zero, 100	# cada 100 ms
addi $v0, $zero, 32     # esperamos (syscall 32 sleep)
syscall			# esperamos 100ms para no utilizar todo el procesador

#sw $zero, 0($t6)		        # Seteamos a NULL (cero) el buffer para no leer datos duplicados
addi $t6, $zero, 0xffff0004		# los caracteres del teclado se guardan en la dir de mem 0xffff0004
lw $s3, 0($t6)
#sw $zero, 0($t6) ##BORRAR

#s3 contiene la tecla

beq $s3, 100, mover_derecha #d

beq $s3, 97, mover_izquierda #a

beq $s3, 119, mover_arriba #w

beq $s3, 115, mover_abajo #s

beq $s3, 113, salir #q

j teclado



#####################################
mover_derecha:
#borrar cola
lw $t2, 0($s1)
add $t2, $s0, $t2

#lw $t2, 0($t2)
#beq $t2, $zero, fin_desplazar_cuerpo
#lw $t2, 0($s1)
#add $t2, $s0, $t2

sw $zero, 0($t2)
addi $s4, $zero, 0

j desplazar_cuerpo_derecha

############# DESPLAZAR ################
desplazar_cuerpo_derecha:
sll $t7, $s4, 2 	#multiplico iteración por 4
add $t3, $s1, $t7	#base snake + espacios a correr

lw $t2, 4($t3)
beq $t2, -1, fin_dderecha

lw $t2, 4($t3)		#cargo nuevo cola (la cola de antes del desplazamiento eliminada)
sw $t2, 0($t3)





addi $s4, $s4, 1

j desplazar_cuerpo_derecha

fin_dderecha:
lw $t2, 0($t3)

beq $t2, 60, borde_derecha
beq $t2, 124, borde_derecha
beq $t2, 188, borde_derecha
beq $t2, 252, borde_derecha
beq $t2, 316, borde_derecha
beq $t2, 380, borde_derecha
beq $t2, 444, borde_derecha
beq $t2, 508, borde_derecha
beq $t2, 572, borde_derecha
beq $t2, 636, borde_derecha
beq $t2, 700, borde_derecha
beq $t2, 764, borde_derecha
beq $t2, 828, borde_derecha
beq $t2, 892, borde_derecha
beq $t2, 956, borde_derecha
beq $t2, 1020, borde_derecha

addi $t2,$t2,4
sw $t2, 0($t3)

add $t2, $s0, $t2
j sin_borde
#lw $t2, 0($t2)
#beq $t2, $zero, fin_desplazar_cuerpo
#lw $t2, 0($s1)
#add $t2, $s0, $t2
borde_derecha:
addi $t2, $t2,-60
sw $t2, 0($t3)
add $t2, $s0, $t2

sin_borde:

sw $s6, 0($t2)

j teclado



#####################################
mover_izquierda:
lw $t2, 0($s1)
add $t2, $s0, $t2
sw $zero, 0($t2)
addi $s4, $zero, 0


j desplazar_cuerpo_izquierda

############# DESPLAZAR ################
desplazar_cuerpo_izquierda:
sll $t7, $s4, 2 	#multiplico iteración por 4
add $t3, $s1, $t7	#base snake + espacios a correr

lw $t2, 4($t3)
beq $t2, -1, fin_dizquierda

lw $t2, 4($t3)		#cargo nuevo cola (la cola de antes del desplazamiento eliminada)
sw $t2, 0($t3)





addi $s4, $s4, 1

j desplazar_cuerpo_izquierda

fin_dizquierda:
lw $t2, 0($t3)

beq $t2, 0, borde_izquierda
beq $t2, 64, borde_izquierda
beq $t2, 128, borde_izquierda
beq $t2, 192, borde_izquierda
beq $t2, 256, borde_izquierda
beq $t2, 320, borde_izquierda
beq $t2, 384, borde_izquierda
beq $t2, 448, borde_izquierda
beq $t2, 512, borde_izquierda
beq $t2, 576, borde_izquierda
beq $t2, 640, borde_izquierda
beq $t2, 704, borde_izquierda
beq $t2, 768, borde_izquierda
beq $t2, 832, borde_izquierda
beq $t2, 896, borde_izquierda
beq $t2, 960, borde_izquierda


addi $t2,$t2,-4
sw $t2, 0($t3)
#add $t2, $s0, $zero
############################################
#generar cabeza
#add $t3, $t3, 

add $t2, $s0, $t2

j sin_borde_izquierda

borde_izquierda:
addi $t2, $t2, 60
sw $t2, 0($t3)
add $t2,$s0,$t2

sin_borde_izquierda:

#lw $t2, 0($t2)
#beq $t2, $zero, fin_desplazar_cuerpo
#lw $t2, 0($s1)
#add $t2, $s0, $t2

sw $s6, 0($t2)

j teclado

#####################################
mover_arriba:
lw $t2, 0($s1)
add $t2, $s0, $t2
sw $zero, 0($t2)
addi $s4, $zero, 0


j desplazar_cuerpo_arriba

############# DESPLAZAR ################
desplazar_cuerpo_arriba:
sll $t7, $s4, 2 	#multiplico iteración por 4
add $t3, $s1, $t7	#base snake + espacios a correr

lw $t2, 4($t3)
beq $t2, -1, fin_darriba

lw $t2, 4($t3)		#cargo nuevo cola (la cola de antes del desplazamiento eliminada)
sw $t2, 0($t3)





addi $s4, $s4, 1

j desplazar_cuerpo_arriba

fin_darriba:
lw $t2, 0($t3)

beq $t2, 64, borde_arriba
beq $t2, 68, borde_arriba
beq $t2, 72, borde_arriba
beq $t2, 76, borde_arriba
beq $t2, 80, borde_arriba
beq $t2, 84, borde_arriba
beq $t2, 88, borde_arriba
beq $t2, 92, borde_arriba
beq $t2, 96, borde_arriba
beq $t2, 100, borde_arriba
beq $t2, 104, borde_arriba
beq $t2, 108, borde_arriba
beq $t2, 112, borde_arriba
beq $t2, 116, borde_arriba
beq $t2, 120, borde_arriba
beq $t2, 124, borde_arriba



addi $t2,$t2,-64
sw $t2, 0($t3)

#add $t2, $s0, $zero
############################################
#generar cabeza
#add $t3, $t3, 

add $t2, $s0, $t2
j sin_borde_arriba

#lw $t2, 0($t2)
#beq $t2, $zero, fin_desplazar_cuerpo
#lw $t2, 0($s1)
#add $t2, $s0, $t2
borde_arriba:
addi $t2, $t2,896
sw $t2,0($t3)
add $t2,$s0,$t2

sin_borde_arriba:

sw $s6, 0($t2)

j teclado

#####################################
mover_abajo:
lw $t2, 0($s1)
add $t2, $s0, $t2
sw $zero, 0($t2)
addi $s4, $zero, 0


j desplazar_cuerpo_abajo

############# DESPLAZAR ################
desplazar_cuerpo_abajo:
sll $t7, $s4, 2 	#multiplico iteración por 4
add $t3, $s1, $t7	#base snake + espacios a correr

lw $t2, 4($t3)
beq $t2, -1, fin_dabajo

lw $t2, 4($t3)		#cargo nuevo cola (la cola de antes del desplazamiento eliminada)
sw $t2, 0($t3)





addi $s4, $s4, 1

j desplazar_cuerpo_abajo

fin_dabajo:
lw $t2, 0($t3)

beq $t2, 960, borde_abajo
beq $t2, 964, borde_abajo
beq $t2, 968, borde_abajo
beq $t2, 972, borde_abajo
beq $t2, 976, borde_abajo
beq $t2, 980, borde_abajo
beq $t2, 984, borde_abajo
beq $t2, 988, borde_abajo
beq $t2, 992, borde_abajo
beq $t2, 996, borde_abajo
beq $t2, 1000, borde_abajo
beq $t2, 1004, borde_abajo
beq $t2, 1008, borde_abajo
beq $t2, 1012, borde_abajo
beq $t2, 1016, borde_abajo
beq $t2, 1020, borde_abajo



addi $t2,$t2,64
sw $t2, 0($t3)
#add $t2, $s0, $zero
############################################
#generar cabeza
#add $t3, $t3, 

add $t2, $s0, $t2

j sin_borde_abajo

#lw $t2, 0($t2)
#beq $t2, $zero, fin_desplazar_cuerpo
#lw $t2, 0($s1)
#add $t2, $s0, $t2

borde_abajo:
addi $t2,$t2,-896
sw $t2,0($t3)
add $t2,$s0,$t2

sin_borde_abajo:


sw $s6, 0($t2)

j teclado
#####################################
#####################################
#####################################

salir:




#sll $t4, $a0, 2
#add $t2, $s0, $t4
