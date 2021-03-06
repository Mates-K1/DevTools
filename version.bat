@ECHO OFF
REM this script will update the "build" number of the ZenPhoto20 version and commit it
REM copyright by Stephen Billard, all rights reserved.

SET SOURCE=zp-core\version.php
FOR /F "delims=" %%a in ('FINDSTR "ZENPHOTO_VERSION" %SOURCE%') DO SET REL=%%a
SET REL=%REL:~28,-3%

FOR /F "tokens=1,2,3,4,5 delims=.'-" %%a in ("%REL%") DO (
	SET major=%%a
	SET minor=%%b
	SET release=%%c
	SET build=%%d
	SET devbuild=%%e
	)
SET beta=[]
SET /a devversion=0

FOR /F "tokens=1,2 delims=.'-" %%a in ("%CD%") DO (
	SET base = %%a
	SET beta=%%b
)

if NOT [%beta%]==[] GOTO SETVERSION
SET param=%1
IF [%param%]==[] GOTO BUILD
SET option=%param:~0,3%
IF [%option%]==[maj] GOTO MAJOR
IF [%option%]==[min] GOTO MINOR
IF [%option%]==[rel] GOTO RELEASE
GOTO BUILD
:MAJOR
SET /a major=%major%+1
SET /a minor=0
SET /a release=0
SET /a build=0
GOTO SETVERSION
:MINOR
SET /a minor=%minor%+1
SET /a release=0
SET /a build=0
GOTO SETVERSION
:RELEASE
SET /a release=%release%+1
SET /a build=0
GOTO SETVERSION
:BUILD
SET /a N=1%build%-(11%build%-1%build%)/10
SET /a build=%N%+1
SET /a N=1%build%-(11%build%-1%build%)/10
SET N=000000%N%
SET build=%N:~-2%
:SETVERSION
SET new=%major%.%minor%.%release%.%build%
SET doc=%new%
@ECHO OFF
IF [%beta%]==[] GOTO TAG
if [%devbuild%]==[] goto DEVBUILD

FOR /F "tokens=1,2 delims=.'_" %%a in ("%devbuild%") DO (
	SET base=%%a
	SET devversion=%%b
)
:DEVBUILD
SET /a N=1%devversion%-(11%devversion%-1%devversion%)/10
SET /a devversion=%N%+1
SET /a N=1%devversion%-(11%devversion%-1%devversion%)/10
SET N=000000%N%
SET devversion=%N:~-2%
SET new=%new%.%beta%_%devversion%

REM for dev builds show doc as next build level
SET /a N=1%build%-(11%build%-1%build%)/10
SET /a build=%N%+1
SET /a N=1%build%-(11%build%-1%build%)/10
SET N=000000%N%
SET build=%N:~-2%
SET doc=%major%.%minor%.%release%.%build%

:TAG

>%SOURCE%	echo ^<?php
>>%SOURCE%	echo // This file contains version info only and is automatically updated. DO NOT EDIT.
>>%SOURCE%	echo define('ZENPHOTO_VERSION', '%new%');
>>%SOURCE%	echo ?^>


:DOCUPDATE
setlocal

set dest="docs\release notes.htm"

rem del %dest%

(for /f "delims=" %%i in (D:\test_sites\dev\docs\release_notes.htm) do (
    set "line=%%i"
    setlocal enabledelayedexpansion
    set "line=!line:$v$=%doc%!"
    echo(!line!
    endlocal
))>%dest%

:COMMIT

rem commit the changes

@git add .
@git commit -m"release build %NEW%"

:END
