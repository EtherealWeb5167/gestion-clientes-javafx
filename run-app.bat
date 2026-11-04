@echo off
rem ============================================================
rem  Arranca la app JavaFX con el JDK 21 y Maven instalados.
rem  Si mvn sigue sin reconocerse, usa el Maven de IntelliJ.
rem ============================================================
setlocal
set "PROJECT=%~dp0"

rem --- Buscar JAVA_HOME (JDK 21 preferido) ---
if defined JAVA_HOME if exist "%JAVA_HOME%\bin\javac.exe" goto :maven

rem --- JDK 21 de Temurin instalado por WorkBuddy ---
for /d %%D in ("%USERPROFILE%\.jdks\jdk-21*") do set "JAVA_HOME=%%D"
if exist "%JAVA_HOME%\bin\javac.exe" goto :maven

rem --- Ultimo recurso: JBR de IntelliJ (Java 25, compila release 21) ---
set "JAVA_HOME=C:\Program Files\JetBrains\IntelliJ IDEA 2026.2.4\jbr"
if exist "%JAVA_HOME%\bin\javac.exe" goto :maven

echo ERROR: No se encontro ningun JDK. Instala JDK 21.
pause
exit /b 1

:maven
echo Usando JAVA_HOME=%JAVA_HOME%

rem --- Buscar Maven en PATH, luego el instalado en tools, luego el de IntelliJ ---
where mvn >nul 2>nul && (mvn clean javafx:run & goto :fin)

for /d %%M in ("%USERPROFILE%\tools\apache-maven-*") do set "MVN=%%M\bin\mvn.cmd"
if exist "%MVN%" (call "%MVN%" clean javafx:run & goto :fin)

set "MVN=C:\Program Files\JetBrains\IntelliJ IDEA 2026.2.4\plugins\maven-plugin\lib\maven3\bin\mvn.cmd"
if exist "%MVN%" (call "%MVN%" clean javafx:run & goto :fin)

echo ERROR: No se encontro Maven.
:fin
pause
