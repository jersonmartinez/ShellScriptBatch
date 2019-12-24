@echo off
	title Windows Activator
	setlocal EnableExtensions EnableDelayedExpansion
	
	REM Author:  	Jerson Antonio Martínez Moreno
	REM WebPage: 	https://www.fulldevops.es/
	REM Email: 		jersonmartinezsm@gmail.com
	REM LinkedIn: 	https://www.linkedin.com/in/jersonmartinezsm/

		:Arguments (
			call :Init && exit
		)

		:Init (
			call :MenuOptions
			goto :Finished
		)

		:MenuOptions (

			call :PainText 02 "============================================================================================"
			echo.
			echo                   What version of OS Windows 10 do you want to activate?		     
			call :PainText 02 "--------------------------------------------------------------------------------------------"
			echo.
			call :PainText 02 " [1]"
			call :PainText 0e " Home"
			call :PainText 02 "      [2]"
			call :PainText 0e "  Home N"
			call :PainText 02 "      [3]"
			call :PainText 0e "  Home Single"
			call :PainText 02 "          [4]"
			call :PainText 0e "  Home Country"
			echo.
			call :PainText 02 " [5]"
			call :PainText 0e " Pro"
			call :PainText 02 "       [6]"
			call :PainText 0e "  Pro N"
			call :PainText 02 "       [7]"
			call :PainText 0e "  Enterprise"
			call :PainText 02 "           [8]"
			call :PainText 0e "  Enterprise N"
			echo.
			call :PainText 02 " [9]"
			call :PainText 0e " Education"
			call :PainText 02 " [10]"
			call :PainText 0e " Education N"
			call :PainText 02 " [11]"
			call :PainText 0e " Enterprise 2015 LTSB"
			call :PainText 02 " [12]"
			call :PainText 0e " Enterprise 2015 LTSB N"
			echo.
			call :PainText 02 "============================================================================================"
			echo.
			
			set /p SelectOption=Waiting answer: 

			if ["%SelectOption%"]==[""] (
				cls && call :MenuOptions
			) else (

				if %SelectOption% EQU 1 (
					slmgr /ipk TX9XD-98N7V-6WMQ6-BX7FG-H8Q99
				) else if %SelectOption% EQU 2 (
					slmgr /ipk 3KHY7-WNT83-DGQKR-F7HPR-844BM
				) else if %SelectOption% EQU 3 (
					slmgr /ipk 7HNRX-D7KGG-3K4RQ-4WPJ4-YTDFH
				) else if %SelectOption% EQU 4 (
					slmgr /ipk PVMJN-6DFY6-9CCP6-7BKTT-D3WVR
				) else if %SelectOption% EQU 5 (
					slmgr /ipk VK7JG-NPHTM-C97JM-9MPGT-3V66T
				) else if %SelectOption% EQU 6 (
					slmgr /ipk 2F77B-TNFGY-69QQF-B8YKP-D69TJ
				) else if %SelectOption% EQU 7 (
					slmgr /ipk NPPR9-FWDCX-D2C8J-H872K-2YT43
				) else if %SelectOption% EQU 8 (
					slmgr /ipk DPH2V-TTNVB-4X9Q3-TJR4H-KHJW4
				) else if %SelectOption% EQU 9 (
					slmgr /ipk NW6C2-QMPVW-D7KKK-3GKT6-VCFB2
				) else if %SelectOption% EQU 10 (
					slmgr /ipk 2WH4N-8QGBV-H22JP-CT43Q-MDWWJ
				) else if %SelectOption% EQU 11 (
					slmgr /ipk WNMTR-4C88C-JK8YV-HQ7T2-76DF9
				) else if %SelectOption% EQU 12 (
					slmgr /ipk 2F77B-TNFGY-69QQF-B8YKP-D69TJ
				) else (
					cls && call :MenuOptions
				)
				
				echo.
				call :PainText 0e "Entering license "

				call :ActivationStep
			)

			exit /b 0

		)

		:ActivationStep (
			slmgr /skms fulldevops.es
			slmgr /ato

			call :PainText 02 " [Done]"

			exit /b 0
		)

		:PainText (
			for /f "tokens=1,2 delims=#" %%a in ('"prompt #$H#$E# & echo on & for %%b in (1) do rem"') do (
				set "DEL=%%a"
			)

			<nul set /p ".=%DEL%" > "%~2"
			findstr /v /a:%1 /R "^$" "%~2" nul
			del "%~2" > nul 2>&1

			exit /b 0
		)

		:Finished (
			echo.
			call :PainText 02 " -- [Your OS has been activated]"
			echo.
			pause>nul
			exit
		)

	endlocal
exit
