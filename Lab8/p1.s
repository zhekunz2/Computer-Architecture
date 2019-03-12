.text

##int
##dfs(int target, int i, int* tree) {
##	if (i >= 127) {
##		return -1;
##	}
##	if (target == tree[i]) {
##		return 0;
##	}
##
##	int ret = dfs(target, 2 * i, tree);
##	if (ret >= 0) {
##		return ret + 1;
##	}
##	ret = dfs(target, 2 * i + 1, tree);
##	if (ret >= 0) {
##		return ret + 1;
##	}
##	return ret;
##}

.globl dfs
dfs:
	blt $a1 127 next_if
	li $v0 -1
	jr $ra
next_if:
	mul $t0 $a1 4
	add $t0 $t0 $a2
	lw $t0 0($t0)
	bne $a0 $t0 dfs_start
	li $v0 0
	jr $ra
dfs_start:
	sub $sp $sp 8
	sw $ra 0($sp)
	sw $s0 4($sp)
	move $s0 $a1
	mul $a1 $s0 2
	jal dfs
	blt $v0 0 next_dfs
	add $v0 $v0 1
	lw $ra 0($sp)
	lw $s0 4($sp)
	add $sp $sp 8
	jr $ra
next_dfs:
	mul $a1 $s0 2
	add $a1 $a1 1
	jal dfs
	blt $v0 0 end
	add $v0 $v0 1
	lw $ra 0($sp)
	lw $s0 4($sp)
	add $sp $sp 8
	jr $ra
end:
	lw $ra 0($sp)
	lw $s0 4($sp)
	add $sp $sp 8
  jr $ra
