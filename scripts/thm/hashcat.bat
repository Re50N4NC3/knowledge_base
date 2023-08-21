@echo off
REM "Script so i don't have to remember basic commands for hashcat"
REM "Maybe add autodetect of hash type and go through all of them"
set /p hash_type="Enter the hash type (https://hashcat.net/wiki/doku.php?id=example_hashes): "
set /p hash="Enter the hash, if it contains salt, separate it using colon: "

echo %hash% | find ":" > nul
if errorlevel 1 (
    set /p salt="Enter the salt (if none, press Enter): "
) else (
    set "salt="
)

echo Choose a hash mode:
echo  "0 | Straight"
echo  "1 | Combination"
echo  "3 | Brute-force"
echo  "6 | Hybrid Wordlist + Mask"
echo  "7 | Hybrid Mask + Wordlist"
echo  "9 | Association"

set /p hash_mode="Enter the hash mode (Enter for 0): "

if "%hash_mode%"=="" set "hash_mode=0"

if "%salt%"=="" (
    <nul set /p=%hash%> ..\wordlists\to_crack.txt
) else (
    <nul set /p=%hash%:%salt%> ..\wordlists\to_crack.txt
)

set /p wordlist_path="Enter the path to the wordlist (press Enter to use default ..\wordlists\rockyou.txt): "
if "%wordlist_path%"=="" set "wordlist_path=..\wordlists\rockyou.txt"

hashcat.exe -m %hash_type% -a %hash_mode% ..\wordlists\to_crack.txt %wordlist_path% --show

pause
