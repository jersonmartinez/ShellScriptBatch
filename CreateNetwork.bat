@echo off
	title Create Network \ Side Master
	
		:Init (
			call :getUserNetwork & cls
			echo Nombre de red: %network_name%
			
			call :getPassNetwork %network_name%
			echo Clave de red: %network_pass%

			goto :Finished
		)

		:getUserNetwork (
			set /p network_name=Nombre de red: 

			if /i ["%network_name%"]=="[]" (
				cls & call :getUserNetwork
			)

			exit /b 0
		)

		:getPassNetwork (
			echo Nombre de red: %~1
			set /p network_pass=Clave de red: 
			
			if [%network_pass%]==[] (
				cls & call :getPassNetwork %~1
			)

			exit /b 0
		)

		:Arguments

		:Finished
	pause>nul
exit