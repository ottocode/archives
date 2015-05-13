{
	int top;
	int total;
	int condition;
	int zero;

	top = 10;
	total = 0;
	condition = 0;
	zero = 0;
	
	goto check top;

begin sum:
	total = total + top;
	top = top - 1;

begin check:
	condition = top == zero;
	goto sum condition;

}
