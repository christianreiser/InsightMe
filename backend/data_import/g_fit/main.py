# import google.auth
# from google.auth.transport.requests import Request
# from googleapiclient.discovery import build
# from googleapiclient.errors import HttpError
# import functions_framework
# import google.oauth2.credentials as credentials
# from requests_oauthlib import OAuth2Session
#
# # backend
# from oauthlib.oauth2 import BackendApplicationClient
# from requests_oauthlib import OAuth2Session
#
#
# # @functions_framework.cloud_event
# def extract_g_fit(request):
#     try:
#         # Define the authorization endpoint and token endpoint URLs
#         # authorization_base_url = "https://accounts.google.com/o/oauth2/auth"
#         # token_url = "https://oauth2.googleapis.com/token"
#
#         # Authenticate and build the Google Fit API client with oauth2client
#         client_id = '1026153442309-bb3d0p1kspjtu0c0m0fakm7itvnd75ln.apps.googleusercontent.com'
#         client_secret = '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'
#         redirect_uri = 'https://app.insightme.org/'
#         token_url = "https://www.googleapis.com/oauth2/v4/token"
#         scopes = ['https://www.googleapis.com/auth/fitness.activity.read',
#                   'https://www.googleapis.com/auth/fitness.blood_glucose.read',
#                   'https://www.googleapis.com/auth/fitness.blood_pressure.read',
#                   'https://www.googleapis.com/auth/fitness.body.read',
#                   'https://www.googleapis.com/auth/fitness.body_temperature.read',
#                   'https://www.googleapis.com/auth/fitness.heart_rate.read',
#                   'https://www.googleapis.com/auth/fitness.location.read',
#                   'https://www.googleapis.com/auth/fitness.nutrition.read',
#                   'https://www.googleapis.com/auth/fitness.oxygen_saturation.read',
#                   'https://www.googleapis.com/auth/fitness.reproductive_health.read',
#                   'https://www.googleapis.com/auth/fitness.sleep.read',
#                   ]
#
#
#         google_session = OAuth2Session(client_id, scope=scopes, redirect_uri=redirect_uri)
#
#         # Redirect user to Google for authorization
#         authorization_url, state = google_session.authorization_url(
#             'https://accounts.google.com/o/oauth2/auth',
#             # offline for refresh token
#             # force to always make user click authorize
#             access_type="offline", prompt="select_account")
#         print('Please go here and authorize:', authorization_url)
#         # return authorization_url # todo remove this line
#
#         # Get the authorization verifier code from the callback url
#         redirect_response = input('Paste the full redirect URL here: ')
#
#         # Fetch the access token
#         google_session.fetch_token(token_url, client_secret=client_secret, authorization_response=redirect_response)
#         access_token = google_session.token['access_token']
#         credentials = google.oauth2.credentials.Credentials(access_token)
#
#         # Build the Google Fit API client with the credentials
#         service = build('fitness', 'v1', credentials=credentials)
#
#         # get dataset
#         result = service.users().dataSources().datasets().get(
#             userId='me',
#             dataSourceId='derived:com.google.step_count.delta:com.google.android.gms:merge_step_deltas',
#             datasetId='1581072784000000000-1675957814000000000',
#             limit=10000  # set the limit to the maximum allowable value
#         ).execute()
#         print(result)
#         return result
#
#     except HttpError as error:
#         print(error)
#         return error
#
#
# result = extract_g_fit(None)
#


# import requests
# access_token = 'ya29.a0Ael9sCPGMHbje7v22Tcbqu8swuzmxe1sH7LeSrWV8Wtz6DisLSU7jU83v3dKK63F7Nt49gd4YjOv9dAJrqBAwnyF3F9QjMTf1wycxERSFh7E-7--jjUua1T5ugegZq4R2H6TQZi6FY9eSlmhKhQ9TEZ9yIEYaCgYKAaESARMSFQF4udJhgc4rlkNyuTFMA_tsmoOMvA0163'
# url = 'https://www.googleapis.com/fitness/v1/users/me/dataSources/derived:com.google.step_count.delta:com.google.android.gms:merge_step_deltas/datasets/1581072784000000000-1675957814000000000?limit=10000'
# headers = {'Authorization': f'Bearer {access_token}'}
#
#
# response = requests.get(url, headers=headers)
# print(response.json())


import requests
from flask import Flask, request, jsonify

app = Flask(__name__)

@app.route('/get_data', methods=['POST'])
def get_data():
    data = request.get_json()
    access_token = data.get('access_token')

    url = 'https://www.googleapis.com/fitness/v1/users/me/dataSources/derived:com.google.step_count.delta:com.google.android.gms:merge_step_deltas/datasets/1581072784000000000-1675957814000000000?limit=10000'
    headers = {'Authorization': f'Bearer {access_token}'}

    response = requests.get(url, headers=headers)

    return jsonify(response.json())

if __name__ == '__main__':
    app.run()
