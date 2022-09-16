'''
SCORE CONTROLLER
Contains the main business logic for the application
'''
# library imports
import re
from datetime import datetime

# project imports
from data_definition import Team
from data_access import commitTeamsToDatabase

# Constants
TEAM_INFO_REGEX = "[a-zA-Z0-9]+\s[0-9]{2}\/[0-9]{2}\s[0-9]+"
MATCH_ENTRY_REGEX = "(([a-zA-Z0-9]+\s){2}([0-9]+\s){2})"

'''
Enter team information into the system
Takes in a string with the following syntax:
<Team A name> <Team A registration date in DD/MM> <Team A group number>
<Team B name> <Team B registration date in DD/MM> <Team B group number>
<Team C name> <Team C registration date in DD/MM> <Team C group number>

Returns a tuple of the following format:
(Status code, message)
'''
def registerTeams(rawInput):
    teamsStrings = rawInput.split('\n')
    teams = []
    seenNames = set()
    for teamString in teamsStrings:
        # validate format of each entered team string
        if not re.fullmatch(TEAM_INFO_REGEX, teamString):
            return (400, 'Invalid data format')

        teamName, regDate, group = teamString.split(' ')
        
        # validate date logic
        try:
            regDate = datetime.strptime(regDate, "%d/%m")
        except:
            return (400, 'Invalid registration date ', regDate)
        
        # ensure teamname unique
        if teamName in seenNames:
            return (400, 'Duplicate team name ', teamName)

        teams += [Team(teamName, regDate, group)]

    # all teams valid
    commitTeamsToDatabase(teams)
    return (200, 'Success')
    
