.text

##struct Ingredient {
##  unsigned ing_type;
##  unsigned amount;
##};
##
##struct Request {
##  unsigned length;
##  Ingredient ingredients [11];
##};
##
###Performs a bubble sort on the given request using the given comparison function
##void bubble_sort(Request* request, int (*cmp_func) (Ingredient*, Ingredient*)) {
##    for (int i = 0; i < request->length; ++i) {
##        for (int j = 0; j < request->length - i - 1; ++j) {
##            if (cmp_func(&request->ingredients[j], &request->ingredients[j + 1]) > 0) {
##                Ingredient temp = request->ingredients[j];
##                request->ingredients[j] = request->ingredients[j + 1];
##                request->ingredients[j + 1] = temp;
##            }
##        }
##    }
##}

.globl bubble_sort
bubble_sort:
	sub $sp, $sp, 4
	sw	$ra, 0($sp)
	li	$t0, 0
	lw	$t1, 0($a0)

for_loop1:
	bge		$t0, $t1, end_for_loop1
	li 		$t2, 0
	add		$t4, $t0, 1
	sub		$t3, $t1, $t4
for_loop2:
	bge		$t2, $t3, end_for_loop2
	mul 	$t4, $t2, 8
	add		$t4, $t4, 4
	add 	$a2, $t4, $a0
	add		$a3, $a2, 8
	jalr 	$a1
	beq		$v0, $0, end_if
	lw	$t5, 0($a2)
	lw	$t6, 4($a2)
	lw	$t4, 0($a3)
	sw	$t4, 0($a2)
	lw	$t4, 4($a3)
	sw	$t4, 4($a2)
	sw	$t5, 0($a3)
	sw	$t6, 4($a3)
	j 	end_if

end_if: # prepare for the next loop_2
	add		$t2, $t2, 1
	j		for_loop2

end_for_loop2:
	add		$t0, $t0, 1
	j		for_loop1			

end_for_loop1:
	lw	$ra, 0($sp)
	add	$sp, $sp, 4
	jr	$ra



##int compare_ingredients(Ingredient* ingredient1, Ingredient* ingredient2) {
##    if (ingredient1->amount > ingredient2->amount) {
##        return 1;
##    } else {
##        return 0;
##    }
##}

.globl compare_ingredients
compare_ingredients:
	lw $t5 4($a2)
	lw $t6 4($a3)
	ble $t5 $t6 return_zero
	li $v0, 1
	jr $ra
return_zero:
	li $v0, 0
	jr	$ra


###Computes the euclidean squared distance between the given starting_coordinates
###and the index of the kitchen array that contains the given ingredient
##int euclidean_squared(unsigned kitchen[15][15],
##                      int starting_coordinates[2], unsigned ingredient) {
##  for (int i = 0 ; i < 15 ; ++ i) {
##    for (int j = 0 ; j < 15 ; ++ j) {
##      if (kitchen[i][j] == ingredient) {
##        return ((i - starting_coordinates[0]) * (i - starting_coordinates[0]) +
##                (j - starting_coordinates[1]) * (j - starting_coordinates[1]));
##      }
##    }
##  }
##  return -1;
##}

.globl euclidean_squared
euclidean_squared:
	li $t0, 0
for_lp1:
	bge $t0 15 end_for_lp1
	li $t1 0
for_lp2:
	bge $t1 15 end_for_lp2
	mul $t2 $t0 60
	add $t2 $t2 $a0
	mul $t3 $t1 4
	add $t3 $t3 $t2
	lw $t3 0($t3)
	bne $t3 $a2 end_for_if
	lw $t2 0($a1)
	lw $t3 4($a1)
	sub $t0 $t0 $t2
	mul $t0 $t0 $t0
	sub $t1 $t1 $t3
	mul $t1 $t1 $t1
	add $v0 $t1 $t0
	jr $ra
end_for_if:
	add $t1 $t1 1
	j for_lp2
end_for_lp2:
	add $t0 $t0 1
	j for_lp1
end_for_lp1:
	li $v0 -1
	jr	$ra
