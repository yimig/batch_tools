@echo off
net session >nul 2>&1
if not "%errorLevel%" == "0" (
  echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
  echo UAC.ShellExecute "%~s0", "%*", "", "runas", 1 >> "%temp%\getadmin.vbs"
  "%temp%\getadmin.vbs"
  exit /b 2
)
if "%1"=="run" (
    goto run
) else (
    if "%1"=="stop" (
        goto stop
    ) else (
        goto help
    )
)
echo show "%1"

:run
if "%2"=="mssql" (
sc start MSSQLSERVER
sc start SQLTELEMETRY
sc start SQLWriter
) else (
    if "%2"=="mysql" (
        sc start mysql
    ) else (
        if "%2"=="ora" (
            sc start OracleServiceXE
            sc start OracleXETNSListener
        ) else (
            if "%2"=="redis" (
                sc start redis
            ) else (
                if "%2"=="pgsql" (
                    sc start postgresql-x64-13
                ) else (
                    if "%2"=="all" (
                        sc start MSSQLSERVER
                        sc start SQLTELEMETRY
                        sc start SQLWriter
                        sc start OracleServiceXE
                        sc start OracleXETNSListener
                        sc start mysql
                        sc start redis
                        sc start postgresql-x64-13
                    ) else (
                        echo Bad command:
                        echo dbname "%2" does NOT exist!
                        echo.
                        goto help
                    )
                )
            )
        )
    )
)
goto end

:stop
if "%2"=="mssql" (
sc stop MSSQLSERVER
sc stop SQLTELEMETRY
sc stop SQLWriter
) else (
    if "%2"=="mysql" (
        sc stop mysql
    ) else (
        if "%2"=="ora" (
            sc stop OracleServiceXE
            sc stop OracleXETNSListener
        ) else (
            if "%2"=="redis" (
                sc stop redis
            ) else (
                if "%2"=="pgsql" (
                    sc stop postgresql-x64-13
                ) else (
                        if "%2"=="all" (
                        sc stop MSSQLSERVER
                        sc stop SQLTELEMETRY
                        sc stop SQLWriter
                        sc stop OracleServiceXE
                        sc stop OracleXETNSListener
                        sc stop mysql
                        sc stop postgresql-x64-13
                        sc stop redis
                    ) else (
                        echo Bad command:
                        echo dbname "%2" does NOT exist!
                        echo.
                        goto help
                    )
                )
            )
        )
    )
)
goto end

:help
echo ==========DB Manager===========
echo.
echo db [run/stop] ^<%%dbname%%^>
echo.
echo available database:
echo.
echo ^|  dbname  ^|   database    ^|
echo ^|  mssql   ^|  sql server   ^|
echo ^|  mysql   ^|     mysql     ^|
echo ^|  ora     ^|   oracle db   ^|
echo ^|  redis   ^|     redis     ^|
echo ^|  pgsql   ^|   postgreSql  ^|
echo ^|  all     ^| all db service^|
echo.
echo example:
echo db run mysql -----run mysql service
echo db stop all -----stop all service
echo.
echo ===============================

:end
echo.