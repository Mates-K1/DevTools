@ECHO off
FOR /f "skip=1" %%x IN ('wmic os get localdatetime') DO IF NOT DEFINED mydate SET mydate=%%x
FOR /f "tokens=1-3 delims=-." %%i IN ("%mydate%") DO (
	SET p1=%%i
	SET p2=%%j
	SET p3=%%k
)

SET upstream=zenphoto%p1%%p2%%p3%
ECHO on

git remote add %upstream% https://github.com/zenphoto/zenphoto.git
git fetch %upstream%
git merge --no-commit %upstream%/master
git remote remove %upstream%