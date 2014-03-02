% The game of Nim, MMIX style
%   Author: Nicholas Otto
%       good luck.

lstmv   GREG    0           //heap number the computer just took from 
lstct   GREG    0           //bean number the computer just took
hpct    GREG    0           //number of heaps
hpt     GREG    0           //pointer to current heap, a temp variable
usr     GREG    0           //for goto user section
cpt     GREG    0           //for goto computer section
mn      GREG    0           //to return to main

        LOC     Data_Segment

        GREG    @
hi      BYTE    "Welcome to the game of Nim!",#a,#a,0
hprmpt  BYTE    "Please indicate the number of beans in each heap by "
        BYTE    "entering the number of beans in each heap, separated "
        BYTE    "by a space.",#a
        BYTE    "You may use multiple lines.",#a
        BYTE    "Indicate you are done entering values by entering a "
        BYTE    "heap with 0 beans at the end.",#a
        BYTE    "A '0' entry followed by more valid entries will be "
        BYTE    "ignored",#a,#a
        BYTE    "Setup: ",0

        GREG    @

pick    BYTE    "Please pick which heap and how many beans to remove "
        BYTE    "by typing <heap> <beans> followed by the <return> "
        BYTE    "character.",#a
        BYTE    "pick: ",0

        GREG    @
inAd    LOC     @+248       //Arbitrary, but any bigger needs GREG
inArg   OCTA    inAd
        OCTA    248

heaph   GREG     @          //pointer to head of game information

        LOC     Pool_Segment
        GREG    @
nmland  LOC     @           //no man's land. Space for "scratch work"

        LOC     #100
Main    LDA     $255,hi             // Friendly hello
        TRAP    0,Fputs,StdOut       
        PUSHJ   0,Init              //Set up game
        PUSHJ   0,Disp              //Show setup

        //find who's going first
        GETA    $255,first          //ask user
        TRAP    0,Fputs,StdOut
        LDA     $255,inArg          // take in response
        TRAP    0,Fgets,StdIn
        LDA     $0,inAd             //get response
        LDB     $0,$0
        CMP     $0,$0,'y'           //yes or no

        //initialize addr and call appropriate co-routine
        GETA    usr,user
        GETA    cpt,cmptr
        GETA    mn,back
        BNZ     $0,cmptr       //0 if user goes first
        JMP     user

back    GETA    $255,last
        TRAP    0,Fputs,StdOut
        TRAP    0,Halt,0

first   BYTE    "Would you like to go first?  'y' for yes: ",0
        LOC     (@+3)&-4
last    BYTE    "Thanks for playing!",#a,0
    
        PREFIX Init:
:Init   GET     $0,:rJ
1H      LDA     :hpt,:heaph

        LDA     $255,:hprmpt        //Prompt for input
        TRAP    0,:Fputs,:StdOut
        JMP     2F

0H      GETA    $255,prmpt
        TRAP    0,:Fputs,:StdOut
2H      LDA     $255,:inArg         //Read in a line
        TRAP    0,:Fgets,:StdIn

        SUB     $2,$255,1           //Number of characters read

        PUSHJ   1,:Stup
        BZ      :hpct,1B            //heap count=0, read did nothing
        PBNZ    $1,0B               //$1=0 if user did not enter ' 0 '

        PUT     :rJ,$0
        POP     0,0
prmpt   BYTE    "More heaps: ",0

        PREFIX :

        PREFIX Stup:
//The nastiest subroutine.  Would have been much easier to not allow
//  multiple rows or just prompt for the piles one at a time.
//  But, here it is, with all its special cases!

base    IS      10

sz      IS      $0              //size of user input
nxtb    IS      $1              //inad+nxtb = addr byt
byt     IS      $2              //current byte of user input
num     IS      $3              //number we're reading in
tmp     IS      $4
tmp2    IS      $5
end     IS      $6              //signal for when a '0' is read
inad    IS      $7              //address of user input


:Stup   SET     nxtb,0              //setup
        SET     num,0
        LDA     inad,:inAd

        JMP     4F
1H      ADD     nxtb,nxtb,1
        CMPU    tmp,byt,' '         //check if a space char
        PBNZ    tmp,2F

        //is a space
        BZ      num,4F              //num is 0, just loop
        STO     num,:hpt            //num not 0, have a new number
        ADD     :hpt,:hpt,8         //move heap ptr to next octobyte
        ADD     :hpct,:hpct,1       //update heap count
        SET     num,0               //reset num
        SET     end,0               //reset end (last digit might be 0)
        JMP     4F

        //not a space
2H      CMP     tmp,byt,'0'-1       
        CMP     tmp2,byt,'9'+1
        ADD     tmp,tmp,tmp2        //Make sure byt is decimal digit
        BNZ     tmp,5F              //not space or digit, invalid char

        MUL     num,num,10
        SUB     byt,byt,'0'         //ASCII to numeric value
        ADD     num,num,byt         //update num
        ZSNZ    end,byt,1           //check if digit entered was a 0

4H      LDB     byt,inad,nxtb
        SUB     tmp,sz,nxtb
        PBNZ    tmp,1B              // need to proccess byte
        OR      tmp,num,end
        PBZ     tmp,6F              // user probably just used one line

        //exit but user want to add more values
        BZ      num,7F              //num already in if last char=space
        STO     num,:hpt            //otherwise, add num
        ADD     :hpt,:hpt,8
        ADD     :hpct,:hpct,1
7H      SET     $0,:hpt
        POP     1,0

        //received exit signal, user entered ' 0 '
6H      SET     $0,0
        POP     1,0

        //Error
5H      GETA    $255,invalc
        TRAP    0,:Fputs,:StdOut
        SET     :hpct,0             //indicates re-start condition
        POP     0,0
invalc  BYTE    "Found invalid character.  Re-enter all values!",#a,0
        PREFIX :


        PREFIX Disp:

j       IS      $0      //index holder
ret     IS      $1      //return value
tmp     IS      $2
param   IS      $3      //paramater passed to integer print subroutines


:Disp   GETA    $255,hdr            //pretty header
        TRAP    0,:Fputs,:StdOut

        GET     ret,:rJ
        SET     j,0

1H      ADD     param,j,1           
        //print left side of display
        PUSHJ   2,:prntL           //print left side, which is rJust

        //print middle
        GETA    $255,mid            //print divider
        TRAP    0,:Fputs,:StdOut

        //print right side
        SL      tmp,j,3
        LDO     param,:heaph,tmp    //bean count in :heaph + j*8
        PUSHJ   2,:prntR            //print right side, lJust
        ADD     tmp,j,1             //j is 1 less than heap number
        CMP     tmp,tmp,:lstmv
        PBNZ    tmp,2F              //just print \n 
        
        GETA    $255,arrow          //if computer just made move here
        TRAP    0,:Fputs,:StdOut
        SET     param,:lstct
        PUSHJ   2,:prntR        //printR is just an int prnt subroutine

2H      GETA    $255,nl         //newline
        TRAP    0,:Fputs,:StdOut
        ADD     j,j,1
        SUB     tmp,:hpct,j
        PBNZ    tmp,1B

        PUT     :rJ,ret
        POP     0,0

hdr     BYTE    "                heaps  |  beans                ",#a
        BYTE    "-----------------------------------------------",#a,0
        LOC     (@+3)&-4
mid     BYTE    "  |  ",0
        LOC     (@+3)&-4
arrow   BYTE    " <  -",0
        LOC     (@+3)&-4
nl      BYTE    #a,0
        PREFIX  :


        PREFIX prntL:

num     IS      $0              //the number to print
rem     IS      $1              //remainder
j       IS      $2              //counter
curr    IS      $3              //current addr
tmp     IS      $4

base    IS      10

:prntL  SET     j,23            //need 23 characters printed total
        LDA     curr,:nmland
        ADD     curr,curr,21
        SET     rem,0           //terminate string with 0

        JMP     2F
0H      SUB     j,j,1
        PBZ     num,1F          //num probably much less than 23 digits
        DIV     num,num,base
        GET     rem,:rR
        ADD     rem,rem,'0'
        JMP     2F

1H      SET     rem,' '         //lots of spaces
2H      STB     rem,curr
        SUB     curr,curr,1

        PBNZ    j,0B

        LDA     $255,:nmland    //print it out
        TRAP    0,:Fputs,:StdOut
        POP     0,0

        PREFIX :

        PREFIX printR:

num     IS      $0                  //number we're printing
rem     IS      $1                  //remainder after div
curr    IS      $2                  //current addr
tmp     IS      $3                  

base    IS      10

:prntR  LDA     curr,:nmland
        ADD     curr,curr,40        //arbitrary, space for 40 digits
        SET     tmp,0               //last ascii value is 0
        STB     tmp,curr
        SUB     curr,curr,1

1H      DIV     num,num,base        //get rem = num %10
        GET     rem,:rR
        ADD     rem,rem,'0'         //rem-> ascii
        SUB     curr,curr,1
        STB     rem,curr            //store rem
2H      PBNZ    num,1B

        SET     $255,curr           //print it out
        TRAP    0,:Fputs,:StdOut
        POP     0,0

        PREFIX :

        PREFIX uMove:

bns     IS      $0          //num beans to choose from hp
hp      IS      $1          //heap to choose
sz      IS      $3          //input size
byt     IS      $4          //current byte
num     IS      $5          //current num
j       IS      $6          //Addr(in+j) = next byte
in      IS      $7          //in = :inAd
tmp     IS      $8
tmp2    IS      $9

base    IS      10

:uMove  LDA     $255,:inArg     //get user input
        TRAP    0,:Fgets,:StdIn

        SUB     sz,$255,1         //size of input
        LDA     in,:inAd
        SET     j,0
        SET     num,0
        SET     hp,0
        SET     bns,0
        JMP     0F

1H      SUB     sz,sz,1
        LDB     byt,in,j        //get byte of input
        ADD     j,j,1
        CMP     tmp,byt,' '     //make sure not a space
        CSZ     tmp2,tmp,bns    //check if space and beans already set
        BP      tmp2,7F         //if so, we're done
        CSZ     hp,tmp,num      //if space, set hp if num seen
        CSZ     num,tmp,0       //reset num if space
        BZ      tmp,0F

        CMP     tmp,byt,'0'-1
        CMP     tmp2,byt,'9'+1
        ADD     tmp,tmp,tmp2        //make sure decimal digit
        BNZ     tmp,8F
        SUB     byt,byt,'0'     //byt = decimal value of ASCII char byt
        
        MUL     num,num,10      //update num
        ADD     num,num,byt

0H      PBP     sz,1B

//Done
7H      SET     bns,num
        POP     2,0

//Error
8H      SET     hp,0
        POP     2,0
        PREFIX :

        PREFIX done:
//Checks if game is over

next    IS      $0
count   IS      $1

:done   SET     :hpt,:heaph     //set up to pass through heap list
        SET     count,:hpct
        JMP     1F

0H      PBP     next,2F         //if next>0, not empty
        SUB     count,count,1   //while count != 0
        ADD     :hpt,:hpt,8     //next heap
1H      LDO     next,:hpt       //get next heap
        PBP     count,0B
//empty, return 0
        SET     $0,0
        POP     1,0

//not empty, return 1
2H      SET     $0,1
        POP     1,0

        PREFIX :

///////////////////////////////////////////////////////////////////////
//User turn
heap    IS      $0          //the heap the user chooses
beans   IS      $1          //number of beans removed
tmp     IS      $2
tmp2    IS      $3
off     IS      $4          //address offset

1H      GETA    $255,invalm
        TRAP    0,Fputs,StdOut
        JMP     2F
0H      GO      usr,cpt,0
user    SET     heap,0
        SET     beans,0
2H      PUSHJ   0,Disp
        LDA     $255,pick       //instructions to user
        TRAP    0,Fputs,StdOut
        //Get move, heap in $0, beans in $1
        PUSHJ   0,uMove

        BZ      beans,1B
        BZ      heap,1B
        CMP     tmp,hpct,heap    //user heap entry valid?
        BN      tmp,1B
        SUB     tmp,heap,1
        SL      off,tmp,3        //off = beans*8
        LDO     tmp,heaph,off      //get number of beans in heap
        CMP     tmp2,beans,tmp      //user bean entry valid?
        BP      tmp2,1B
        SUB     tmp,tmp,beans       //subtract beans
        STO     tmp,heaph,off       // store new number       

        PUSHJ   0,done
        PBP     $0,0B           //not done, loop

        GETA    $255,gdj        //done, congratulations
        TRAP    0,Fputs,StdOut
        GO      $0,mn,0         //return to main

invalm  BYTE    "You selected an invalid move, please try again!",#a,0
        LOC     (@+3)&-4
gdj     BYTE    "Congratulations!  You have won the game of Nim!",#a,0

///////////////////////////////////////////////////////////////////////
//Computer turn

//share some registers with user turn, mostly just the temps
nimSum  IS      $5
next    IS      $6              //next value
count   IS      $7              //index


9H      GO      cpt,usr,0
cmptr   GETA    $255,cmsg       //mesage
        TRAP    0,Fputs,StdOut

        SET     hpt,heaph           //set to make pass through heap
        SET     count,hpct
        SET     nimSum,0
        JMP     0F

        //Calculate nimSum
1H      SUB     count,count,1       //for each heap
        LDO     next,hpt            //get beans in heap
        ADD     hpt,hpt,8           //go down heap list
        XOR     nimSum,nimSum,next  //update nimSum
0H      PBP     count,1B

        SET     hpt,heaph           //reset to make new pass  
        SET     count,hpct
        BZ      nimSum,7F           //nimSum <> 0, make arbitrary move
        JMP     3F

        //Find appropriate move
2H      SUB     count,count,1
        LDO     next,hpt
        XOR     tmp,nimSum,next     //tmp = (beans in heap) XOR nimSum
        CMP     tmp2,next,tmp       //tmp2 = (beans in heap) > tmp?
        BNN     tmp2,4F             
        ADD     hpt,hpt,8           //if no, loop
3H      PBP     count,2B

4H      STO     tmp,hpt             //(beans in heap) = nimSum XOR BIH
        SUB     lstmv,hpct,count
        SUB     lstct,next,tmp
        JMP     8F

        //Not in winning position, make arbitrary move
5H      SUB     count,count,1
        LDO     next,hpt            //Get bean number
        BNP     next,6F             //if bean number > 0   
        SUB     next,next,1         //subtract one
        STO     next,hpt            //update heap
        SUB     lstmv,hpct,count
        SET     lstct,1
        JMP     8F                  //break
6H      ADD     hpt,hpt,8
7H      PBP     count,5B

8H      PUSHJ   0,done
        PBP     $0,9B           //not done, loop

        GETA    $255,suckr        //done, gloat
        TRAP    0,Fputs,StdOut
        GO      $0,mn,0         //return to main

cmsg    BYTE    "Computer making move...",#a,0
        LOC     (@+3)&-4
suckr   BYTE    "You have lost!  Buwahahaha, now I will never return  "
        BYTE    "control back to the user!  rW is mine!",#a,0
