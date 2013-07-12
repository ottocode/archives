/** Assembler for theISA.
 *
 * Authors: Marc Slaughter and Nicholas Otto
 * 3/8/13
 */
import java.util.*;
import java.io.*;

class Assemble{
    static boolean debug = false;
    static boolean pass2debug = true;
    static boolean dataDebug = false;

    static HashMap<String, String> lookup = new HashMap<String, String>();
    static ArrayList<Instruction> iarray;
    static ArrayList<Label> labels;
    static BufferedReader sourceFile;
    static BufferedReader hexSource;
    static BufferedWriter out_code;
    static BufferedWriter hex_code;
    static BufferedWriter out_data;
    static HashMap<String, String> regconverter;

    public static void main(String[] args){
        iarray = new ArrayList<Instruction>();
        labels = new ArrayList<Label>();
        lookup.put("mul", "0001");
        lookup.put("add", "0010");
        lookup.put("sub", "0011");
        lookup.put("or", "0100");
        lookup.put("nor", "0101");
        lookup.put("sr", "0110");
        lookup.put("lw", "0111");
        lookup.put("sw", "1000");
        lookup.put("bne", "1001");
        lookup.put("beq", "1010");
        lookup.put("slt", "1011");
        lookup.put("j", "1100000000");
        lookup.put("set", "1101");
        lookup.put("sl", "1110");
        lookup.put("TRAP", "1111");
        lookup.put("QUIT", "000");
        lookup.put("IN", "001");
        lookup.put("OUT", "010");
        lookup.put("CALL", "011");
        lookup.put("RET", "100");
        lookup.put("PUSH", "101");
        lookup.put("POP", "110");

        regconverter = new HashMap<String, String>();
        regconverter.put("$0", "000");
        regconverter.put("$1", "001");
        regconverter.put("$2", "010");
        regconverter.put("$3", "011");
        regconverter.put("$4", "100");
        regconverter.put("$5", "101");
        regconverter.put("$6", "110");
        regconverter.put("$7", "111");
        regconverter.put("$8",  "01000");
        regconverter.put("$9",  "01001");
        regconverter.put("$10", "01010");
        regconverter.put("$11", "01011");
        regconverter.put("$12", "01100");
        regconverter.put("$13", "01101");
        regconverter.put("$14", "01110");
        regconverter.put("$15", "01111");
        regconverter.put("$16", "10000");
        regconverter.put("$17", "10001");
        regconverter.put("$18", "10010");
        regconverter.put("$19", "10011");
        regconverter.put("$20", "10100");
        regconverter.put("$21", "10101");
        regconverter.put("$22", "10110");
        regconverter.put("$23", "10111");
        regconverter.put("$24", "11000");
        regconverter.put("$25", "11001");
        regconverter.put("$26", "11010");
        regconverter.put("$27", "11011");
        regconverter.put("$28", "11100");
        regconverter.put("$29", "11101");
        regconverter.put("$30", "11110");
        regconverter.put("$31", "11111");


        try{
            sourceFile = new BufferedReader(new FileReader(args[0]));
            out_code = new BufferedWriter(new FileWriter(args[1]+"_i.hex"));
            out_data = new BufferedWriter(new FileWriter(args[1]+"_d.coe"));
        }catch(Exception e){}
        
        
        
        firstPass();
        passTwo();
        if(debug){System.out.println("at the end");}
        try{
            sourceFile.close();
            out_code.close();
        }catch(Exception e){}
        try{
            handleData(args[0]);
            out_data.close();
            hexSource = new BufferedReader(new FileReader(args[1]+"_i.hex"));
            hex_code = new BufferedWriter(new FileWriter(args[1]+"_i.coe"));
            convertToHex();
            hexSource.close();
            hex_code.close();
        }catch(Exception e){}

    }

    static void convertToHex(){
    try{
        String end = ",";
        String line = hexSource.readLine();
        hex_code.write(line);
        hex_code.newLine();
        line = hexSource.readLine();
        hex_code.write(line);
        hex_code.newLine();

        String pad = "0";
        while(hexSource.ready()){
            String binOutput = hexSource.readLine();
            String bin = Integer.toHexString(Integer.parseInt(binOutput, 2));
            for( int mmm = bin.length(); mmm< 5; mmm++){
                bin = pad + bin;
            }
            hex_code.write(bin + end);
            hex_code.newLine();

        }
        hex_code.write("<EOF>");

    }catch(Exception e){}}

    static void firstPass(){
        String line = "";
        try{line = sourceFile.readLine().trim();}catch(Exception e){}
        try{
        while (!line.equals(".data") && sourceFile.ready()){
            try{line = sourceFile.readLine().trim();}catch(Exception e){}

            if(debug){System.out.println("line is: " + line + "endline");}
            if(line.startsWith("//")){continue;}

            if(line.indexOf("//") != -1){
                line = line.substring(0, line.indexOf("//")).trim();
            }

            line = line.trim();
            if(line.length() == 0){continue;}

            line = line.replaceAll(",", "");
            line = line.trim();
            String[] parts = line.split(" ");
            //parts[0] = op
            for(int l = 0; l < parts.length; l++){if(debug){System.out.println(parts[l]);}}
            if(lookup.containsKey(parts[0])){
                String[] targs = new String[parts.length-1];
                for( int i = 1; i < parts.length; i++){
                    if(parts[i].length()>0){
                        if(debug){System.out.println("arg: " + parts[i]);}
                        targs[i-1] = parts[i];
                    }
                }
                Instruction newI = new Instruction(parts[0], targs);
                iarray.add(newI);
            }

            //parts[0] = label
            else{

                String[] targs = new String[parts.length-2];
                for( int i = 2; i < parts.length; i++){
                    targs[i-2] = parts[i];
                }
                Instruction newI = new Instruction(parts[1], targs);
                long index = iarray.size();
                iarray.add(newI);
                Label tlabel = new Label(parts[0], index);
                labels.add(tlabel);
            }
        
        }}catch(Exception e){System.out.println("at first pass exception");}
       

    }

    static void passTwo(){
        try{out_code.write("MEMORY_INITIALIZATION_RADIX=16;\n");
        out_code.write("MEMORY_INITIALIZATION_VECTOR=\n");
        String lastfew = "";
        for(int i=0; i < iarray.size(); i++){
            Instruction temp = iarray.get(i);
            String padding = "0000";
            out_code.write(padding + lookup.get(temp.op));
            if(pass2debug){
            if(temp.op.equals("lw")){
                System.out.println("Gotcha");
                for(int m=0; m< temp.args.length; m++){
                    System.out.println(temp.args[m]);
                }
            }}
            if(pass2debug){System.out.printf("operations: %s%n",temp.op);}
            String[] a = temp.args;

            if(a == null){if(pass2debug){System.out.println("run for your life!");}}

            for (int j = 0; j < a.length; j++){
                if(pass2debug){System.out.println(a[j]);}

                if(a[j]==null){if(pass2debug){System.out.printf("run fast! %d\n", j);}}

                if(a[j].startsWith("$")){
                    out_code.write(regconverter.get(a[j]));
                }

                else if( lookup.containsKey(a[j])){//TRAP
                    out_code.write(lookup.get(a[j]));
                    j++;
                    String num = regconverter.get(a[j]);
                    String pad = "0";
                    if(num == null){continue;}
                    for(int s = num.length(); s < 6; s++){
                        num = pad + num;
                    }
                    out_code.write(num);
                }

                else if ( hasthisguy(a[j])){  //Label
                    int index = getthisguy(a[j]);

                    if(pass2debug){System.out.printf("Label: with index:%d%n", index);}
                    String binS = Integer.toBinaryString(index);
                    String tstring = "";
                    for( int k=binS.length(); k< 3; k++){
                        tstring = "0" + tstring;
                    }
                    out_code.write(tstring + binS);
                }

                else{//Digit
                    int d = Integer.parseInt(a[j]);
                    String binS = "";
                    binS = Integer.toBinaryString(d);
                    String tstring = "";
                    for( int k=binS.length(); k< 6; k++){
                        tstring =  "0" + tstring;
                    }
                    out_code.write(tstring + binS);
                }
            }
            
                out_code.write("");
                out_code.newLine();
          
        }
        }
        catch(Exception e){
            System.out.printf("Aha!%n%s%n", e.getMessage());
            e.printStackTrace();
            try{
                out_code.newLine();
                out_code.write("<EOF>");
            }catch(Exception f){}
        }

    }

    static void handleData(String filename){
        if(dataDebug){System.out.println("Handling Data");}
        String line = "";
        try{out_data.write("MEMORY_INITIALIZATION_RADIX=16;\n");}catch(Exception e){}
        try{out_data.write("MEMORY_INITIALIZATION_VECTOR=\n");}catch(Exception e){}
        String lastfew = "";
        try{
        String end = ",";
        sourceFile = new BufferedReader(new FileReader(filename));
        for(int j = 0; j < labels.size(); j++){
            Label tempL = labels.get(j);
            String tempS = Long.toHexString(tempL.n);
            if(dataDebug){System.out.printf("Label: %s, n: %d%n", tempL.l, tempL.n);}
            String pad = "0";
            for (int p = tempS.length(); p < 9; p++){
                tempS = pad + tempS;
            }
            out_data.write(tempS);
            out_data.write(end);
            out_data.newLine();
        }
        while(sourceFile.ready()){
            try{line = sourceFile.readLine().trim();}catch(Exception e){}
            line = line.replaceAll(",", "");
            String[] parts = line.split(" ");
            if(line.length()==0){continue;}
            //NO COMMENTS PLEASE
            if(parts[0].equals(".word")){
                for (int i=1; i < parts.length; i++){
                    String temp = parts[i].substring(2);
                    out_data.write(temp + lastfew);
                    out_data.write(end);
                    out_data.newLine();
                }
            }
            if(parts[0].equals(".fill")){
                for(int i=0; i<Integer.parseInt(parts[1]); i++){
                    String temp = parts[2].substring(2);
                    for(int j=temp.length(); j < 9; j++){
                        temp = "0" + temp;
                    }
                    out_data.write(temp+lastfew);
                    out_data.write(end);
                    out_data.newLine();
                }
            }
            
            
        }
        out_data.write("<EOF>");
        sourceFile.close();
        }catch(Exception e){}
        
    }

    public static boolean hasthisguy(String guy){
        for(int i=0; i< labels.size(); i++){
            if(labels.get(i).l.equals(guy)){
                return true;}
        }
        return false;
    }

    public static int getthisguy(String guy){
        for(int i=0; i< labels.size(); i++){
            if(labels.get(i).l.equals(guy)){
                return i;
            }
        }
        return -1;
    }


}
