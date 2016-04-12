
uses supergfx, helpmous, help2;

{$I consts.pas}

const
     vergame : string = '1.0';

type
    pole = array[1..3, 1..3] of byte;

var
   mx, my, k : integer;
   p : byte;
   i, j : integer;
   arena : pole;
   xy : integer;
   typ_gry, tura : byte;
   koniec_tury_p1, koniec_tury_p2, koniec_tury_cpu : boolean;
   wygral_p1, wygral_p2 : boolean;
   wyjscie : boolean;
   player1_name, player2_name : string;
   znak : char;
   e : word;
   myszjest : string;

procedure showcursor;
var
   i, j : integer;
begin
     for i:= 1 to 10 do
     for j:= 1 to 10 do
     begin
          if cur[j,i]<>255 then putpixel(j+mx,i+my,cur[i,j])
     end;
end;

procedure regilogo(x, y : integer);
var
   i, j : integer;
begin
     for i:= 1 to 60 do
     for j:= 1 to 60 do
     begin
          if regi_logo[j,i]<>0 then putpixel(j+x,i+y,regi_logo[j,i])
     end;
end;

procedure printfontxy(x, y : integer; kolor : byte; tekst : string);

procedure putfont(x, y : integer; nr : byte);
var
   i, j : integer;
begin
     for i:= 1 to 4 do
     for j:= 1 to 5 do if alfabet[nr][j,i]<>0 then putpixel(i+x,j+y,kolor);
end;

var
   i : byte;

begin
     for i:= 1 to length(tekst) do
     begin
          x:=x+5;
          if tekst[i]<>' ' then putfont(x,y,ord(tekst[i]));
     end;
end;

procedure put_o_x(xx, yy : integer; nr : byte);
var
   i, j : integer;
begin
     if nr=1 then
     begin
     for i:= 1 to 15 do
     for j:= 1 to 15 do
     begin
          if _o[j,i]<>00 then putpixel(j*2+xx,i*2+yy,_o[i,j])
     end;
     end;
     if nr=2 then
     begin
     for i:= 1 to 15 do
     for j:= 1 to 15 do
     begin
          if _x[j,i]<>00 then putpixel(j*2+xx,i*2+yy,_x[i,j])
     end;
     end;
end;

procedure badaj_czy_wygral;
begin
     {player 1}
     if (arena[1,1]=1) and
        (arena[1,2]=1) and
        (arena[1,3]=1) then begin line(45,40,45,110,50); wygral_p1:=true; end;
     if (arena[2,1]=1) and
        (arena[2,2]=1) and
        (arena[2,3]=1) then begin line(75,40,75,110,50); wygral_p1:=true; end;
     if (arena[3,1]=1) and
        (arena[3,2]=1) and
        (arena[3,3]=1) then begin line(105,40,105,110,50); wygral_p1:=true; end;
     if (arena[1,1]=1) and
        (arena[2,1]=1) and
        (arena[3,1]=1) then begin line(40,45,110,45,50); wygral_p1:=true; end;
     if (arena[1,2]=1) and
        (arena[2,2]=1) and
        (arena[3,2]=1) then begin line(40,75,110,75,50); wygral_p1:=true; end;
     if (arena[1,3]=1) and
        (arena[2,3]=1) and
        (arena[3,3]=1) then begin line(40,105,110,105,50); wygral_p1:=true; end;
     if (arena[1,1]=1) and
        (arena[2,2]=1) and
        (arena[3,3]=1) then begin line(40,40,110,110,50); wygral_p1:=true; end;
     if (arena[3,1]=1) and
        (arena[2,2]=1) and
        (arena[1,3]=1) then begin line(110,40,40,110,50); wygral_p1:=true; end;
     {player 2}
     if (arena[1,1]=2) and
        (arena[1,2]=2) and
        (arena[1,3]=2) then begin line(45,40,45,110,50); wygral_p2:=true; end;
     if (arena[2,1]=2) and
        (arena[2,2]=2) and
        (arena[2,3]=2) then begin line(75,40,75,110,50); wygral_p2:=true; end;
     if (arena[3,1]=2) and
        (arena[3,2]=2) and
        (arena[3,3]=2) then begin line(105,40,105,110,50); wygral_p2:=true; end;
     if (arena[1,1]=2) and
        (arena[2,1]=2) and
        (arena[3,1]=2) then begin line(40,45,110,45,50); wygral_p2:=true; end;
     if (arena[1,2]=2) and
        (arena[2,2]=2) and
        (arena[3,2]=2) then begin line(40,75,110,75,50); wygral_p2:=true; end;
     if (arena[1,3]=2) and
        (arena[2,3]=2) and
        (arena[3,3]=2) then begin line(40,105,110,105,50); wygral_p2:=true; end;
     if (arena[1,1]=2) and
        (arena[2,2]=2) and
        (arena[3,3]=2) then begin line(40,40,110,110,50); wygral_p2:=true; end;
     if (arena[3,1]=2) and
        (arena[2,2]=2) and
        (arena[1,3]=2) then begin line(110,40,40,110,50); wygral_p2:=true; end;
end;

procedure rysuj_o_x;
var
   i, j : integer;
begin
     for i:= 1 to 3 do
     for j:= 1 to 3 do
     begin
          put_o_x((i*30)-1,(j*30)-1,arena[i,j]);
          badaj_czy_wygral;
     end;
end;

procedure badaj_czy_remis;

procedure remis;
begin
     outtextxy(80,80,3,3,63,'REMIS',false);
     czekaj(120);
     pokazgrafike2;
     wyjscie:=true;
end;

begin
     for i:= 1 to 3 do
     for j:= 1 to 3 do if (arena[i,j]<>0) and (tura=9) and (not wygral_p1) and (not wygral_p2) then remis;
end;

procedure tura_gracz1;
begin
     koniec_tury_p1:=false;
     tura:=tura+1;
     repeat
           getmousepos(mx,my,k);
           mx:=mx div 2;
           printfontxy(38,20,35,'1     2     3');
           printfontxy(15,42,35,'A');
           printfontxy(15,72,35,'B');
           printfontxy(15,102,35,'C');
           rectangle(30,30,120,120,64);
           line(60,30,60,120,64);
           line(30,60,120,60,64);
           line(90,30,90,120,64);
           line(30,90,120,90,64);
           printfontxy(250,10,35,player1_name);
           printfontxy(250,20,15,player2_name);
           rectangle(14,169,31,189,35);
           printfontxy(10,170,35,numstr(arena[1,1])+''+numstr(arena[2,1])+''+numstr(arena[3,1]));
           printfontxy(10,176,35,numstr(arena[1,2])+''+numstr(arena[2,2])+''+numstr(arena[3,2]));
           printfontxy(10,182,35,numstr(arena[1,3])+''+numstr(arena[2,3])+''+numstr(arena[3,3]));
           rysuj_o_x;
           if mousein(mx,my,30,30,119,119) and (k=1) then
           begin
                i:=(mx div 30) * 30;
                j:=(my div 30) * 30;
                put_o_x(i-1,j-1,1);
                j:=j div 30;
                i:=i div 30;
                if arena[i,j]=0 then begin arena[i,j]:=1; koniec_tury_p1:=true; end;
                czekaj(100);
           end;
           rectangle(248,140,307,195,63);
           regilogo(250,138);
           grind(248,140,307,195);
           showcursor;
           fader;
           pokazgrafike2;
     until koniec_tury_p1 or wyjscie;
     koniec_tury_p1:=false;
end;

procedure tura_gracz2;
begin
     koniec_tury_p2:=false;
     tura:=tura+1;
     repeat
           getmousepos(mx,my,k);
           mx:=mx div 2;
           printfontxy(38,20,35,'1     2     3');
           printfontxy(15,42,35,'A');
           printfontxy(15,72,35,'B');
           printfontxy(15,102,35,'C');
           rectangle(30,30,120,120,64);
           line(60,30,60,120,64);
           line(30,60,120,60,64);
           line(90,30,90,120,64);
           line(30,90,120,90,64);
           printfontxy(250,10,15,player1_name);
           printfontxy(250,20,35,player2_name);
           rectangle(14,169,31,189,35);
           printfontxy(10,170,35,numstr(arena[1,1])+''+numstr(arena[2,1])+''+numstr(arena[3,1]));
           printfontxy(10,176,35,numstr(arena[1,2])+''+numstr(arena[2,2])+''+numstr(arena[3,2]));
           printfontxy(10,182,35,numstr(arena[1,3])+''+numstr(arena[2,3])+''+numstr(arena[3,3]));
           rysuj_o_x;
           if mousein(mx,my,30,30,119,119) and (k=1) then
           begin
                i:=(mx div 30) * 30;
                j:=(my div 30) * 30;
                put_o_x(i-1,j-1,2);
                j:=j div 30;
                i:=i div 30;
                if arena[i,j]=0 then begin arena[i,j]:=2; koniec_tury_p2:=true; end;
                czekaj(100);
           end;
           rectangle(248,140,307,195,63);
           regilogo(250,138);
           grind(248,140,307,195);
           showcursor;
           fader;
           pokazgrafike2;
     until koniec_tury_p2 or wyjscie;
     koniec_tury_p2:=false;
end;

procedure tura_komputer;
var
   los : byte;
begin
     koniec_tury_cpu:=false;
     los:=0;
     randomize;
     tura:=tura+1;
     repeat
           printfontxy(38,20,35,'1     2     3');
           printfontxy(15,42,35,'A');
           printfontxy(15,72,35,'B');
           printfontxy(15,102,35,'C');
           rectangle(30,30,120,120,64);
           line(60,30,60,120,64);
           line(30,60,120,60,64);
           line(90,30,90,120,64);
           line(30,90,120,90,64);
           printfontxy(250,10,15,player1_name);
           printfontxy(250,20,35,player2_name);
           rectangle(14,169,31,189,35);
           printfontxy(10,170,35,numstr(arena[1,1])+''+numstr(arena[2,1])+''+numstr(arena[3,1]));
           printfontxy(10,176,35,numstr(arena[1,2])+''+numstr(arena[2,2])+''+numstr(arena[3,2]));
           printfontxy(10,182,35,numstr(arena[1,3])+''+numstr(arena[2,3])+''+numstr(arena[3,3]));
           repeat
                 i:=random(3)+1;
                 j:=random(3)+1;
                 if not wygral_p1 then
                 begin
                      if arena[i,j]=0 then begin arena[i,j]:=2; koniec_tury_cpu:=true; end;
                 end else
           until koniec_tury_cpu or (arena[i,j]<>0);
           rysuj_o_x;
           rectangle(248,140,307,195,63);
           regilogo(250,138);
           grind(248,140,307,195);
           showcursor;
           fader;
           pokazgrafike2;
     until koniec_tury_cpu or wyjscie;
     koniec_tury_cpu:=false;
end;

procedure wstep;
begin
e:=0;
repeat
      e:=e+1;
      outtextxygrind(70,80,4,6,60,'REGi',false);
      blur2(5,5,315,195);
      czekaj(20);
      pokazgrafike2;
until e=50;
e:=0;
repeat
      e:=e+1;
      outtextxygrind(10,80,3,6,60,'przedstawia',false);
      blur2(5,5,315,195);
      fader;
      czekaj(20);
      pokazgrafike2;
until e=50;
e:=0;
repeat
      e:=e+1;
      outtextxygrind(5,60,4,10,60,'KiK v1.0',false);
      blur2(5,5,315,195);
      fader;
      czekaj(20);
      pokazgrafike2;
until e=50;
end;

begin
     writeln;
     writeln('K‡ùKO I KRZYΩYK v'+vergame+' by REGi');
     if initmouse then myszjest:='YES' else begin myszjest:='NO'; end;
     writeln('MOUSE INSTALED: '+myszjest);
     writeln('PRES ENTER KEY...');
     enterkey;
     if myszjest='NO' then halt;
     initgfx13h;
     for p:= 0 to 63 do setcolor(p,p,p shr 4,0);
     if (paramstr(1)<>'/w') and (paramstr(1)<>'/W') then wstep;
     setmousepos(320,100);
     mousewindow(2,2,615,187);
     pokazgrafike2;
     wygral_p1:=false;
     wygral_p2:=false;
     repeat
           outtextxygrind(70,5,4,3,64,'MENU',false);
           outtextxygrind(82,55,3,4,60,'START',false);
           outtextxygrind(80,95,3,4,60,'AUTOR',false);
           outtextxygrind(95,135,3,4,60,'EXIT',false);
           getmousepos(mx,my,k);
           mx:=mx div 2;
           rectangle(248,140,307,195,63);
           regilogo(250,138);
           grind(248,140,308,195);
           showcursor;
           fader;
           pokazgrafike2;
           if mousein(mx,my,101,55,215,84) then begin outtextxygrind(82,55,3,4,10,'START',false); end;
           if mousein(mx,my,99,95,217,124) then begin outtextxygrind(80,95,3,4,10,'AUTOR',false); end;
           if mousein(mx,my,117,135,205,164) then begin outtextxygrind(95,135,3,4,10,'EXIT',false); end;
           {start}
           if mousein(mx,my,101,55,215,84) and (k=1) then
           begin
                outtextxygrind(82,55,3,4,60,'START',false);
                e:=0;
                repeat
                      fader;
                      inc(e);
                      czekaj(20);
                      pokazgrafike2;
                until e=10;
                repeat
                      outtextxygrind(95,60,2,3,60,'1 GRACZ',false);
                      outtextxygrind(90,110,2,3,60,'2 GRACZY',false);
                      outtextxygrind(5,5,1,1,60,'BACK',false);
                      if mousein(mx,my,5,5,40,13) then outtextxygrind(5,5,1,1,20,'BACK',false);
                      if mousein(mx,my,105,60,215,82) then outtextxygrind(95,60,2,3,10,'1 GRACZ',false);
                      if mousein(mx,my,100,110,225,132) then outtextxygrind(90,110,2,3,10,'2 GRACZY',false);
                      pokazgrafike2;
                      getmousepos(mx,my,k);
                      mx:=mx div 2;
                      rectangle(248,140,307,195,63);
                      regilogo(250,138);
                      grind(248,140,308,195);
                      showcursor;
                      fader;
                      pokazgrafike2;
                      if mousein(mx,my,105,60,215,82) and (k=1) then
                      begin
                           koniec_tury_p1:=false;
                           koniec_tury_p2:=false;
                           koniec_tury_cpu:=false;
                           wygral_p1:=false;
                           wygral_p2:=false;
                           wyjscie:=false;
                           player1_name:='GRACZ 1';
                           player2_name:='GRACZ 2';
                           typ_gry:=2;
                           tura:=0;
                           for i:= 1 to 3 do
                           for j:= 1 to 3 do arena[i,j]:=0;
                           repeat
                                 tura_gracz1;
                                 badaj_czy_wygral;
                                 badaj_czy_remis;
                                 if wygral_p1 then
                                 begin
                                      outtextxy(70,70,3,3,63,'WYGRAL',false);
                                      outtextxy(70,70,3,3,63,'     -',false);
                                      outtextxy(60,95,3,3,63,'GRACZ 1',false);
                                      pokazgrafike2;
                                      czekaj(550);
                                      wyjscie:=true;
                                 end;
                                 if typ_gry=1 then tura_gracz2;
                                 if typ_gry=2 then tura_komputer;
                                 if wygral_p2 then
                                 begin
                                      if typ_gry=1 then
                                      begin
                                           outtextxy(70,70,3,3,63,'WYGRAL',false);
                                           outtextxy(70,70,3,3,63,'     -',false);
                                           outtextxy(60,95,3,3,63,'GRACZ 2',false);
                                           pokazgrafike2;
                                           czekaj(550);
                                           wyjscie:=true;
                                      end;
                                      if typ_gry=2 then
                                      begin
                                           outtextxy(70,70,3,3,63,'WYGRAL',false);
                                           outtextxy(70,70,3,3,63,'     -',false);
                                           outtextxy(50,95,3,3,63,'KOMPUTER',false);
                                           pokazgrafike2;
                                           czekaj(550);
                                           wyjscie:=true;
                                      end;
                                 end;
                                 badaj_czy_wygral;
                                 badaj_czy_remis;
                           until wyjscie;
                      end;
                      if mousein(mx,my,100,110,225,132) and (k=1) then
                      begin
                           koniec_tury_p1:=false;
                           koniec_tury_p2:=false;
                           koniec_tury_cpu:=false;
                           wygral_p1:=false;
                           wygral_p2:=false;
                           wyjscie:=false;
                           player1_name:='GRACZ 1';
                           player2_name:='GRACZ 2';
                           typ_gry:=1;
                           tura:=0;
                           for i:= 1 to 3 do
                           for j:= 1 to 3 do arena[i,j]:=0;
                           repeat
                                 tura_gracz1;
                                 badaj_czy_wygral;
                                 badaj_czy_remis;
                                 if wygral_p1 then
                                 begin
                                      outtextxy(70,70,3,3,63,'WYGRAL',false);
                                      outtextxy(70,70,3,3,63,'     -',false);
                                      outtextxy(60,95,3,3,63,'GRACZ 1',false);
                                      pokazgrafike2;
                                      czekaj(550);
                                      wyjscie:=true;
                                 end;
                                 if typ_gry=1 then tura_gracz2;
                                 if typ_gry=2 then tura_komputer;
                                 if wygral_p2 then
                                 begin
                                      if typ_gry=1 then
                                      begin
                                           outtextxy(70,70,3,3,63,'WYGRAL',false);
                                           outtextxy(70,70,3,3,63,'     -',false);
                                           outtextxy(60,95,3,3,63,'GRACZ 2',false);
                                           pokazgrafike2;
                                           czekaj(550);
                                           wyjscie:=true;
                                      end;
                                      if typ_gry=2 then
                                      begin
                                           outtextxy(70,70,3,3,63,'WYGRAL',false);
                                           outtextxy(70,70,3,3,63,'     -',false);
                                           outtextxy(50,95,3,3,63,'KOMPUTER',false);
                                           pokazgrafike2;
                                           czekaj(550);
                                           wyjscie:=true;
                                      end;
                                 end;
                                 badaj_czy_wygral;
                                 badaj_czy_remis;
                           until wyjscie;
                      end;
                until mousein(mx,my,5,5,40,13) and (k=1);
           end;
           {autor}
           if mousein(mx,my,99,95,217,124) and (k=1) then
           begin
                repeat
                      outtextxygrind(50,5,4,3,64,'AUTOR',false);
                      outtextxygrind(25,40,2,2,60,'MICHAL RYGIELSKI',false);
                      outtextxygrind(25,40,2,2,60,'     -',false);
                      outtextxygrind(2,65,2,2,60,'http://rpage.prv.pl',false);
                      outtextxygrind(80,85,1,2,60,'regi007@poczta.onet.pl',false);
                      outtextxygrind(100,135,4,4,64,'OK',false);
                      if mousein(mx,my,129,135,190,165) then outtextxygrind(100,135,4,4,10,'OK',false);
                      getmousepos(mx,my,k);
                      mx:=mx div 2;
                      rectangle(248,140,307,195,63);
                      regilogo(250,138);
                      grind(248,140,308,195);
                      showcursor;
                      fader;
                      pokazgrafike2;
                until mousein(mx,my,129,135,190,165) and (k=1);
                k:=2;
                czekaj(150);
                pokazgrafike2;
           end;
           {exit}
           if mousein(mx,my,117,135,205,164) and (k=1) then
           begin
                outtextxygrind(95,135,3,4,60,'EXIT',false);
                e:=0;
                repeat
                      grind(5,5,318,198);
                      inc(e);
                      czekaj(20);
                      pokazgrafike2;
                until e=10;
                closegfx13h;
                settextmode(mode2);
                piszxy(30,11,11,'K‡ùKO I KRZYΩYK '+vergame);
                piszxy(30,12,09,'by MICHAù RYGIELSKI');
                piszxy(30,13,15,'     REGi 2001');
                piszxy(30,14,08,'   FREEWARE GAME');
                piszxy(30,15,07,'http://rpage.prv.pl');
                ramka(28,10,50,16,1,1);
                halt;
           end;
     until true=false;
     closegfx13h;
end.