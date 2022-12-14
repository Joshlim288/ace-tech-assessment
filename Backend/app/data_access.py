'''
Contains the logic for storing and retrieving data from the database
'''
# library imports
import pymongo
import os
from pathlib import Path

# project imports
from data_definition import Team
client = pymongo.MongoClient(os.environ.get('ME_CONFIG_MONGODB_URL', 'mongodb://admin:password@mongo:27017/'))
db = client.football_scoreboard
collection = db.teams

'''
Saves a new team to the database
takes in a List of Team objects
returns True if successfully added
'''
def addTeamsToDatabase(teams):
    for team in teams:
        collection.insert_one(team.toDoc())
    return True

'''
Updates the Team objects in the database with the same team names
takes in a List of Team objects
returns True if successfully updated
'''
def updateTeams(teams):
    for team in teams:
        # update only attributes related to score
        collection.update_one({'_id':team.teamName}, {"$set": {'points': team.points,'goalsScored': team.goalsScored,'altPoints': team.altPoints}}, upsert=False)
    return True

'''
Retrieve all teams currently registered
Returns a Dictionary where keys are the team's name, and the value is the Team object
'''
def getTeams():
    teams = list(collection.find({}))
    return {teamDoc['_id']: Team.fromDoc(teamDoc) for teamDoc in teams}

'''
Clears all teams (and thus results) from the database
Returns True if successful
'''
def deleteTeams():
    collection.delete_many({})
    return True