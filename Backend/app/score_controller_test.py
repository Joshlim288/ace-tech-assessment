import unittest
from unittest import mock
from score_controller import registerTeams


class SimpleTestCase(unittest.TestCase):
    @mock.patch('score_controller.data_access')
    def testRegisterValidTeams(self, mock_DAL):
        teamInput = 'teamA 01/04 1\nteamB 02/05 1\nteamC 03/06 1\nteamD 04/06 1\nteamE 05/06 1\nteamF 15/06 1\n\
            teamG 14/06 2\nteamH 13/06 2\nteamI 12/06 2\n teamJ 11/06 2\nteamK 10/06 2\nteamL 27/06 2'
        mock_DAL.commitTeamsToDatabase.return_value = True
        response = registerTeams(teamInput)
        assert response[0] == 200, "Valid input rejected with return value " + str(response)
    
    #TODO: test invalid inputs

if __name__ == "__main__":
    unittest.main()