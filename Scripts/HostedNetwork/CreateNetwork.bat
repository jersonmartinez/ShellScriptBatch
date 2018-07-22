@echo off
	title Create Network
	setlocal EnableExtensions EnableDelayedExpansion

		:Arguments (

			if /i [%1]==[/?] ( 
				goto :ModeUse 
			)

			if /i [%1]==[-start] ( 
				call :startNetwork
				exit 
			)

			if /i [%1]==[-stop] ( 
				call :stopNetwork
				exit 
			)

			if not defined [%1] goto :Init

			call :stopNetwork
			call :setNetwork %1 %2
			call :startNetwork

			exit
		)

		:Init (
			call :getUserNetwork && cls			
			call :getPassNetwork "%network_name%"

			call :stopNetwork
			call :setNetwork "%network_name%" "%network_pass%"
			call :startNetwork

			echo.
			echo 1) New Network, 2) Stop Network and Close
			goto :Finished
		)

		::::::::::::::::::::::::::::
		::      Network Data      ::
		::::::::::::::::::::::::::::
		:getUserNetwork (
			set /p network_name=Network Name: 

			if ["%network_name%"]==[""] (
				cls && call :getUserNetwork
			)

			exit /b 0
		)

		:getPassNetwork (
			call :PainText 0F "Network Name, "
			call :PainText 02 " %~1"
			echo.

			call :getMaskingPassword user_password "Network Key: "
			
			if ["%network_pass%"]==[""] (
				cls && call :getPassNetwork "%~1"
			) else (
				call :getSizeString "%network_pass%"				
			)

			if %CountString% LSS 8 (
				call :PainText 04 "Enter a password with at least 8 digits"
				timeout /t 10
				cls && call :getPassNetwork "%~1"
			)

			exit /b 0
		)

		:::::::::::::::::::::::::::::
		::       Size String       ::
		:::::::::::::::::::::::::::::
		:getSizeString (
			set String=%~1
			set /a "CountString=0"

			call :getSizeStringLoop

			exit /b 0
		)

		:getSizeStringLoop (
			set "String=%String:~1%"
			set /a "CountString+=1"
			
			if defined String (
				goto :getSizeStringLoop
			)
			
			exit /b 0
		)

		::::::::::::::::::::::::::::::
		::     Masking Password     ::
		::::::::::::::::::::::::::::::
		:getMaskingPassword (
			set "network_pass="

			for /f %%a in ('"prompt;$H&for %%b in (0) do rem"') do (
				set "BS=%%a"
			)

			set /p "=%~2" < nul 
		)

		:getMaskingKeyLoop (
			set "key="

			for /f "delims=" %%a in ('xcopy /l /w "%~f0" "%~f0" 2^>nul') do (
				if not defined key (
					set "key=%%a"
				)
			)

			set "key=%key:~-1%"

			if defined key (
				if "%key%"=="%BS%" (
					if defined network_pass (
						set "network_pass=%network_pass:~0,-1%"
						set /P "=!BS! !BS!" < nul
					)
				) else (
					set "network_pass=%network_pass%%key%"
					set /p "=*" < nul
				)

				goto :getMaskingKeyLoop
			)
			
			echo/
			set "%~1=%network_pass%"
			goto :eof
		)

		:::::::::::::::::::::::::::::::
		::   Create Hosted Network   ::
		:::::::::::::::::::::::::::::::
		:setNetwork (
			call :PainText 09 "Hosted Network Setting"
			netsh wlan set hostednetwork mode=allow ssid="%~1" key="%~2" > nul
			call :PainText 02 " [Done]"
			echo.

			exit /b 0
		)

		:startNetwork (
			call :PainText 02 "Network Starting"
			netsh wlan start hostednetwork > nul
			call :PainText 02 "       [Done]"
			echo.
			
			exit /b 0
		)

		:stopNetwork (
			call :PainText 0e "Hosted Network Stoping"
			netsh wlan stop hostednetwork > nul
			call :PainText 02 " [Done]"
			echo.

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

		:ModeUse (
			echo Mode Use to Create Network correctly
			echo Command: [CreateNetwork] 
			echo Arguments: 
			echo -- First parameter: [-stop (Network Stop)], [Network User] 
			echo -- Second Parameter: [Network Key]
			echo.
			echo Example: 
			echo -- CreateNetwork "My first network" "My secure key"
			echo.
			echo Author: 
			call :PainText 0e "-- Jerson A. Martinez M. (Side Master - Core Stack)"
			echo.
			exit
		)

		:Finished (
			set /p selection=Waiting answer: 

			if [%selection%]==[] (
				goto :Finished
			)

			if %selection% EQU 1 (
				goto :Init
			)

			if %selection% EQU 2 (
				call :stopNetwork
			)
			exit
		)

	endlocal
exit