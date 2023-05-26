# aws-s3-delete-objest-in-versioned-bucket

This shell script allows you to delete all objects and delete markers in an Amazon S3 bucket, followed by deleting the bucket itself.

## Prerequisites
Before running the script, make sure you have the following:

AWS CLI installed and configured with appropriate credentials.

## Script Usage
1. Open the script file in a text editor.

2. Set the value of the BUCKET_NAME variable to the name of the S3 bucket you want to delete.
BUCKET_NAME="my-bucket-name"

3. Run the script using the following command:
```bash
./script.sh
```

The script will perform the following steps:

1. Retrieve the list of all object versions and delete markers in the specified S3 bucket.

2. Extract the keys and version IDs of objects that are the latest versions.

3. Extract the keys and version IDs of delete markers.

4. Delete all objects by iterating through the object keys and version IDs and using the aws s3api delete-object command.

5. Delete all delete markers by iterating through the delete marker keys and version IDs and using the aws s3api delete-object command.

6. Finally, delete the S3 bucket using the aws s3 rb command.

**Note:** Deleting objects and delete markers is irreversible. Ensure that you have a backup or the necessary precautions before running this script.
