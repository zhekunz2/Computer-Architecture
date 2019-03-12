/**
 * @file
 * Contains an implementation of the countOnes function.
 */

unsigned countOnes(unsigned input) {
	// TODO: write your code here
		unsigned a = input & 0xAAAAAAAA;
		unsigned b = input & 0x55555555;
		input = (a >> 1) + b;
		input = ((input & 0xCCCCCCCC) >> 2) + (input & 0x33333333);

		a = input & 0xF0F0F0F0;
		b = input & 0x0F0F0F0F;
		input = (a >> 4) + b;

		a = input & 0xFF00FF00;
		b = input & 0x00FF00FF;
		input = (a >> 8) + b;

		a = input & 0xFFFF0000;
		b = input & 0x0000FFFF;
		return 	input = (a >> 16) + b;


	return input;
}
