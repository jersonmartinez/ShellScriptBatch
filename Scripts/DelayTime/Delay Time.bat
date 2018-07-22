@echo off
	title TimeDelay / Side Master

		:Init
			setlocal
				set /a TimeOut=%TIME:~6,2%+%1

				if %TimeOut% gtr 59 (
					set /a TimeOut=%TimeOut%-60
				)

				call :Arguments %TimeOut% %TIME:~0,-3%
			endlocal

		:Arguments
			if %TIME:~6,2% neq %~1 (
				goto Arguments
			)
			
			call :Finished %~2

		:Finished
			echo Tiempo completado [%~1 - %TIME:~0,-3%]
	pause>nul
exit