## AWS CLI assume role scenario

```
# create IAM user
aws iam create-user --user-name test-user

# create policy
aws iam create-policy --policy-name test-policy --policy-document file://test-policy.json

# attach policy to user
aws iam attach-user-policy --user-name test-user --policy-arn arn:aws:iam::961857703676:policy/test-policy

# verify policy is attached to user
aws iam list-attached-user-policies --user-name test-user

# create access key and secret for IAM user
aws iam create-access-key --user-name test-user

# create IAM role that can be assumed by IAM user
aws iam create-role --role-name test-role --assume-role-policy-document file://test-role-trust-policy.json

# attach policy to role
aws iam attach-role-policy --role-name test-role --policy-arn "arn:aws:iam::aws:policy/AmazonS3FullAccess"

# verify policy was successfully attached to role
aws iam list-attached-role-policies --role-name test-role

# configure aws cli with access key and secret of test-user
aws configure

# verify test-user is configured
aws sts get-caller-identity

# verify you don't have access to s3
aws s3 ls

# assume role
aws sts assume-role --role-arn "arn:aws:iam::961857703676:role/test-role" --role-session-name jenkins --duration-seconds 900

aws iam list-roles 

# define env vars so current aws cli config use the assumed role credentials
export AWS_ACCESS_KEY_ID=
export AWS_SECRET_ACCESS_KEY=
export AWS_SESSION_TOKEN=

# verify you have access to s3
aws s3 ls

# verify new role is assumed
aws sts get-caller-identity

# return to previous aws cli configured IAM user, test-user
unset AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY AWS_SESSION_TOKEN
```