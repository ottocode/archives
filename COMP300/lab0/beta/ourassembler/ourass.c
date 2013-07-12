#include <stdio.h>
#include <stdlib.h>
#include <assert.h>

#define BYTETOBINARYPATTERN "%d%d%d%d%d%d%d%d"
#define BYTETOBINARY(byte) \
    (byte & 0x80 ? 1 : 0), \
    (byte & 0x40 ? 1 : 0), \
    (byte & 0x20 ? 1 : 0), \
    (byte & 0x10 ? 1 : 0), \
    (byte & 0x08 ? 1 : 0), \
    (byte & 0x04 ? 1 : 0), \
    (byte & 0x02 ? 1 : 0), \
    (byte & 0x01 ? 1 : 0)

#define OPTOINSTPAT "%s%s%s"
#define OPTOINST(byte) \
    0,0, \
    (byte & 0x80 ? 1 : 0), \
    (byte & 0x40 ? 1 : 0), \
    (byte & 0x20 ? 1 : 0), \
    (byte & 0x10 ? 1 : 0), \
    (byte & 0x08 ? 1 : 0), \
    (byte & 0x04 ? 1 : 0), \
    (byte & 0x02 ? 1 : 0), \
    (byte & 0x01 ? 1 : 0)




char *operations[] = {"mul", "add", "sub", "or", "nor", "sr", "lw", "sw", "bne", "beq", "slt", "j", "set", "sl", "TRAP", NULL};
char *functions[] = {"QUIT", "IN", "OUT", "CALL", "RET", "PUSH", "POP", NULL};
int DEBUG = 1;
int TEST1 = 1;

void opTest();

int main(int argc, char* argv[]){
    int i, j, k;
    FILE *base;
    printf("ISA assembler\n");
    if (DEBUG){
        printf("Command Line arguments:\n");
        for( i=0; i < argc; i++){
            printf("\tArg %d: %s\n", i, argv[i]);
        }
    }
    if(TEST1){
        opTest();
    }

    if (argc < 3) {
        printf("Not enough command line arguments!\n");
        exit(1);
    }
    base = fopen(argv[1], "r");
    assert(base);
    char *line;
    while( fgets(line, 1000, base) != NULL ){
        printf("%s\n", line);
    }


    fclose(base);
    return 0;
}


void opTest(){
    printf("Testing operations and functions\n");
    int i = 1;
    char **ops;
    ops = operations;
    while (*ops) {
        //printf("operation: %s, binary: "BYTETOBINARYPATTERN"\n", *ops, BYTETOBINARY(i));
        printf("operation: %s, hex: %x\n", *ops, i);
        i++;
        ops++;
    }

    i = 0;
    ops = functions;
    while (*ops) {
        printf("function: %s, hex: %x\n", *ops, i++);
        ops++;
    }

    //printf ("Leading text "BYTETOBINARYPATTERN"\n", BYTETOBINARY(17));

}
