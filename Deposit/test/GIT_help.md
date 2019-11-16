# GIT setup

Сначала создаем на github репозиторий,

переходим в терминал в каталог с проектом и далее делаем по инструкции github

echo ...........

git init

git add . // добавляем все файлы

.........


# Push

Новые изменения git status

git add файлы

git commit - m " "

git push


# Pull

git pull origin master // вытягиваем с github в локальный репозиторий

# Checkout

git checkout хэш из лога // возврат к старому коментарию - назад в будущее

git checkout master // когда поняли, что поломалось, выполняем git checkout master

# Revert

git revert HEAD --no-edit // удаление последнего коментария 

# Other

команда clear очищает окно терминала.

git log
gitk редактор

git add . // только для текущей директории
git add * // для всех (реком.)
Красивый Terminal : https://ohmyz.sh/

git commit -m "end" --date 2019-11-01T22:22:30

# Постоянная аутентификация с репозиториями Git (не требуется каждый раз вводить пароль)

git config credential.helper store
git push https://github.com/repo.git

Username for 'https://github.com': <USERNAME>
Password for 'https://USERNAME@github.com': <PASSWORD>

* распространенной ошибкой является клонирование по умолчанию (HTTPS) вместо SSH. 
Вы можете исправить это, перейдя в свой репозиторий, нажав "клонировать или загружать", 
затем нажав кнопку" использовать SSH " над полем URL и обновив URL-адрес вашего origin remote следующим образом:

git remote set-url origin git@github.com:username/repo.git

///////////////////////////////////////////////////////////////////////////////////////////////////// 

git init // локально

readme.md

git add 

git remote add origin https://github.com/ftw-soft/pikabu-lesson.git // как локальный репозиторий "подружить" с нашим удаленным.

git remote -v // проверка правильно "соединили" локальный репозиторий с удаленным 

потом git commit -m "initial commit"

git push -u origin master


 
