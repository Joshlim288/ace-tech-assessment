'''
SCORE CONTROLLER
Contains the main business logic for the application
'''
# library imports
import re
from datetime import datetime

# project imports
from data_definition import Team
import data_access

# Constants
TEAM_INFO_REGEX = "\s*[a-zA-Z0-9]+\s[0-9]{2}\/[0-9]{2}\s[0-9]+\s*"
MATCH_ENTRY_REGEX = "\s*([a-zA-Z0-9]+\s){2}[0-9]+\s[0-9]\s*"

'''
Enter team information into the system

Takes in a string with the following syntax:
<Team A name> <Team A registration date in DD/MM> <Team A group number>
<Team B name> <Team B registration date in DD/MM> <Team B group number>
<Team C name> <Team C registration date in DD/MM> <Team C group number>

Returns a tuple of the following format:
message, statusCode
'''
def registerTeams(rawTeams):
    teamsStrings = rawTeams.split('\n')
    teams = []
    seenNames = set()
    for teamString in teamsStrings:
        # validate format of each entered team string
        if not re.fullmatch(TEAM_INFO_REGEX, teamString):
            return 'Invalid data format for team: ' + teamString, 400

        teamName, regDate, group = teamString.strip().split(' ')

        # validate date logic
        try:
            regDate = datetime.strptime(regDate, "%d/%m")
        except:
            return 'Invalid registration date: ' + str(regDate), 400
        
        # ensure teamname unique
        if teamName in seenNames:
            return 'Duplicate team name: ' + teamName, 400

        teams += [Team(teamName, regDate, int(group))]

    # commit updates
    if not data_access.addTeamsToDatabase(teams):
        return 'Database error', 500
        
    return 'Success', 200
        

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
message, statusCode
'''
def inputMatchResult(rawResults):
    teams = data_access.getTeams()
    toUpdate = {} # so we don't have to update teams that are not modified
    results = rawResults.split('\n')
    for result in results:
        # validate format of each entered result string
        if not re.fullmatch(MATCH_ENTRY_REGEX, result):
            return 'Invalid data format for result: ' + result, 400
        AName, BName, scoreA, scoreB = result.strip().split(' ')

        # check team registered
        if AName not in teams or BName not in teams:
            return 'Unregistered team present for result: ' + result, 400

        # update scores
        teamA, teamB = teams[AName], teams[BName]
        scoreA, scoreB = int(scoreA), int(scoreB)
        teamA, teamB = updateScores(teamA, teamB, scoreA, scoreB)
        teams[AName], teams[BName] = teamA, teamB
        toUpdate[AName], toUpdate[BName] = teamA, teamB

    # commit updates
    if not data_access.updateTeams(toUpdate.values()):
        return 'Database error', 500

    return 'Success', 200

'''
retrieves all teams currently registered, arranged according to ranking within the individual groups
ranking is based on Normal points > total goals > alt match points > earliest reg date
returns a dictionary of the following format:
{
    groupNumber: [teamA, teamB, ...],
    ...
}
'''
def getScoreboard():
    teams = data_access.getTeams()
    scoreboard = {}
    # split the teams into their groups
    for team in teams.values():
        scoreboard[team.group] = scoreboard.get(team.group, []) + [team]

    # sort the groups
    for group in scoreboard.keys():
        # Normal points > total goals > alt match points > earliest reg date
        # negation allows for sorting in descending order
        scoreboard[group].sort(key=lambda x: (-x.points, -x.goalsScored, -x.altPoints, x.regDate))
    
    return scoreboard
