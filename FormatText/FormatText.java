//package formattext;

import java.util.*;
import java.io.*;

public class FormatText {

    public static int MAX_WIDTH;
    public static String FILE_NAME;

    public static void main(String[] args) throws IOException {

        /* These two command line arguments need to be checked for improper user entries */
        FILE_NAME = args[0];
        MAX_WIDTH = Integer.parseInt(args[1]);

        readFile();


    }

    private static void readFile() throws FileNotFoundException, IOException {


        List<String> words = new ArrayList<String>();

        boolean startPar = true;

        try {

            BufferedReader bufferedReader = new BufferedReader(new FileReader(FILE_NAME));
            String temp = bufferedReader.readLine();

            int totalChars = 0;

            while (temp != null) { // loop through the lines

                if (temp.trim().length() < 1 && totalChars > 0) {
                    writeFile(2, words, totalChars);
                    totalChars = 0;
                    words.clear();
                    startPar = true;
                    writeFile(3, words, totalChars);
                } else if (temp.trim().length() < 1 && totalChars < 1) {
                    writeFile(3, words, totalChars);
                    totalChars = 0;
                    words.clear();
                    startPar = true;

                } else {

                    for (int i = 0; i < temp.length(); i++) { // loop through the words

                        String word = "";
                        while (i < temp.length() && temp.charAt(i) != ' ') { // loop through the chars
                            word = word + temp.charAt(i);
                            i++;
                        }

                        if ((totalChars + words.size() + word.length()) + 5 > MAX_WIDTH && startPar) {

                            writeFile(0, words, totalChars);
                            startPar = false;
                            totalChars = 0;
                            words.clear();

                        } else if (totalChars + words.size() + word.length() > MAX_WIDTH) {
                            writeFile(1, words, totalChars);
                            totalChars = 0;
                            words.clear();
                        }

                        if (word.length() > 0) {
                            totalChars += word.length();
                            words.add(word);
                        }

                    }
                }
                temp = bufferedReader.readLine();
            }

            if(words.size() > 0){
            writeFile(2, words, totalChars);
            }

            bufferedReader.close();

        } catch (FileNotFoundException e) {

            System.out.println(e.getMessage());
            System.exit(0);

        }

    }

    private static void writeFile(int header, List<String> words, int totalChars) throws IOException {
        /*Doesn't handle special cases yet, but works otherwise */

        /* Headers
         0 = First Line
         1 = Middle Line
         2 = Last Line
         3 = Empty Line */


        switch (header) {

            case 0:
                System.out.println("First Line");
                System.out.print("     ");
                writeFile(1, words, totalChars+5);
                break;

            case 1:
                int num_spaces = MAX_WIDTH - totalChars;
                int min_separation = num_spaces / (words.size() - 1);
                int remainder_spaces = num_spaces % (words.size() - 1);

                String space = "";
                for (int i = 0; i < min_separation; i++) {
                    space = String.format(space + " ");
                }

                for (int i = 0; i < words.size() - 1; i++) {
                    System.out.print(words.get(i) + space);

                    if (remainder_spaces > 0) {
                        System.out.print(" ");
                        remainder_spaces--;
                    }
                }
                System.out.print(words.get(words.size() - 1));
                System.out.println();
                break;



            case 2:
                System.out.println("Last Line");
                break;




            case 3:
                System.out.println("Empty Line");
                break;
        }

    }
}
