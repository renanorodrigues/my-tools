#!/bin/bash

cd ~

if [ ! -d workspace ]
then
  mkdir workspace
fi

cd ~/workspace
LINK_REPO=https://github.com/renanorodrigues/docker-compose-rails.git
HEAD_STYLE="==============================================================="

while :
do
  read -p "Digite se o projeto é uma API ou não [y/n]: " request
	if [[ $request == 'y' || $request == 'n' ]]
	then
		break
	fi
done

MODE_API=$(echo $request | tr '[:upper:]' '[:lower:]')

create_new_project_rails(){
  echo "Clonando o projeto"
  echo $HEAD_STYLE
  git clone $LINK_REPO $1

  cd $1

  echo "Etapa de build da imagem"
  echo $HEAD_STYLE
  docker-compose build

  if [ $MODE_API == 'n' ]
  then
  docker-compose run --rm web rails new . --force --database=postgresql
  else
  docker-compose run web rails new . --api --force --database=postgresql --T
  fi

  sudo chown -R $USER:$USER .
  docker-compose down
}

create_new_project_rails $1 2>logs.txt

if [ $? -eq 0 ]
then
  echo "Projeto Rails criado com sucesso!"
else
  echo "Não foi possível criar o projeto corretamente. Por favor, entrar na pasta do projeto!"
fi
