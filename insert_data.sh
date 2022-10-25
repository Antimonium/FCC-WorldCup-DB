#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
echo $($PSQL "truncate games, teams restart identity")

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS

do
#winner
if [[ $WINNER != "winner" ]]
then
    WINNER_ID=$($PSQL "select team_id from teams where name='$WINNER'")
if  [[ -z $WINNER_ID ]]
then
    INSERT_NAME=$($PSQL "insert into teams(name) values ('$WINNER')")
if [[ $INSERT_NAME == "INSERT 0 1" ]]
then
      echo Inserted into teams, $WINNER.
fi

    WINNER_ID=$($PSQL "select team_id from teams where name='$WINNER'")
fi
fi

#opponent
if [[ $OPPONENT != "opponent" ]]
then
  OPPONENT_ID=$($PSQL "select team_id from teams where name='$OPPONENT'")
if [[ -z $OPPONENT_ID ]]
then
    INSERT_OP_NAME=$($PSQL "insert into teams(name) values ('$OPPONENT')")
if [[ $INSERT_OP_NAME == "INSERT 0 1" ]]
then
    echo Inserted into teams, $OPPONENT.
fi
  OPPONENT_ID=$($PSQL "select team_id from teams where name='$OPPONENT'")
fi
fi


#games table

if [[ $YEAR != "year" ]]
then
  INSERT_GAMES=$($PSQL "insert into games (year, round, winner_id, opponent_id, winner_goals, opponent_goals) values ($YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS)")
  if [[ $INSERT_GAMES == "INSERT 0 1" ]]
  then 
    echo Inserted into games $YEAR, $ROUND, $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS.
    fi
fi
done
