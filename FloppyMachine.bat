@echo off
echo.> C:\xampp\htdocs\FloppyMachine\status.html
echo.> C:\xampp\htdocs\FloppyMachine\result.html
echo.> C:\xampp\htdocs\FloppyMachine\log.csv
if exist C:\xampp\htdocs\FloppyMachine\wake.txt (
    del C:\xampp\htdocs\FloppyMachine\wake.txt
)
if exist C:\xampp\htdocs\FloppyMachine\stop.txt (
    del C:\xampp\htdocs\FloppyMachine\stop.txt
)
:loop
echo PRONTO
echo Stato: PRONTO > C:\xampp\htdocs\FloppyMachine\status.html
echo %DATE% - %TIME%;Pronto; >> C:\xampp\htdocs\FloppyMachine\log.csv
ping -n 10 127.0.0.1 >nul
set /a try=0
set /a sleep=0
call :beep 1

goto check

:check
if exist C:\xampp\htdocs\FloppyMachine\stop.txt (
    del C:\xampp\htdocs\FloppyMachine\stop.txt
    goto stop
)
if %try% geq 10 (
    goto sleep
)
echo INSERIRE FLOPPY - TENTATIVO %try%
echo Stato: INSERIRE FLOPPY > C:\xampp\htdocs\FloppyMachine\status.html
echo %DATE% - %TIME%;Inserire Floppy - Tentativo %try%; >> C:\xampp\htdocs\FloppyMachine\log.csv

dir A:\ >nul 2>&1
if errorlevel 1 (
	ping -n 5 127.0.0.1 >nul
	set /a try=%try%+1
	goto check
)
goto format

:format
echo FLOPPY INSERITO
echo Stato: FLOPPY INSERITO > C:\xampp\htdocs\FloppyMachine\status.html
echo %DATE% - %TIME%;Floppy Inserito; >> C:\xampp\htdocs\FloppyMachine\log.csv
call :beep 2

ping -n 5 127.0.0.1 >nul

echo INIZIO FORMATTAZIONE
echo Stato: FORMATTANDO > C:\xampp\htdocs\FloppyMachine\status.html
echo %DATE% - %TIME%;Inizio Formattazione; >> C:\xampp\htdocs\FloppyMachine\log.csv
echo Y|format A: /FS:FAT > result.html
if errorlevel 1 (
    echo ERRORE DI FORMATTAZIONE
    echo Stato: ERRORE > C:\xampp\htdocs\FloppyMachine\status.html
    echo %DATE% - %TIME%;Erorre; >> C:\xampp\htdocs\FloppyMachine\log.csv
    call :beep 4
    ping -n 30 127.0.0.1 >nul
)

echo FORMATTAZIONE COMPLETATA
echo Stato: COMPLETATO > C:\xampp\htdocs\FloppyMachine\status.html
echo %DATE% - %TIME%;Completato; >> C:\xampp\htdocs\FloppyMachine\log.csv
call :beep 2
ping -n 5 127.0.0.1 >nul

goto loop

:sleep
echo MODALITA' RIPOSO
echo Stato: RIPOSO > C:\xampp\htdocs\FloppyMachine\status.html
echo %DATE% - %TIME%;Riposando per 1 ora; >> C:\xampp\htdocs\FloppyMachine\log.csv

:waitloop
if %sleep% geq 180 (
    set /a sleep=0
    goto loop
)
if exist C:\xampp\htdocs\FloppyMachine\wake.txt (
    del C:\xampp\htdocs\FloppyMachine\wake.txt
    goto loop
)
ping -n 20 127.0.0.1 >nul
set /a sleep=%sleep%+1
goto waitloop

:stop
echo ARRESTO IN CORSO
echo Stato: ARRESTO > C:\xampp\htdocs\FloppyMachine\status.html
echo %DATE% - %TIME%;Arresto; >> C:\xampp\htdocs\FloppyMachine\log.csv
echo GRAZIE PER AVER USATO FLOPPY MACHINE!
call :beep 5

ping -n 10 127.0.0.1 >nul

echo.> C:\xampp\htdocs\FloppyMachine\status.html
echo.> C:\xampp\htdocs\FloppyMachine\result.html
echo.> C:\xampp\htdocs\FloppyMachine\log.csv
if exist C:\xampp\htdocs\FloppyMachine\wake.txt (
    del C:\xampp\htdocs\FloppyMachine\wake.txt
)
if exist C:\xampp\htdocs\FloppyMachine\stop.txt (
    del C:\xampp\htdocs\FloppyMachine\stop.txt
)
exit

:beep
set /a _n=%~1
if "%_n%"=="" set /a _n=1
:beep_loop
if %_n% LEQ 0 goto :eof
<nul set /p "=."
ping -n 2 127.0.0.1 >nul
set /a _n-=1
goto beep_loop