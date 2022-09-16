'''
Used to define custom classes and formats of data
'''

'''
Defines a football team
'''
class Team:
    def __init__(self, teamName, regDate, group):
        self.teamName = teamName
        self.regDate = regDate
        self.group = group
        self.points = 0
        
        # used for breaking ties in group placement
        self.goalsScored = 0
        self.altPoints = 0