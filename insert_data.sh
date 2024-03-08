#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
echo $($PSQL "TRUNCATE TABLE games, teams")

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  if [[ $YEAR != 'year' ]]
  then

    #insert the teams in the teams table

    #find if team exists
    WINNER_TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
    OPPONENT_TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
    
    #if not then insert it
    #winner team
    if [[ -z $WINNER_TEAM_ID ]]
    then
      WINNER_INSERT_RESULT=$($PSQL "INSERT INTO teams (name) VALUES ('$WINNER')")
      if [[ $WINNER_INSERT_RESULT == 'INSERT 0 1'  ]]
      then
        echo  "Inserted $WINNER"
      fi
      WINNER_TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
      echo $WINNER_TEAM_ID 
    fi

    #opponent team
    if [[ -z $OPPONENT_TEAM_ID ]]
    then
      OPPONENT_INSERT_RESULT=$($PSQL "INSERT INTO teams (name) VALUES ('$OPPONENT')")
      if [[ $OPPONENT_INSERT_RESULT == 'INSERT 0 1'  ]]
      then
        echo "Inserted $OPPONENT"
      fi
      OPPONENT_TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
      echo $OPPONENT_TEAM_ID
    fi
    # teams inserted at this point

    GAME_INSERT_RESULT=$($PSQL "INSERT INTO games (year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES ($YEAR, '$ROUND', $WINNER_TEAM_ID, $OPPONENT_TEAM_ID, $WINNER_GOALS, $OPPONENT_GOALS)")
    if [[ $GAME_INSERT_RESULT == 'INSERT 0 1' ]]
    then 
      echo "Inserted : $YEAR, $ROUND, $WINNER_TEAM_ID, $OPPONENT_TEAM_ID, $WINNER_GOALS, $OPPONENT_GOALS"
    else
      echo "Problem while inserting"
    fi
  fi
done