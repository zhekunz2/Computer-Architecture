module keypad(valid, number, a, b, c, d, e, f, g);
   output 	valid;
   output [3:0] number;
   input 	a, b, c, d, e, f, g;
   wire w1, w2, w3, w4, w5, w6, w7, w8, w9, w10, w11, w12, w13, w14, w15, num1, num2, num3, num4, num5, num6, num7, num8, num9, num0;

   or o1(valid, w2, w3);
   or a1(w2, num1, num2);
   or a2(w3, w11, w12);
   or a3(w11, w13, w14);
   or a4(w12, num3, num4);
   or a5(w13, num5, num6);
   or a6(w14, w15, num7);
   or a7(w15, w1, num9);
   or a8(w1, num8, num0);

   and a3(num1, a, d);
   and a4(num2, b, d);
   and a5(num3, c, d);
   and a6(num4, a, e);
   and a7(num5, b, e);
   and a8(num6, c, e);
   and a9(num7, a, f);
   and a10(num8, b, f);
   and a11(num9, c, f);
   and a12(num0, b, g);

   or o2(number[0], w4, w5);
   or o3(w4, num1, num3);
   or o4(w5, w6, num5);
   or o5(w6, num7, num9);

   or o6(number[1], w7, w8);
   or o7(w7, num2, num3);
   or o8(w8, num6, num7);

   or o9(number[2], w9, w10);
   or o10(w9, num4, num5);
   or o11(w10, num6, num7);

   or o12(number[3], num8, num9);
endmodule // keypad
