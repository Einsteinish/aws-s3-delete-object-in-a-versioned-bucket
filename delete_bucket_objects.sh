#!/bin/bash

BUCKET_NAME="my-bucket-name"

# Get the list of all object versions and delete markers
OBJECT_VERSIONS=$(aws s3api list-object-versions --bucket $BUCKET_NAME --output json)

# Extract the keys and version IDs of objects
OBJECT_KEYS=$(echo $OBJECT_VERSIONS | jq -r '.Versions[] | select(.IsLatest == true) | .Key')
VERSION_IDS=$(echo $OBJECT_VERSIONS | jq -r '.Versions[] | select(.IsLatest == true) | .VersionId')

# Extract the keys and version IDs of delete markers
DELETE_MARKER_KEYS=$(echo $OBJECT_VERSIONS | jq -r '.DeleteMarkers[].Key')
DELETE_MARKER_VERSION_IDS=$(echo $OBJECT_VERSIONS | jq -r '.DeleteMarkers[].VersionId')

# Delete all objects
for i in $(seq 0 $(expr $(echo $OBJECT_KEYS | wc -w) - 1)); do
  OBJECT_KEY=$(echo $OBJECT_KEYS | awk -v i=$i '{print $i}')
  VERSION_ID=$(echo $VERSION_IDS | awk -v i=$i '{print $i}')
  aws s3api delete-object --bucket $BUCKET_NAME --key "$OBJECT_KEY" --version-id "$VERSION_ID"
done

Delete all delete markers
for i in $(seq 0 $(expr $(echo $DELETE_MARKER_KEYS | wc -w) - 1)); do
  DELETE_MARKER_KEY=$(echo $DELETE_MARKER_KEYS | awk -v i=$i '{print $i}')
  DELETE_MARKER_VERSION_ID=$(echo $DELETE_MARKER_VERSION_IDS | awk -v i=$i '{print $i}')
  aws s3api delete-object --bucket $BUCKET_NAME --key "$DELETE_MARKER_KEY" --version-id "$DELETE_MARKER_VERSION_ID"
done

# Delete the bucket
aws s3 rb s3://$BUCKET_NAME
