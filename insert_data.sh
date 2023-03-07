#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
echo $($PSQL "TRUNCATE games, teams")
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  if [[ $YEAR != "year" ]]
  then
    # get winner team_id
    WINNERTEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
    # if not found
    if [[ -z $WINNERTEAM_ID ]]
    then
      # insert team
      INSERT_WINNERTEAMRESULT=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")      
      WINNERTEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
    fi
    # get opponent team_id
    OPPONENTTEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
    # if not found
    if [[ -z $OPPONENTTEAM_ID ]]
    then
      INSERT_OPPONENTRESULT=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")      
      OPPONENTTEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
    fi

    # insert games
    INSERT_GAMERESULT=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES ($YEAR, '$ROUND', $WINNERTEAM_ID, $OPPONENTTEAM_ID, $WINNER_GOALS, $OPPONENT_GOALS)")
  fi
done
