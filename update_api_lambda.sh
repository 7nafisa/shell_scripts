#!/usr/bin/env bash
FUNCTIONNAME="${NCAA_API_LAMBDA:?You must set NCAA_API_LAMBDA environment variable with your lambda name.}"
NS_KEY="${NS_KEY:?You must set NS_KEY environment variable same as the Akamai Netstorage key.}"
rm -r ./build/*
cp -r ../src ./build/
cd ./build/src/
pip3.6 install -r requirements.txt -t .
zip -r api.zip . __init__.py

cat <<EOF > ./lambda_config.json
{
  "FunctionName": "$NCAA_API_LAMBDA",
  "Role": "arn:aws:iam::998656588450:role/service-role/nafisaRole",
  "Handler": "api.lambda_handler",
  "Description": "API for transcoded video links retrieval for TrueVR NCAA March Madness app.",
  "Timeout": 300,
  "MemorySize": 576,
  "Runtime": "python3.6",
  "Environment": {
    "Variables": {
      "loggerLevel": "debug",
      "S3_BUCKET": "nafisa-ncaa-output",
      "STORAGE_TYPE": "netstorage",
      "S3_BUCKET_PREFIX": "2018MarchMadness/",
      "NS_PREFIX": "/DEV/2018MarchMadness/",
      "NS_HOSTNAME": "mmlvr-nsu.akamaihd.net",
      "NS_KEYNAME": "mmlvrprod",
      "NS_CPCODE": "672507",
      "NS_KEY" : "$NS_KEY",
      "CDN_BASE_URL": "https://marchmadnessvrvod.akamaized.net"
    }
  }
}
EOF
aws lambda update-function-configuration --region us-west-2 --cli-input-json file://lambda_config.json
echo "Done with updating the lambda config."
aws lambda update-function-code --region us-west-2 --function-name $FUNCTIONNAME  --zip-file fileb://api.zip
echo "Done with updating the lambda code."
