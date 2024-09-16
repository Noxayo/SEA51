@echo off

REM Chemin vers le dossier d'installation de VirtualBox
set VBOXMANAGE="C:\Program Files\Oracle\VirtualBox\VBoxManage.exe"

REM Initialisation des variables du nom de la machine,de la taille de la RAM et de la taille du disque dur
set MV=%2%
set NB=%3%
set RAM=%4%
set DISQUE=%5%

REM Vérification qu'il y a un premier argument (action a faire)
if "%~1"=="" (
    echo "Veuillez preciser une action.('>$ genVM.bat HELP' pour plus d'information)"
    exit /b
)

REM Lister les commandes disponibles
if /i "%1%"=="HELP" (
    echo L = Listage des machine virtuelle existante
    echo C = Creation d'une ou plusieurs machines virtuelles
    echo D = Demarage de la machine virtuelle
    echo A = Arret de la machine virtuelle
    echo S = Suppression de la machine virtuelle
    echo SA = Super Arret des machines virtuelles
    echo SD = Super Demarage des machines virtuelles
    echo SS = Super Suppression des machines virtuelles
    echo SC = Super Creation des machines virtuelles
    exit /b
)



REM Lister les machines enregistrées
if /i "%1%"=="L" (
for /f "tokens=1" %%a in ('%VBOXMANAGE% list vms') do (
        echo Machine %%a :
        %VBOXMANAGE% getextradata %%~a enumerate
    )
    exit /b
)

REM Vérification dans le cas ou la machine existe deja
if /i "%1%"=="C" (
    REM Vérification qu'il y a un second argument (nom de la machine)
    if "%~2"=="" (
        echo "Veuillez specifier le nom de la machine virtuelle."
        exit /b
    )
    REM Vérification qu'il y a un troisième argument (taille de la RAM)
    if "%~3"=="" (
        echo "Veuillez specifier la taille de RAM de(s) machine(s)".
        exit /b
    )
    REM Vérification qu'il y a un cinquième argument (taille du disque)
    if "%~4"=="" (
        echo "Veuillez specifier la taille de DISQUE de(s) machine(s)".
        exit /b
    )
    %VBOXMANAGE% showvminfo "%MV%" >nul 2>nul
    if %errorlevel% equ 0 (

        REM Suppression de la machine pour la recrée si elle existe deja
        echo La machine existait deja, elle a ete supprimer
        %VBOXMANAGE% unregistervm "%MV%" --delete
    )

    REM Création de la machine virtuelle
    %VBOXMANAGE% createvm --name "%MV%" --ostype Debian_64 --register

    REM Création du dossier disk s'il n'existe pas
    if not exist "disk" mkdir "disk"

    REM Configuration de la machine virtuelle
    %VBOXMANAGE% modifyvm %MV% --memory %3%
    %VBOXMANAGE% createmedium disk --filename "disk\%MV%.vdi" --size %4%
    %VBOXMANAGE% storagectl %MV% --name "SATA Controller" --add sata --bootable on
    %VBOXMANAGE% storageattach "%MV%" --storagectl "SATA Controller" --port 0 --device 0 --type hdd --medium "disk\%MV%.vdi"
    %VBOXMANAGE% modifyvm %MV% --nic1 nat --nicbootprio1 1

    REM Activation du PXE
    %VBOXMANAGE% modifyvm "%MV%" --boot1 net

    REM Ajouter des métadonnées a la machine virtuelle
    %VBOXMANAGE% setextradata "%MV%" "CustomData/Date" "%DATE%"
    %VBOXMANAGE% setextradata "%MV%" "CustomData/User" "%USERNAME%"

    echo La machine virtuelle "%MV%" a bien ete creee.
    exit /b
)

REM Si l'option de démarage de la machine est choisit
if /i "%1%"=="D" (
    REM Vérification qu'il y a un second argument (nom de la machine)
    if "%~2"=="" (
        echo "Veuillez specifier le nom de la machine virtuelle."
        exit /b
    )
    %VBOXMANAGE% startvm "%MV%"
    echo La machine virtuelle "%MV%" a bien ete demaree.
    exit /b
)

REM Si l'option d'arrêt de la machine est choisit
if /i "%1%"=="A" (
    REM Vérification qu'il y a un second argument (nom de la machine)
    if "%~2"=="" (
        echo "Veuillez specifier le nom de la machine virtuelle."
        exit /b
    )
    %VBOXMANAGE% controlvm "%MV%" poweroff
    echo La machine virtuelle "%MV%" a bien ete arrêter.
    exit /b
)

REM Si l'option de suppression de la machine est choisit
if /i "%1%"=="S" (
    REM Vérification qu'il y a un second argument (nom de la machine)
    if "%~2"=="" (
        echo "Veuillez specifier le nom de la machine virtuelle."
        exit /b
    )
    %VBOXMANAGE% unregistervm "%MV%" --delete
    echo La machine virtuelle "%MV%" a bien ete supprimee.
    exit /b
)

REM Si l'option d'arrêt de la machine est choisit
if /i "%1%"=="SA" (
    REM Vérification qu'il y a un troisième argument (nombre de machine)
    if "%~3"=="" (
        echo "Veuillez specifier le nombre de machine(s)".
        exit /b
    )
    REM Vérification qu'il y a un second argument (nom de la machine)
    if "%~2"=="" (
        echo "Veuillez specifier le nom de la machine virtuelle."
        exit /b
    )
    for /L %%i in (1,1,%NB%) do (
        %VBOXMANAGE% controlvm "%MV%_%%i" poweroff
        echo La machine virtuelle "%MV%_%%i" a bien ete arrêter.
    )    
    exit /b
)


REM Si l'option d'arrêt de la machine est choisit
if /i "%1%"=="SD" (
    REM Vérification qu'il y a un troisième argument (nombre de machine)
    if "%~3"=="" (
        echo "Veuillez specifier le nombre de machine(s)".
        exit /b
    )
    REM Vérification qu'il y a un second argument (nom de la machine)
    if "%~2"=="" (
        echo Veuillez specifier le nom de la machine virtuelle.
        exit /b
    )
    for /L %%i in (1,1,%NB%) do (
        %VBOXMANAGE% startvm "%MV%_%%i"
    echo La machine virtuelle "%MV%_%%i" a bien ete demaree.
    )    
    exit /b
)


REM Si l'option de suppression de la machine est choisit
if /i "%1%"=="SS" (
    REM Vérification qu'il y a un troisième argument (nombre de machine)
    if "%~3"=="" (
        echo "Veuillez specifier le nombre de machine(s)".
        exit /b
    )
    REM Vérification qu'il y a un second argument (nom de la machine)
    if "%~2"=="" (
        echo "Veuillez specifier le nom de la machine virtuelle."
        exit /b
    )
    for /L %%i in (1,1,%NB%) do (
        %VBOXMANAGE% unregistervm "%MV%_%%i" --delete
        echo La machine virtuelle "%MV%_%%i" a bien ete supprimee.
    )
    exit /b
)

REM Si l'option de création de la machine est choisit
if /i "%1%"=="SC" (
    REM Vérification qu'il y a un second argument (nom de la machine)
    if "%~2"=="" (
        echo "Veuillez specifier le nom de la machine virtuelle."
        exit /b
    ) 
    REM Vérification qu'il y a un troisième argument (nombre de machine)
    if "%~3"=="" (
        echo "Veuillez specifier le nombre de machine(s)".
        exit /b
    )
    REM Vérification qu'il y a un quatrième argument (taille de la RAM)
    if "%~4"=="" (
        echo "Veuillez specifier la taille de RAM de(s) machine(s)".
        exit /b
    )
    REM Vérification qu'il y a un cinquième argument (taille du disque)
    if "%~5"=="" (
        echo "Veuillez specifier la taille de DISQUE de(s) machine(s)".
        exit /b
    )
    for /L %%i in (1,1,%NB%) do (
        echo %%i
        REM Vérification dans le cas ou la machine existe deja
        %VBOXMANAGE% showvminfo "%MV%_%%i" >nul 2>nul
        if %errorlevel% equ 0 (

            REM Suppression de la machine pour la recrée si elle existe deja
            echo La machine existait deja, elle a ete supprimer
            %VBOXMANAGE% unregistervm "%MV%_%%i" --delete
        )

        REM Création de la machine virtuelle
        %VBOXMANAGE% createvm --name "%MV%_%%i" --ostype Debian_64 --register

        REM Création du dossier disk s'il n'existe pas
        if not exist "disk" mkdir "disk"

        REM Configuration de la machine virtuelle
        %VBOXMANAGE% modifyvm "%MV%_%%i" --memory %RAM%
        %VBOXMANAGE% createmedium disk --filename "disk\%MV%_%%i.vdi" --size %DISQUE%
        %VBOXMANAGE% storagectl "%MV%_%%i" --name "SATA Controller" --add sata --bootable on
        %VBOXMANAGE% storageattach "%MV%_%%i" --storagectl "SATA Controller" --port 0 --device 0 --type hdd --medium "disk\%MV%_%%i.vdi"
        %VBOXMANAGE% modifyvm "%MV%_%%i" --nic1 nat --nicbootprio1 1

        REM Activation du PXE
        %VBOXMANAGE% modifyvm "%MV%_%%i" --boot1 net

        REM Ajouter des métadonnées a la machine virtuelle
        %VBOXMANAGE% setextradata "%MV%_%%i" "CustomData/Date" "%DATE%"
        %VBOXMANAGE% setextradata "%MV%_%%i" "CustomData/User" "%USERNAME%"

        echo La machine virtuelle %MV%_%%i a bien ete creee.
    )
exit /b
)
