% btree.mms
%   Creates a binary tree containing ASCII chars
%   Takes input from user and reprints in ASCII order
%   Author: Nicholas Otto, mmix@nicholasotto.com
%   Date:   11/21/2012

inputSize   IS  10000       %Arbitrary number, 10000 character is alot
Loff        IS  8           %Offset to left pointer, 8 bytes
Roff        IS  16          %Offset to right pointer
Nchk        IS  24          %For convenience, nodes are divisible by 24
inSz        IS  $1

        LOC     Data_Segment
inAd    GREG    @
in      LOC     @+inputSize
        GREG    @       %serves temp purpose being close to prmt too
Prompt  BYTE    "Please type in a string",#a,0
Mesg    BYTE    "The ASCII order of the characters entered is:",#a,0
tail    GREG    @
inArg   OCTA    in          %arguments for Fgets
        OCTA    inputSize
        (@+23)&-24
head    GREG    @       %Start memory block for nodes, div by 24   



        LOC     #100
Main    LDA     $255,Prompt     % Ask politely for input
        TRAP    0,Fputs,StdOut  
        LDA     $255,inArg      % Get the input
        TRAP    0,Fgets,StdIn
        SUB     inSz,$255,1     % save input size
        LDA     tail,head,Nchk  % tail = first empty mem location in DS
        PUSHJ   0,BldT

        LDA     $255,Mesg       % Tell user what they're getting
        TRAP    0,Fputs,StdOut

        LDA     $1,head         % Prepare argument for print subroutine
        PUSHJ   0,PrnBT         % Call print subroutine
        TRAP    0,Halt,0        % exit


        PREFIX  BldT:
%Subroutine to build binary tree in ASCII order with character bytes
%   input parameter: $0 = number of bytes to insert into tree
%   global parameters:  head    address of tree head
%                       tail    address of first free memory address
%   other:  inAd, address of first byte of input
%
%   Actually builds the tree from back to front, reduces number of 
%       parameters to pass

rem     IS      $0      % remaining characters
ret     IS      $1
temp    IS      $2
cchar   IS      $3     % current char
hd      IS      $4

:BldT   GET     ret,:rJ
1H      SUB     rem,rem,1   % rem--
        LDB     cchar,:inAd,rem
        SET     hd,:head
        PUSHJ   2,:btAdd    %add char to tree
2H      PBP     rem,1B
        PUT     :rJ,ret
        POP     0,0

        PREFIX :


        PREFIX btAdd:
%Subroutine to add element to binary tree
%   recursively searches through the tree until it finds an empty child
%   tree works like you expect from a BT.  note: not balanced
%   input parameter: $0 the char to add to tree
%                    $1 the address of current node to search
%   global parameter:   head    address of tree head
%                       tail    address of first free memory address
%   return value:       none

newch   IS      $0  % the new character to add
node    IS      $1  % address of current node
cchar   IS      $2  %the char stored at the node.
nxtN    IS      $3  % the addr of next node
tmp     IS      $4

:btAdd  LDB     cchar,node      % get char at current node
        PBNZ    cchar,1F        % if occupied, lots more work to do
        STB     newch,node      % otherwise, just add newch and return
        POP     0,0

1H      CMP     tmp,cchar,newch % determine if we should go L or R
        PBN     tmp,2F          %cchar<newchar, go right
        PBP     tmp,3F          %cchar>newchar, go left
        LDA     tmp,node,:Loff  %cchar==newchar, check if Lchild empty
        BZ      tmp,3F          %   if yes, left will become next node

2H      ADDU    tmp,node,:Roff  %get addr of right child
        JMP     4F
3H      ADDU    tmp,node,:Loff %get addr of left child
        
4H      LDO     nxtN,tmp
        PBNZ    nxtN,5F         % if nxtN is a valid addr, skip ahead
        STO     :tail,tmp       % otherwise, put tail addr into child
        SET     nxtN,:tail      % set up for where we're going next
        ADD     :tail,:tail,:Nchk   %update tail addr
        
5H      SET     $2,newch        % set up for recursive call
        GET     $0,:rJ          % get return address
        PUSHJ   1,:btAdd        % call btAdd 
        PUT     :rJ,$0          % prepare return address
        POP     0,0             % return

        PREFIX  :

        PREFIX PrnBT:
%Subroutine to initialize call to recursive print subrouting
%   basically just tacks on a newline character after ascii chars
%   parameters: $0, the address of the head of the tree
%   calls prnT.

ret     IS      $0              % only need to save return addr

:PrnBT  SET     $2,$0           % set up to call prnT
        GET     ret,:rJ         %save return addr
        PUSHJ   1,:prnT         % print characters, passed in head
        PUT     :rJ,ret         % set up to return
newL    BYTE    #a,#0           % print newline for human users
        GETA    $255,newL
        TRAP    0,:Fputs,:StdOut    %print newL
        POP     0,0             % return

        PREFIX :

        PREFIX prnT:
%Subroutine to print out contents of binary tree
%   recursively print out an in-order traversal
%   parameters: $0 the address of current node

node    IS      $0      %addr of current node
ret     IS      $1      % return addr
char    IS      $2      %char at current node
cAdd    IS      $3      % addr of child node

:prnT   LDB     char,node   %get our char
        BNZ     char,1F     % check if char==0, end of subtrees
        POP     0,0         %if it is empty, we are at an empty child
1H      GET     ret,:rJ     % get up return value
        LDO     cAdd,node,:Loff %get addr of left subtree
        PUSHJ   2,:prnT     % print out characters in left subtree
        LDA     $255,node   % prepare to print our char
        TRAP    0,:Fputs,:StdOut    %print our char
        LDO     cAdd,node,:Roff % get addr of right subtree
        PUSHJ   2,:prnT         % print out characters in right subtree
        PUT     :rJ,ret     % set up return addr
        POP     0,0         % return

        PREFIX :

