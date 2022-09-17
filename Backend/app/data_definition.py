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
    
    '''
    converts a Team object into a document object for mongoDB storage
    '''
    def toDoc(self):
        doc = {
            '_id': self.teamName, # convert teamName to be the id to ensure they're unique
            'regDate': self.regDate,
            'group': self.group,
            'points': self.points,
            'goalsScored': self.goalsScored,
            'altPoints': self.altPoints
        }
        return doc
    
    '''
    converts a team document object from mongoDB back into a Team object
    '''
    def fromDoc(teamDoc):
        team = Team(teamDoc['_id'], teamDoc['regDate'], teamDoc['group'])
        team.points = teamDoc['points']
        team.goalsScored = teamDoc['goalsScored']
        team.altPoints = teamDoc['altPoints']
        return team