#! /bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
  exit
fi

if [[ $1 =~ ^[0-9]+$ ]]
then
  ELEMENT=$($PSQL "SELECT atomic_number, symbol, name FROM elements WHERE atomic_number=$1")
else
  ELEMENT=$($PSQL "SELECT atomic_number, symbol, name FROM elements WHERE symbol='$1' OR name='$1'")
fi
if [[ -z $ELEMENT ]]
then
  echo "I could not find that element in the database."
  exit
fi

IFS="|" read ATOMIC_NUMBER SYMBOL NAME <<< "$ELEMENT"

PROPERTIES=$($PSQL "SELECT atomic_mass, melting_point_celsius, boiling_point_celsius, type_id FROM properties WHERE atomic_number=$ATOMIC_NUMBER")

IFS="|" read MASS MELT BOIL TYPE_ID <<< "$PROPERTIES"

TYPE=$($PSQL "SELECT type FROM types WHERE type_id=$TYPE_ID")

NAME=$(echo $NAME | xargs)
SYMBOL=$(echo $SYMBOL | xargs)
TYPE=$(echo $TYPE | xargs)
MASS=$(echo $MASS | xargs)
MELT=$(echo $MELT | xargs)
BOIL=$(echo $BOIL | xargs)