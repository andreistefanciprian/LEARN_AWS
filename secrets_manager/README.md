
## Description

In this tutorial, we're building an AWS IAM secretsmanager Reader Role via terraform and we'll consume secrets via aws cli

### Create secretsmanager IAM Reader role via terraform

**Note:** Provide terraform container vars in .env file. Eg:
```
AWS_ACCESS_KEY_ID=""
AWS_SECRET_ACCESS_KEY=""
TF_VAR_aws_account=""
#TF_LOG=TRACE
```

Build IAM role:
```
# run terraform from container
make deploy-auto-approve TF_EXTRA_OPS="--var-file='vars.tfvars'" TF_TARGET=tf_code
make destroy-auto-approve TF_EXTRA_OPS="--var-file='vars.tfvars'" TF_TARGET=tf_code
```

### Assume secrets role

```
# define vars
region=""
aws_account=""

# Clear out existing AWS session environment, or the awscli call will fail
unset AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY AWS_SESSION_TOKEN AWS_SECURITY_TOKEN

# Assume AWS role
for aws_env_var in $(aws sts assume-role \
--role-arn arn:aws:iam::${aws_account}:role/secrets_role \
--role-session-name my_mac \
--output text \
--external-id smth \
--region $region \
--query 'Credentials.[[join(`=`,[`AWS_ACCESS_KEY_ID`, AccessKeyId])],[join(`=`,[`AWS_SECRET_ACCESS_KEY`, SecretAccessKey])],[join(`=`,[`AWS_SESSION_TOKEN`, SessionToken])]]'); \
do export $aws_env_var; done

# verify assumed role
aws sts get-caller-identity
```

### Use aws cli commands to interact with secretsmanager

```
# list secrets
aws secretsmanager list-secrets

# create secret
aws secretsmanager create-secret --name my_first_secret --description "First Secret" --secret-string S3@tt13R0cks

# describe secret
aws secretsmanager describe-secret --secret-id <SECRET-ARN>

# get secret value
aws secretsmanager get-secret-value --secret-id <SECRET-ARN>

# delete secret
aws secretsmanager delete-secret --secret-id <SECRET-ARN>
```