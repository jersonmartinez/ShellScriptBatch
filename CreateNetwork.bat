@echo off
	title Create Network
	setlocal EnableExtensions EnableDelayedExpansion

		:Init (
			call :getUserNetwork && cls
			echo Network Name: %network_name%
			
			call :getPassNetwork "%network_name%"
			echo Network Key: %network_pass%

			call :stopNetwork
			call :setNetwork "%network_name%" "%network_pass%"
			call :startNetwork

			goto :Finished
		)

		:getUserNetwork (
			set /p network_name=Network Name: 

			if ["%network_name%"]==[""] (
				cls && call :getUserNetwork
			)

			exit /b 0
		)

		:getPassNetwork (
			echo Nombre de red: %~1
			call :getMaskingPassword user_password "Network Key: "
			
			if ["%network_pass%"]==[""] (
				cls && call :getPassNetwork "%~1"
			) else (
				call :getSizeString "%network_pass%"				
			)

			if %CountString% LSS 8 (
				echo Enter a password with at least 8 digits: %CountString%
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
			for /F "tokens=1,2 delims=#" %%a in ('"prompt #$H#$E# & echo on & for %%b in (1) do rem"') do (set "DEL=%%a")
			<nul set /p ".=%DEL%" > "%~2"
			findstr /v /a:%1 /R "^$" "%~2" nul
			del "%~2" > nul 2>&1

			exit /b 0
		)

		:Finished
			pause>nul
	endlocal
exit