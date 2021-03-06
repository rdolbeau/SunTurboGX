#!/bin/sh
eeprom fcode-debug\?=true
eeprom nvramrc='" /iommu/sbus/cgsix@2" select-dev
: def r1152x900x66 set-resolution ;

: ics78   0 1 0 a d f f 1 8 4 0 0 5 ;

( for 1920x1080 @ 60, dunno which is best ) 
: ics148  0 0 0 a d f f 1 8 4 3 0 5 ;
: ics148b 0 0 0 a d f f 1 8 6 2 0 7 ;

( for VESA 800x600 @ 72 ) 
: ics50 0 0 0 a c f f 1 8 7 2 1 a ;

: ics154 0 0 0 a d f f 1 9 5 0 1 a ;

: ics170  0 0 0 a d f f 1 9 b 2 1 a ;


: r1920x1080x60 " 148500000,67500,60,88,44,148,1920,4,5,36,1080,COLOR,0OFFSET" ;

: r1920x1080x55 " 135000000,61058,55,20,251,20,1920,6,6,18,1080,COLOR,0OFFSET" ;

: rt260 " 154000000,74038,59,48,32,80,1920,3,6,26,1200,COLOR,0OFFSET" ;

: r1920x1200x57 " 170000000,71308,57,32,400,32,1920,10,10,30,1200,COLOR,0OFFSET" ;
: r1920x1200x58 " 170000000,72525,58,32,360,32,1920,10,10,30,1200,COLOR,0OFFSET" ;
: r1920x1200x59 " 170000000,73784,59,32,320,32,1920,10,10,30,1200,COLOR,0OFFSET" ;
: r1920x1200x60 " 170000000,74955,60,32,284,32,1920,10,10,30,1200,COLOR,0OFFSET" ;

: r1920x1200xxx " 170000000,74955,60,16,200,132,1920,10,10,30,1200,COLOR,0OFFSET" ;
: r1920x1200xxy " 170000000,74955,60,32,200,116,1920,10,10,30,1200,COLOR,0OFFSET" ;
: r1920x1200xxz " 170000000,81730,66,48,32,80,1920,3,6,26,1200,COLOR,0OFFSET" ;
: r1920x1200xyx " 154000000,69120,56,48,180,80,1920,3,6,26,1200,COLOR,0OFFSET" ;
: r1920x1200xyy " 154000000,74038,59,48,80,48,1920,3,6,26,1200,COLOR,0OFFSET" ;

: r713bm " 108000000,63981,60,48,112,248,1280,1,3,38,1024,COLOR,0OFFSET" ;

: r1024x768x75 " 78750000,60022,75,16,96,176,1024,1,3,28,768,COLOR,0OFFSET" ;

: r800x600x72 " 50000000,48076,72,56,120,64,800,37,6,23,600,COLOR,0OFFSET" ;

: setup-oscillator-alt
  ?alt-map
dup 2d0fa50 = if
 ics47
else
 dup 2faf080 = if
  ics50
 else
  dup 337f980 = if
   ics54
  else
   dup 3d27848 = if
    ics64
   else
    dup 46cf710 = if
     ics74
    else
     dup 4b1a130 = if
      ics78
     else
      dup 4d3f640 = if
       ics81
      else
       dup 50775d8 = if
        ics84
       else
        dup 5a1f4a0 = if
         ics94
        else
         dup 66ff300 = if
          ics108
         else
          dup 6f94740 = if
           ics117
          else
           dup 80befc0 = if
            ics135
           else
            dup 8d9ee20 = if
             ics148
            else
             dup 92dda80 = if
              ics154
             else
              dup a21fe80 = if
               ics170
              else
               dup b43e940 = if
                ics189
               else
                dup cdfe600 = if
                 ics216
                then
               then
              then
             then
            then
           then
          then
         then
        then
       then
      then
     then
    then
   then
  then
 then
then
  CR .s ." ICS values" CR
  0 d ics-write d 0 do
     i ics-write
  loop
  0 f ics-write 20 0 do
     0 d ics-write
  loop
  94 thc@ 40 or dup 94 thc!
   (is) strap-value 1 ms
  ?alt-unmap
;

: mainosc-alt?
  setup-oscillator-alt 0 confused? !
;

: cal-tim-alt
 cal-tmp !
 vert horz
 my-xdrint " vfreq" my-attribute
 my-xdrint " hfreq" my-attribute
 dup
 my-xdrint " pixfreq" my-attribute
 dup mainosc-alt?
 cycles-per-tran
 818 thc@ fffffff0 and or 818 thc! 0 (is) dblbuf? 94 thc@ 2000000 not and
 display-width display-height * 2 * /vmsize 100000 * <=
 if
    2000000 or 1 (is) dblbuf?
 then
 94 thc! fbc-res bdrev
 my-xdrint " boardrev" my-attribute cal-tmp @
 my-xdrint " montype" my-attribute acceleration
 if
    " cgsix"
 else
    " cgthree+"
 then my-xdrstring " emulation" my-attribute
;

: set-fbconfiguration-alt
 update-string
 parse-line
 cal-tim-alt
;

: set-resolution-alt
 $find if
    execute
 then  lego-init-hc set-fbconfiguration-alt (confused? @ if
    sense-code set-fbconfiguration-alt
 then  lego-sync-reset lego-sync-on my-reset 0 = if
    display-width dup dup xdrint " width" attribute xdrint " linebytes"
    attribute xdrint " awidth" attribute display-height xdrint
    " height" attribute 8 xdrint " depth" attribute /vmsize xdrint
    " vmsize" attribute dblbuf? xdrint " dblbuf" attribute
 then
;

: s191060 r1920x1080x60 set-resolution-alt ;

: s191055 r1920x1080x55 set-resolution-alt ;

: s713bm r713bm set-resolution-alt ;

: s10775 r1024x768x75 set-resolution-alt ;

: s8672 r800x600x72 set-resolution-alt ;

: st260 rt260 set-resolution-alt ;

: s191257 r1920x1200x57 set-resolution-alt ;
: s191258 r1920x1200x58 set-resolution-alt ;
: s191259 r1920x1200x59 set-resolution-alt ;
: s191260 r1920x1200x60 set-resolution-alt ;

: s1912xx r1920x1200xxx set-resolution-alt ;
: s1912xy r1920x1200xxy set-resolution-alt ;
: s1912xz r1920x1200xxz set-resolution-alt ;
: s1912yx r1920x1200xyx set-resolution-alt ;
: s1912yx r1920x1200xyy set-resolution-alt ;

device-end
'
