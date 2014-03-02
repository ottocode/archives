% Author: Nicholas Otto 23/Oct/2012
% Prints our "That's all, folks!\n" character by character.
%   Uses TRAP 0,Fwrite,StdOut to do printing
% Grabs an octabyte of characters, prints those 8, then loops.

Val         IS      $0
Str_Loc     IS      $1
Str_Offset  IS      $2
Mem     IS      $3
Posi    IS      $5
Bloc    IS      $9
BlocLoop    IS      $8

        LOC         Data_Segment
        GREG        @
Arg     OCTA        0       %will contain address of char
        OCTA        1       %print 1 byte at a time
char    OCTA        0       %will be address of char


        LOC         #100
Main    GETA        Str_Loc,String            % Store String in Str_Loc
        SET         Str_Offset,0              % Initially grab first
                                              %   eight chars
        LDA         Mem,char                  % Get char Address and 
        STO         Mem,Arg                   %   store that address 
                                              %   in args

% OUTER LOOP
%   Grab 8 bytes at a time from Str_Loc
%   Once those are printed, loop back to
%   1H for more!
1H      LDO         Bloc,Str_Loc,Str_Offset     % Grab bytes
        ADD         Str_Offset,Str_Offset,8     % Next time get
                                                %  the next bloc
        SET         Posi,56                     % Shift offset
        SET         BlocLoop,8                  % Initialize loop

% INNER LOOP
%   For the 8 bytes grabbed in the outer loop:
%       Isolate byte i with shift instructions
%       If byte is null char, goto exit
%       Else, store byte into char
%       Print out the byte
%   i++
2H      SRU         Val,Bloc,Posi           %Get char Value by shifts
        SLU         Val,Val,56
        BZ          Val,3F                  %If Val == nullchar, exit

        SUBU        Posi,Posi,8             %Next time get the next Val
        
        STOU        Val,char                %Store Val into char
        LDA         $255,Arg                % Prep to print char
        TRAP        0,Fwrite,StdOut         % Print it
        
        SUB         BlocLoop,BlocLoop,1     % "i++" (but backwards)
        BZ          BlocLoop,1B             % if printed 8, goto outer
        PBP         BlocLoop,2B             % otherwise, stay in inner

3H      TRAP        0,Halt,0                %Exit
        LOC         (@+7)&-8                %align string to 8 multiple
String  BYTE        "That's all, folks!",#a,0
