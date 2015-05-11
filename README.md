# sleep-goal-tracker
Set goals for your sleeping habits and track how your doing!

## Project Vision
This application will be a small command line based application that asks the user what kind of Sleeping habits they would like to set for themselves, then tracks their progress on whether or not they reach them.

Users will be able to add/edit/track their goals, in order to hopefully help them achieve they sleeping habits they would like to have.

## Features

### Adding new goals
In hopes to be able to sleep better I want to be able to add sleeping goals.
```
Usage Example:
./sleep_goal_tracker manage
  Add a goal
  List all gaols
  Exit 1 What goals would you like to add? getting to be earlier "getting to be earlier" has been added
  Add a goal
  List all gaols
  Exit
```
Acceptance Criteria:
  * Program will print out confirmation that the new goal was added
  * The goals is added to the database
  * After being added, the goal will be visible via. "List all goals", once that feature has been implemented
  * After the addition, the user is taken back to the main manage menu

### Editing goals
In order to fix typos and/clarify the meaning of a goal I want to edit an existing goal.
```
Usage Example:
./sleep_goal_tracker manage
  Add a goal
  List all gaols
  Exit 2
  getting to be earlier
  waking up earlier
  sleeping with tv off
```
Acceptance Criteria:
  * All goals are printed out
  * Each goal is given a number, but it will not correspond to its database id

### Deleting goals
In order to remove duplicates and/or goals that aren't helpful I want to delete an existing goal
```
Usage Example:
./sleep_goal_tracker manage
  Add a goal
  List all gaols
  Exit 2
  getting to be earlier
  waking up earlier
  sleeping with tv off
  Edit
  Delete
  Exit 1 "waking up earlier" has been deleted
  Add a goal
  List all gaols
  Exit
```
Acceptance Criteria:
  * Program prints out confirmation that the goal was deleted
  * The deleted goal is removed from the database
  * All references to the deleted goal are removed from the database
  * After the deletion, the user is taken back to the main manage menu

### Tracking goals


### Completing/Checking of the goals they have accomplished
