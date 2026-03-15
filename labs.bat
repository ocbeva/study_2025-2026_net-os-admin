@echo off
setlocal enabledelayedexpansion

echo ========================================
echo    Создание релизов для лабораторных
echo ========================================
echo.

REM Проверяем, что мы в правильной папке
if not exist labs (
    echo Ошибка: папка labs не найдена!
    echo Запустите файл из корневой папки проекта
    pause
    exit /b
)

REM Сохраняем текущую ветку
for /f "tokens=*" %%a in ('git branch --show-current') do set current_branch=%%a
echo Текущая ветка: %current_branch%
echo.

REM Создаем релизы для lab01 до lab16
for /l %%i in (1,1,16) do (
    set "num=%%i"
    if %%i lss 10 (set "folder=lab0%%i") else (set "folder=lab%%i")
    
    echo ----------------------------------------
    echo [%%i/16] Обрабатываем !folder!
    echo ----------------------------------------
    
    REM Переключаемся на master
    git checkout master >nul 2>&1
    if errorlevel 1 (
        echo Ошибка: не могу переключиться на master
        pause
        exit /b
    )
    
    REM Создаем новую ветку
    git checkout -b !folder!-release >nul 2>&1
    
    REM Удаляем все папки lab*, кроме нужной
    cd labs
    
    REM Удаляем все папки lab*
    for /d %%d in (lab*) do (
        if not "%%d"=="!folder!" (
            echo Удаляем %%d
            rmdir /s /q %%d >nul 2>&1
        )
    )
    
    cd ..
    
    REM Коммитим изменения
    git add .
    git commit -m "Prepare !folder! for release" >nul 2>&1
    
    REM Создаем тег
    git tag !folder!-v1.0.0
    
    REM Пушим тег
    git push origin !folder!-v1.0.0
    
    echo Готово: !folder!-v1.0.0
    echo.
)

echo ========================================
echo    Все теги созданы!
echo ========================================
echo.
echo Теперь зайдите на GitHub и создайте релизы:
echo 1. Перейдите в ваш репозиторий
echo 2. Нажмите Releases
echo 3. Create a new release
echo 4. Выберите тег из списка
echo 5. Заполните название и описание
echo 6. Опубликуйте
echo.
echo Повторите для всех 16 тегов
echo.
pause