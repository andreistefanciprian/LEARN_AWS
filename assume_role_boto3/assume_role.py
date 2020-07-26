import boto3
from boto3.session import Session
import sys

def assume_role(arn, session_name, region, external_id):
    """Assume AWS IAM Role"""

    client = boto3.client('sts')
    response = client.assume_role(RoleArn=arn, RoleSessionName=session_name, ExternalId=external_id)
    session = Session(aws_access_key_id=response['Credentials']['AccessKeyId'],
                      aws_secret_access_key=response['Credentials']['SecretAccessKey'],
                      aws_session_token=response['Credentials']['SessionToken'],
                      region_name=region)
    
    return session


if __name__ == "__main__":

    # define vars
    arn = sys.argv[1] if len(sys.argv) == 2 else sys.exit("AWS ARN Role has to be provided as positional parameter!")
    session_name = "funky_test"
    aws_region = "us-east-1"
    external_id = "Ciprian"

    # assume aws IAM role
    aws_role_session = assume_role(arn, session_name, aws_region, external_id)

    # get current assumed role UserId
    client = aws_role_session.client('sts')
    account_id = client.get_caller_identity()["UserId"]
    print(f'\nAssumed AWS IAM UserId: {account_id}')

    # get list of CodeBuild projects from AWS
    cb_client = aws_role_session.client('codebuild')
    codebuild_projects = cb_client.list_projects()
    print(codebuild_projects['projects'])