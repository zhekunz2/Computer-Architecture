/**
 * @file
 * Contains an implementation of the extractMessage function.
 */

#include <iostream> // might be useful for debugging
#include <assert.h>
#include "extractMessage.h"

using namespace std;

char *extractMessage(const char *message_in, int length) {
   // Length must be a multiple of 8
   assert((length % 8) == 0);

   // allocates an array for the output
   char *message_out = new char[length];
   for (int i=0; i<length; i++) {
   		message_out[i] = 0;    // Initialize all elements to zero.
	}
	// TODO: write your code here
  unsigned char a = 0x01;

  for (int i = 0; i < length; i++) {
    if (i % 8 == 0) {
      a = 0x01;
    }
    unsigned char current = 0x00;
    for (int j = 0; j < 8; j++) {
      current = current + ( ( message_in[(i/8)*8+j] & a)>>(i%8)<<j);
    }
    message_out[i] = current;
    a = a << 1;
  }
  return message_out;
}
