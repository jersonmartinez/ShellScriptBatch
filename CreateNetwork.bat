@echo off
	title Create Network
	setlocal EnableExtensions EnableDelayedExpansion

		:Init (
			call :getUserNetwork && cls
			echo Network Name: %network_name%
			
			call :getPassNetwork "%network_name%"
			echo Network Key: %network_pass%

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

			if %contador% LSS 8 (
				echo Enter a password with at least 8 digits: %contador%
				timeout /t 10
				cls && call :getPassNetwork "%~1"
			)

			exit /b 0
		)

		:getSizeString (
			set cadena=%~1
			
			set /a "contador=0"
			call :getSizeStringLoop

			exit /b 0
		)

		:getSizeStringLoop (
			set "cadena=%cadena:~1%"
			set /a "contador+=1"
			
			if defined cadena (
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
			netsh wlan set hostednetwork mode=allow ssid="%~1" key="%~2"
		)

		:startNetwork (
			netsh wlan start hostednetwork > nul
		)

		:stopNetwork (
			netsh wlan stop hostednetwork > nul
		)
		
		:Finished
			pause>nul
	endlocal
exit