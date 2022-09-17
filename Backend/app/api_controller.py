'''
Contains the API definitions to request data from the server
'''
# library imports
from flask import Flask, request, jsonify
from flask_cors import CORS

# project imports
import app.score_controller
from app.data_access import deleteTeams

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
    return score_controller.registerTeams(request.args.get('teams'))

'''
Add in a new set of results to the database
Sent data must be of the format:
{
    "results":"firstTeam secondTeam 0 3\nthirdTeam fourthTeam 1 1"
}
'''
@app.route("/results", methods=['POST'])
def enterResults():
    return score_controller.inputMatchResult(request.args.get('results'))

'''
Returns the current scoreboard for the competition
'''
@app.route("/scoreboard")
def getCurrentScoreboard():
    return jsonify(score_controller.getScoreboard())

'''
Removes all team data from the system
'''
@app.route("/reset")
def resetDatabase():
    deleteTeams()
    return "Success", 200