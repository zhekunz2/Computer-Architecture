.text

##// Sets the values of the array to the corresponding values in the request
##void decode_request(unsigned long int request, int* array) {
##  // The hi and lo values are already given to you, so you don't have to
##  // perform these shifting operations. They are included so that this
##  // code functions in C. The lo value is $a0 and the hi value is $a1.
##  unsigned lo = (unsigned)((request << 32) >> 32);
##  unsigned hi = (unsigned)(request >> 32);
##
##  for (int i = 0; i < 6; ++i) {
##    array[i] = lo & 0x0000001f;
##    lo = lo >> 5;
##  }
##  unsigned upper_three_bits = (hi << 2) & 0x0000001f;
##  array[6] = upper_three_bits | lo;
##  hi = hi >> 3;
##  for (int i = 7; i < 11; ++i) {
##    array[i] = hi & 0x0000001f;
##    hi = hi >> 5;
##  }
##}

.globl decode_request
decode_request:
	li $t0 0
	move $t3 $a2
for_loop1:
	bge $t0 6 end_loop1
	andi $t1 $a0 0x0000001f
	sw $t1 0($t3)
	srl $a0 $a0 5
	add $t3 $t3 4
	add $t0 $t0 1
	j for_loop1
end_loop1:
	sll $t2 $a1 2
	andi $t2 $t2 0x0000001f
	or $t2 $a0 $t2
	sw $t2 0($t3)
	srl $a1 $a1 3
	add $t3 $t3 4
	li $t0 7
for_loop2:
	bge $t0 11 end
	andi $t1 $a1 0x0000001f
	sw $t1 0($t3)
	add $t3 $t3 4
	add $t0 $t0 1
	srl $a1 $a1 5
	j for_loop2
end:
	jr	$ra
