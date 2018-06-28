@echo off
	title Create Network
	setlocal EnableExtensions EnableDelayedExpansion

		:Init (
			call :getUserNetwork && cls
			echo Nombre de red: %network_name%
			
			call :getPassNetwork "%network_name%"
			echo Clave de red: %network_pass%

			goto :Finished
		)

		:getUserNetwork (
			set /p network_name=Nombre de red: 

			if ["%network_name%"]==[""] (
				cls && call :getUserNetwork
			)

			exit /b 0
		)

		:getPassNetwork (
			echo Nombre de red: %~1
			call :getMaskingPassword user_password "Clave de red: "
			
			if ["%network_pass%"]==[""] (
				cls && call :getPassNetwork "%~1"
			) else (
				call :code "%network_pass%"				
			)

			if %contador% LSS 8 (
				echo Escriba una clave con mas de 8 digitos: %contador%
			)

			exit /b 0
		)

		:code (
			set cadena=%~1
			
			set /a "contador=0"
			call :bucle

			exit /b 0
		)

		:bucle (
			set "cadena=%cadena:~1%"
			set /a "contador+=1"
			
			if defined cadena (
				goto :bucle
			)
			
			exit /b 0
		)

		REM :getSizeString (
		REM 	set /a cont=1
		REM 	set /p MiClave=%network_pass%
		REM 	call :lenghtString "%~1"
		REM 	echo Cantidad de caracteres: %cont%
		REM )

		REM :lenghtString (
		REM 	if not defined MiClave (goto :Finished)
		REM 	set MiClave=%MiClave:~1%
		REM 	set /a cont +=1
		REM 	echo Clave: %MiClave% y %cont%
		REM 	goto :lenghtString
		REM )

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