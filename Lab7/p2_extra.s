.text

##// Returns a long int message given the decoded message in
##// the array.
##long int create_request(int* array) {
##  unsigned lo = ((array[6] << 30) >> 30);
##  for (int i = 5; i >= 0; --i) {
##    lo = lo << 5;
##    lo |= array[i];
##  }
##
##  unsigned hi = 0;
##  for (int i = 11; i > 7; --i) {
##   hi |= array[i];
##    hi = hi << 5;
##  }
##  hi |= array[7];
##  hi = hi << 3;
##  hi |= (array[6] >> 2);
##
##  //Because you can't store long int values in a register, the
##  //following code is not necessary to implement in MIPS. It
##  //is included so that this code functions in C.
##
##  unsigned long int request = (unsigned long int)hi << 32;
##  request |= (unsigned long int)lo;
##  return request;
##}

.globl create_request
create_request:
	add $v0 $a0 24
	lw $v0 0($v0)
	sll $v0 $v0 30
	srl $v0 $v0 30
	li $t1 5
c_for_loop1:
	blt $t1 0 c_end_lp1
	sll $v0 $v0 5
	mul $t2 $t1 4
	add $t2 $t2 $a0
	lw $t2 0($t2)
	or $v0 $v0 $t2
	sub $t1 $t1 1
	j c_for_loop1
c_end_lp1:
	li $v1 0
	li $t1 11
c_for_loop2:
	ble $t1 7 c_end_lp2
	mul $t2 $t1 4
	add $t2 $t2 $a0
	lw $t2 0($t2)
	or $v1 $v1 $t2
	sll $v1 $v1 5
	sub $t1 $t1 1
	j c_for_loop2
c_end_lp2:
 	add $t2 $a0 28
	lw $t2 0($t2)
	or $v1 $v1 $t2
	sll $v1 $v1 3
	add $t2 $a0 24
	lw $t2 0($t2)
	srl $t2 $t2 2
	or $v1 $v1 $t2
	jr	$ra
