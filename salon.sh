#! /bin/bash
PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c "

echo -e "\n~~~ My Salon ~~~\n"
echo -e "Welcome to My Salon, how can I help you?\n"
MAIN_MENU() {
  if [[ $1 ]]
  then
    echo -e "\n$1"
  fi
  
  SERVICES=$($PSQL "SELECT * FROM services ORDER BY service_id")
  
    echo "$SERVICES" | while read ID BAR SERVICE_NAME
    do
      echo "$ID) $SERVICE_NAME"
    done    

    read SERVICE_ID_SELECTED
    SERVICE_ID=$($PSQL "SELECT service_id FROM services WHERE service_id = $SERVICE_ID_SELECTED")
    if [[ -z $SERVICE_ID ]]
    then
      MAIN_MENU "I could not find that service. What would you like today?"
    else 
      SET_APPOINTMENT $SERVICE_ID
    fi 
}

SET_APPOINTMENT() {
        SERVICE_ID_SELECTED=$1
        SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id=$SERVICE_ID_SELECTED")
        echo -e "\nWhat's your phone number?"
        read CUSTOMER_PHONE

        CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone = '$CUSTOMER_PHONE'")

        # if customer doesn't exist
        if [[ -z $CUSTOMER_NAME ]]
        then
          # get new customer name
          echo -e "\nI don't have a record for that phone number, what's your name??"
          read CUSTOMER_NAME
          # insert new customer
          $($PSQL "INSERT INTO customers(name, phone) VALUES('$CUSTOMER_NAME', '$CUSTOMER_PHONE')")         
        fi
        
         CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")
       #  CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone='$CUSTOMER_PHONE'")
          echo -e "What time would you like your $SERVICE_NAME, $CUSTOMER_NAME?"
  read SERVICE_TIME
 # if [[ ! $SERVICE_TIME =~ ^([0-1]?[0-9]|2[0-3])(:[0-5][0-9])?$|^([0-9]|1[0-2])(am|AM|pm|PM)?$ ]]; then
 #   MAIN_MENU "That is not a valid hour."
#  else
 #   if [[ -z $SERVICE_TIME ]]
  #  then
   #   MAIN_MENU "That is not a valid hour."
    #else
     INSERT_APPOINTMENT_RESULT=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME')")
     echo -e "I have put you down for a $SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."
  
#fi
}
MAIN_MENU