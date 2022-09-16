'''
SCORE CONTROLLER
Contains the main business logic for the application
'''
# library imports
import re
from datetime import datetime

# project imports
import data_access
from data_definition import Team

# Constants
TEAM_INFO_REGEX = "\s*[a-zA-Z0-9]+\s[0-9]{2}\/[0-9]{2}\s[0-9]+\s*"
MATCH_ENTRY_REGEX = "\s*([a-zA-Z0-9]+\s){2}([0-9]+\s){2}\s*"

'''
Enter team information into the system

Takes in a string with the following syntax:
<Team A name> <Team A registration date in DD/MM> <Team A group number>
<Team B name> <Team B registration date in DD/MM> <Team B group number>
<Team C name> <Team C registration date in DD/MM> <Team C group number>

Returns a tuple of the following format:
(Status code, message)
'''
def registerTeams(rawTeams):
    teamsStrings = rawTeams.split('\n')
    teams = []
    seenNames = set()
    for teamString in teamsStrings:
        # validate format of each entered team string
        if not re.fullmatch(TEAM_INFO_REGEX, teamString):
            return (400, 'Invalid data format for team: ' + teamString)

        teamName, regDate, group = teamString.strip().split(' ')

        # validate date logic
        try:
            regDate = datetime.strptime(regDate, "%d/%m")
        except:
            return (400, 'Invalid registration date: ', regDate)
        
        # ensure teamname unique
        if teamName in seenNames:
            return (400, 'Duplicate team name: ', teamName)

        teams += [Team(teamName, regDate, group)]

    # commit updates
    if not data_access.addTeamsToDatabase(teams):
        return (500, 'Database error')
        
    return (200, 'Success')
        

'''
Updates 2 team's scores based on the result of a match
returns the updated Team objects as a tuple (teamA, teamB)
#TODO check whether there is a need to return, python pass by reference?
'''
def updateScores(teamA, teamB, scoreA, scoreB):
    if scoreA > scoreB:
        # winner
        teamA.points += 3
        teamA.altPoints += 5
        # loser
        teamB.altPoints += 1
    elif scoreA < scoreB:
        # winner
        teamB.points += 3
        teamB.altPoints += 5
        # loser
        teamA.altPoints += 1
    else:
        teamA.points += 1
        teamB.points += 1
        teamA.altPoints += 3
        teamB.altPoints += 3
    teamA.goalsScored += scoreA
    teamB.goalsScored += scoreB
    return (teamA, teamB)

'''
Enter match information into the system

Takes in a string with the following syntax:
<Team A name> <Team B name> <Team A goals scored> <Team B goals scored>
<Team B name> <Team C name> <Team B goals scored> <Team C goals scored>
<Team C name> <Team D name> <Team C goals scored> <Team D goals scored>

Returns a tuple of the following format:
(Status code, message)
'''
def inputMatchResult(rawResults):
    teams = data_access.getTeams()
    toUpdate = {} # so we don't have to update teams that are not modified
    results = rawResults.split('\n')
    for result in results:
        # validate format of each entered result string
        if not re.fullmatch(MATCH_ENTRY_REGEX, result):
            return (400, 'Invalid data format for result: ' + result)
        AName, BName, scoreA, scoreB = result.strip().split(' ')

        # check team registered
        if teamA not in teams or teamB not in teams:
            return (400, 'Unregistered team present for result: ', result)

        # update scores
        teamA, teamB = teams[AName], teams[BName]
        scoreA, scoreB = int(scoreA), int(scoreB)
        teamA, teamB = updateScores(teamA, teamB, scoreA, scoreB)
        teams[AName], teams[BName] = teamA, teamB
        toUpdate[AName], toUpdate[BName] = teamA, teamB

    # commit updates
    if not data_access.updateTeams(toUpdate.values()):
        return (500, 'Database error')

    return (200, 'Success')
    
