
module palindrome_control(palindrome, done, select, load, go, a_ne_b, front_ge_back, clock, reset);
	output load, select, palindrome, done;
	input go, a_ne_b, front_ge_back;
	input clock, reset;

	wire sGarbage, sStart, sDone_notp, sDone_p, sRunning;

	wire sGarbage_next = sGarbage & ~go | reset;
	wire sStart_next = (sStart & go | sGarbage & go | (sDone_p | sDone_notp) & go) & (~reset);
	wire sRunning_next = (sStart & ~go & ~reset)|(sRunning & ~go & ~reset & ~front_ge_back & ~a_ne_b);
	wire sDone_notp_next = (sRunning & ~go & ~reset & a_ne_b & ~front_ge_back) | (sDone_notp & ~reset & ~go);
	wire sDone_p_next = (sRunning & ~go & ~reset & front_ge_back) | (sDone_p & ~reset & ~go);

	dffe fsGarbage(sGarbage, sGarbage_next, clock, 1'b1, 1'b0);
	dffe fsStart(sStart, sStart_next, clock, 1'b1, 1'b0);
	dffe fsRunning(sRunning, sRunning_next, clock, 1'b1, 1'b0);
	dffe fsDone_notp(sDone_notp, sDone_notp_next, clock, 1'b1, 1'b0);
	dffe fsDone_p(sDone_p, sDone_p_next, clock, 1'b1, 1'b0);

	assign done = sDone_p |sDone_notp;
	assign palindrome = sDone_p;
	assign load = sStart|sRunning;
	assign select = sRunning;
endmodule // palindrome_control
