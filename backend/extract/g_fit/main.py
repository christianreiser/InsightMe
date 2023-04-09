import google.auth
from google.auth.transport.requests import Request
from googleapiclient.discovery import build
from googleapiclient.errors import HttpError
import functions_framework
import google.oauth2.credentials as credentials
from requests_oauthlib import OAuth2Session

# backend
from oauthlib.oauth2 import BackendApplicationClient
from requests_oauthlib import OAuth2Session


# @functions_framework.cloud_event
def extract_g_fit(request):
    try:
        # Authenticate and build the Google Fit API client with oauth2client in python. don't use default credentials
        client_id = '1026153442309-bb3d0p1kspjtu0c0m0fakm7itvnd75ln.apps.googleusercontent.com'
        client_secret = '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'
        redirect_uri = 'https://app.insightme.org/'
        token_url = "https://www.googleapis.com/oauth2/v4/token"
        scopes = ['https://www.googleapis.com/auth/fitness.activity.read',
                  # 'https://www.googleapis.com/auth/fitness.activity.write',
                  'https://www.googleapis.com/auth/fitness.blood_glucose.read',
                  # 'https://www.googleapis.com/auth/fitness.blood_glucose.write',
                  'https://www.googleapis.com/auth/fitness.blood_pressure.read',
                  # 'https://www.googleapis.com/auth/fitness.blood_pressure.write',
                  'https://www.googleapis.com/auth/fitness.body.read',
                  # 'https://www.googleapis.com/auth/fitness.body.write',
                  'https://www.googleapis.com/auth/fitness.body_temperature.read',
                  # 'https://www.googleapis.com/auth/fitness.body_temperature.write',
                  'https://www.googleapis.com/auth/fitness.heart_rate.read',
                  # 'https://www.googleapis.com/auth/fitness.heart_rate.write',
                  'https://www.googleapis.com/auth/fitness.location.read',
                  # 'https://www.googleapis.com/auth/fitness.location.write',
                  'https://www.googleapis.com/auth/fitness.nutrition.read',
                  # 'https://www.googleapis.com/auth/fitness.nutrition.write',
                  'https://www.googleapis.com/auth/fitness.oxygen_saturation.read',
                  # 'https://www.googleapis.com/auth/fitness.oxygen_saturation.write',
                  'https://www.googleapis.com/auth/fitness.reproductive_health.read',
                  # 'https://www.googleapis.com/auth/fitness.reproductive_health.write',
                  'https://www.googleapis.com/auth/fitness.sleep.read',
                  # 'https://www.googleapis.com/auth/fitness.sleep.write',
                  ]

        # backend
        client = BackendApplicationClient(client_id=client_id)
        oauth = OAuth2Session(client=client)
        access_token = oauth.fetch_token(token_url=token_url, client_id=client_id, client_secret=client_secret, scope=scopes)

        # google_session = OAuth2Session(client_id, scope=scopes, redirect_uri=redirect_uri)
        #
        # # Redirect user to Google for authorization
        # authorization_url, state = google_session.authorization_url(
        #     'https://accounts.google.com/o/oauth2/auth',
        #     # offline for refresh token
        #     # force to always make user click authorize
        #     access_type="offline", prompt="select_account")
        # print('Please go here and authorize:', authorization_url)
        #
        # # Get the authorization verifier code from the callback url
        # redirect_response = input('Paste the full redirect URL here: ')
        #
        # # Fetch the access token
        # google_session.fetch_token(token_url, client_secret=client_secret, authorization_response=redirect_response)
        # access_token = google_session.token['access_token']
        credentials = google.oauth2.credentials.Credentials(access_token)

        # Build the Google Fit API client with the credentials
        service = build('fitness', 'v1', credentials=credentials)

        # get dataset
        result = service.users().dataSources().datasets().get(
            userId='me',
            dataSourceId='derived:com.google.step_count.delta:com.google.android.gms:merge_step_deltas',
            datasetId='1581072784000000000-1675957814000000000',
            limit=2
        ).execute()
        print(result)
        return result







    except HttpError as error:
        print(error)
        return error


result = extract_g_fit(None)
