class Instruction{
    String op;
String[] args;

    public Instruction(String op, String[] args){
        this.op = op;
        this.args = new String[args.length];
        for(int i=0; i<args.length; i++){
            this.args[i] = args[i];
        }
    }
}

