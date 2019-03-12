.text

##struct Puzzle {
##    int NUM_ROWS;
##    int NUM_COLS;
##    char** board;
##};
##
##
##char floodfill (Puzzle* puzzle, char marker, int row, int col) {
##    if (row < 0 || col < 0) {
##        return marker;
##    }
##
##    if (row >= puzzle->NUM_ROWS || col >= puzzle->NUM_COLS) {
##        return marker;
##    }
##
##    char ** board = puzzle->board;
##
##    if (board[row][col] != '#') {
##        return marker;
##    }
##
##    board[row][col] = marker;
##
##    floodfill(puzzle, marker, row + 1, col + 1);
##    floodfill(puzzle, marker, row + 1, col + 0);
##    floodfill(puzzle, marker, row + 1, col - 1);
##
##    floodfill(puzzle, marker, row, col + 1);
##    floodfill(puzzle, marker, row, col - 1);
##
##    floodfill(puzzle, marker, row - 1, col + 1);
##    floodfill(puzzle, marker, row - 1, col + 0);
##    floodfill(puzzle, marker, row - 1, col - 1);
##
##    return marker + 1;
##}

.globl floodfill
floodfill:
	blt $a2 0 return_marker
	blt $a3 0 return_marker
	lw $t0 0($a0) ## t0 = puzzle->NUM_ROWS
	lw $t1 4($a0) ## t1 = puzzle->NUM_COLS
	bge $a2 $t0 return_marker
	bge $a3 $t1 return_marker
  lw $t2 8($a0) ## t2 = puzzle->board
	sll $t3 $a2 2
	add $t2 $t2 $t3
	lw $t2 0($t2)
	add $t2 $t2 $a3
	lbu $t4 0($t2)
	li $t3 '#'
	bne $t4 $t3 return_marker
	j after_marker
return_marker:
	move $v0 $a1
	jr	$ra
after_marker:
	sb $a1 0($t2)
	sub $sp $sp 32
	sw $ra 0($sp)
	sw $s0 4($sp)
	sw $s1 8($sp)
	sw $s2, 12($sp)
	sw $s3, 16($sp)
	sw $s4, 20($sp)
	sw $s5, 24($sp)
	sw $s6, 28($sp)

	move $s0 $a2
	move $s1 $a3
	move $s2 $a1
	move $s3 $a0
  lw $s4 0($a0)
  lw $s5 4($a0)
  lbu $s6 8($a0)
	add $a2 $s0 1
	add $a3 $s1 1
	jal floodfill

	move $a0 $s3
	move $a1 $s2
	move $a2 $s0
	move $a3 $s1
	add $a2 $s0 1
 	add $a3 $s1 0
	jal floodfill
	move $a0 $s3
	move $a1 $s2
	move $a2 $s0
	move $a3 $s1
	add $a2 $s0 1
	sub $a3 $s1 1
	jal floodfill
	move $a0 $s3
	move $a1 $s2
	move $a2 $s0
	move $a3 $s1
	add $a2 $s0 0
	add $a3 $s1 1
	jal floodfill
	move $a0 $s3
	move $a1 $s2
	move $a2 $s0
	move $a3 $s1
	add $a2 $s0 0
	sub $a3 $s1 1
	jal floodfill
	move $a0 $s3
	move $a1 $s2
	move $a2 $s0
	move $a3 $s1
	sub $a2 $s0 1
	add $a3 $s1 1
	jal floodfill
	move $a0 $s3
	move $a1 $s2
	move $a2 $s0
	move $a3 $s1
	sub $a2 $s0 1
	add $a3 $s1 0
	jal floodfill
	move $a0 $s3
	move $a1 $s2
	move $a2 $s0
	move $a3 $s1
	sub $a2 $s0 1
	sub $a3 $s1 1
	jal floodfill
	move $a0 $s3
	move $a1 $s2
	move $a2 $s0
	move $a3 $s1
	lw $ra 0($sp)
	lw $s0 4($sp)
	lw $s1 8($sp)
	lw $s2, 12($sp)
	lw $s3, 16($sp)
	lw $s4, 20($sp)
	lw $s5, 24($sp)
	lw $s6, 28($sp)
	add $sp $sp 32
	add $v0 $a1 1
	jr $ra




##void
##floyd_warshall (int graph[6][6], int shortest_distance[6][6]) {
##    for (int i = 0; i < 6; ++i) {
##        for (int j = 0; j < 6; ++j) {
		##			if (i == j) {
		##				shortest_distance[i][j] = 0;
		##			} else {
		##				shortest_distance[i][j] = graph[i][j];
		##			}
##				}
##		}
##    for (int k = 0; k < 6; k++) {
##        for (int i = 0; i < 6; i++) {
##            for (int j = 0; j < 6; j++) {
			##				if (shortest_distance[i][k] + shortest_distance[k][j] < shortest_distance[i][j]) {
			##					shortest_distance[i][j] = shortest_distance[i][k] + shortest_distance[k][j];
			##				}
##            }
##        }
##    }
##}

.globl floyd_warshall
floyd_warshall:
	li $t0 0
first_outer:
	bge $t0 6 after_first_outer
	li $t1 0
first_inner:
	bge $t1 6 after_first_inner
	bne $t1 $t0 not_equal
	sll $t9 $t0 2
	mul $t9 $t9 6
	sll $t8 $t1 2
	add $t9 $t9 $t8
	add $t9 $t9 $a1
	li $t8 0
	sw $t8 0($t9)
	add $t1 $t1 1
	j first_inner
not_equal:
	sll $t9 $t0 2
	mul $t9 $t9 6
	sll $t8 $t1 2
	add $t9 $t9 $t8
	add $t7 $t9 $a0
	lw $t8 0($t7)
	add $t7 $t9 $a1
	sw $t8 0($t7)
	add $t1 $t1 1
	j first_inner
after_first_inner:
	add $t0 $t0 1
	j first_outer
after_first_outer:

	li $t0 0
second_k:
	bge $t0 6 end
	li $t1 0
second_i:
	bge $t1 6 after_second_i
	li $t2 0
second_j:
	bge $t2 6 after_second_j
	##  shortest_distance[i][k] + shortest_distance[k][j] < shortest_distance[i][j]
	mul $t9 $t1 24
	sll $t8 $t0 2
	add $t9 $t9 $t8
	add $t9 $t9 $a1
	lw $t7 0($t9) ## shortest_distance[i][k]
	mul $t9 $t0 24
	sll $t8 $t2 2
	add $t9 $t9 $t8
	add $t9 $t9 $a1
	lw $t6 0($t9) ## shortest_distance[k][j]
	mul $t9 $t1 24
	sll $t8 $t2 2
	add $t9 $t9 $t8
	add $t9 $t9 $a1
	lw $t5 0($t9) ## shortest_distance[i][j]
	add $t6 $t6 $t7
	bge $t6 $t5 after_if
	sw $t6 0($t9)
	add $t2 $t2 1
	j second_j
after_if:
	add $t2 $t2 1
	j second_j
after_second_j:
	add $t1 $t1 1
	j second_i
after_second_i:
	add $t0 $t0 1
	j second_k
end:
	jr $ra
