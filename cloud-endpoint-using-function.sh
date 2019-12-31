# Reference (Big thanks to Guillaume Blaquiere!): https://medium.com/google-cloud/secure-cloud-run-cloud-functions-and-app-engine-with-api-key-73c57bededd1
# Google's official "Getting Started with Endpoints for Cloud Functions": https://cloud.google.com/endpoints/docs/openapi/get-started-cloud-functions

# This workflow requires the following files to be on the Cloud Shell system (if that's where you are running the code):
# 1. functions/index.js
# 2. endpoint-configuration.yaml

###################
#      System     #
###################
export PROJECT_ID=$(gcloud config get-value project)
# Customize if you want
export SERVICE_ACCOUNT=authendpoint-service-account
# Customize if you want
export REGION=europe-west1

###################
# Cloud Endpoints *
###################
# Customize if you want
export ENDPOINT_NAME=authendpoint

###################
# Cloud Functions #
###################
# Folder of function(s) to upload
export FUNCTIONS_FOLDER=functions
# Exported function name
export FUNCTION_HANDLER=helloWorld
# Will form part of the URL
export FUNCTION_NAME=helloWorld

# 1. Set default Cloud Run region just in case
gcloud config set run/region $REGION

# 2. Enables services; will in many cases become auto-enabled, so this is to ensure that anything necessary really is on
gcloud services enable servicemanagement.googleapis.com
gcloud services enable servicecontrol.googleapis.com
gcloud services enable endpoints.googleapis.com

# 3. Create new service account
gcloud beta iam service-accounts create $SERVICE_ACCOUNT

# 4. Add IAM policy bindings to the service account
gcloud projects add-iam-policy-binding $PROJECT_ID \
  --role=roles/servicemanagement.configEditor \
  --member serviceAccount:$SERVICE_ACCOUNT@$PROJECT_ID.iam.gserviceaccount.com

# 5. Deploy Cloud Endpoint on Cloud Run
gcloud beta run deploy $ENDPOINT_NAME \
  --image="gcr.io/endpoints-release/endpoints-runtime-serverless:2" \
  --allow-unauthenticated \
  --region $REGION \
  --platform managed \
  --service-account $SERVICE_ACCOUNT@$PROJECT_ID.iam.gserviceaccount.com

# Result: You will receive a URL like: https://endpoint-gktiwkghga-ew.a.run.app
# Set it below without the protocol part
export ENDPOINT_URL=

# 6. Deploy a Cloud Function
gcloud beta functions deploy $FUNCTION_NAME \
  --trigger-http \
  --runtime nodejs10 \
  --source $FUNCTIONS_FOLDER \
  --entry-point $FUNCTION_HANDLER \
  --region $REGION \
  --no-allow-unauthenticated

# Result: You will receive a URL like: https://europe-west1-cloud-developer-basics.cloudfunctions.net/helloWorld

# 7. Update endpoint-configuration.yaml
# > You need to provide the above URL that you received in the YAML file, under 'x-google-backend.address'
# > Make sure to also edit the values for 'host' (it will be the value you exported under ENDPOINT_URL)

# 8. Deploy the Cloud Endpoint service
gcloud endpoints services deploy endpoint-configuration.yaml

# 9. Update Cloud Endpoint with the new configuration from last step
gcloud beta run services update $ENDPOINT_NAME \
  --set-env-vars ENDPOINTS_SERVICE_NAME=$ENDPOINT_URL \
  --project $PROJECT_ID \
  --region $REGION \
  --platform managed

# 10. Enable the endpoint
gcloud services enable $ENDPOINT_URL

# 11. Authorize the gateway (Cloud Endpoint) to call Cloud Functions
gcloud projects add-iam-policy-binding $PROJECT_ID \
  --role=roles/cloudfunctions.invoker \
  --member serviceAccount:$SERVICE_ACCOUNT@$PROJECT_ID.iam.gserviceaccount.com

# 12. Create API key
# Unfortunately this has to be done manually...
# > Go to https://console.cloud.google.com/apis/credentials
# > Click 'Create credentials' --> 'API key'
# > Copy the key that is presented (example: AIzaSyBkYs3DM1FrT3atWwIQLaiKES6aP81A-GQ)
# > Click 'Restrict key'
# > Under 'API restrictions', choose your endpoint (will be same as under info.title in the configuration YAML file; default in this repo is 'Cloud Endpoints + GCF')
# > Export your key below
export API_KEY=

# 13. CURL your authenticated endpoint
curl https://$ENDPOINT_URL/$FUNCTION_NAME?key=$API_KEY