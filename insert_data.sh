#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS 
do
TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
OPP_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
  if [[ $WINNER != 'winner' && $OPPONENT != 'opponent' ]]
  then
    if [[ -z $TEAM_ID ]]
    then
      INSERT_TEAM_ID=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
      if [[ $INSERT_TEAM_ID = 'INSERT 0 1' ]]
      then 
        echo "Inserted into teams: $WINNER"
      fi
    fi
    if [[ -z $OPP_ID ]]
    then
      INSERT_TEAM_ID=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
      if [[ $INSERT_TEAM_ID = 'INSERT 0 1' ]]
      then 
        echo "Inserted into teams: $OPPONENT"
      fi
    fi
  fi
done

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS 
do

  if [[ $WINNER != 'winner' && $OPPONENT != 'opponent' && $YEAR != 'year' && $ROUND != 'round' && $WINNER_GOALS != 'winner_goals' && $OPPONENT_GOALS != 'opponent_goals' ]]
  then 
    WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$WINNER' ") 
    OPP_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$OPPONENT' ")
    TEAM_ID=$($PSQL "SELECT team_id FROM games LEFT JOIN teams ON games.winner_id = teams.team_id WHERE winner_id = $WINNER_ID AND opponent_id = $OPP_ID ")  
    if [[ -z $TEAM_ID ]]
    then 
      INSERT_DATA=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($YEAR, '$ROUND', $WINNER_ID, $OPP_ID, $WINNER_GOALS, $OPPONENT_GOALS)")
    fi
  fi
done
