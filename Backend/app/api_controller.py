'''
Contains the API definitions to request data from the server
'''
# library imports
from flask import Flask, request, jsonify
from flask_cors import CORS

# project imports
from score_controller import *
from data_access import deleteTeams

app = Flask(__name__)
cors = CORS(app)

@app.route("/")
def landing_page():
    return "<p>Football scoreboard tracker API</p>"

'''
Add in a new set of teams to the database
Sent data must be of the format:
{
    "teams":"firstTeam 17/05 2\nsecondTeam 07/02 2\nthirdTeam 24/04 1"
}
'''
@app.route("/teams", methods=['POST'])
def addTeams():
    print(request)
    return registerTeams(request.json['teams'])

'''
Add in a new set of results to the database
Sent data must be of the format:
{
    "results":"firstTeam secondTeam 0 3\nthirdTeam fourthTeam 1 1"
}
'''
@app.route("/results", methods=['POST'])
def enterResults():
    return inputMatchResult(request.json['results'])

'''
Returns the current scoreboard for the competition
'''
@app.route("/scoreboard")
def getCurrentScoreboard():
    # we need to convert Team objects to dictionaries for JSON response
    convertedDict = {}
    for k, v in getScoreboard().items():
        convertedDict[k] = [team.toDoc() for team in v]
    return jsonify(convertedDict)

'''
Removes all team data from the system
'''
@app.route("/teams", methods=['DELETE'])
def resetDatabase():
    deleteTeams()
    return "Success", 200