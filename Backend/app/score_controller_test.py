'''
Unit tests for score_controller.py
'''

import unittest
from unittest import mock
from string import ascii_uppercase
from data_definition import Team
from score_controller import registerTeams, inputMatchResult
from datetime import datetime

class ScoreControllerCase(unittest.TestCase):
    @mock.patch('score_controller.data_access')
    def testRegisterValidTeams(self, mock_DAL):
        # setup mock data access layer
        mock_DAL.commitTeamsToDatabase.return_value = True

        teamInput = 'teamA 01/04 1\nteamB 02/05 1\nteamC 03/06 1\nteamD 04/06 1\nteamE 05/06 1\nteamF 15/06 1\n\
            teamG 14/06 2\nteamH 13/06 2\nteamI 12/06 2\n teamJ 11/06 2\nteamK 10/06 2\nteamL 27/06 2'        
        response = registerTeams(teamInput)
        assert response[0] == 200, "Valid input rejected with return value " + str(response)
    
    @mock.patch('score_controller.data_access')
    def testRegisterValidMatch(self, mock_DAL):
        # setup mock data access layer
        mock_DAL.getTeams.return_value = {'team'+i: Team('team'+i, datetime.now(), 0) for i in ascii_uppercase}
        mock_DAL.updateTeams.return_value = True

        matchInput = 'teamA teamB 0 1\nteamA teamC 1 3\nteamA teamD 2 2\nteamA teamE 2 4\nteamA teamF 3 3\nteamB teamC 0 1\nteamB teamD 2 2\nteamB teamE 4 0\n\
        teamB teamF 0 0\nteamC teamD 2 0\nteamC teamE 0 0\nteamC teamF 1 0\nteamD teamE 0 3\nteamD teamF 2 1\nteamE teamF 3 4\nteamG teamH 3 2\nteamG teamI 0 4\n\
        teamG teamJ 1 0\nteamG teamK 1 4\nteamG teamL 1 4\nteamH teamI 2 0\nteamH teamJ 3 0\nteamH teamK 3 4\nteamH teamL 0 1\nteamI teamJ 2 1\nteamI teamK 3 0\n\
        teamI teamL 1 3\nteamJ teamK 1 4\nteamJ teamL 0 3\nteamK teamL 0 0'
        response = inputMatchResult(matchInput)
        assert response[0] == 200, "Valid input rejected with return value " + str(response)

    #TODO: test invalid inputs

if __name__ == "__main__":
    unittest.main()