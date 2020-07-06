
## Run terraform with assume role

In this scenario were running terraform with assumed IAM role.

Terraform is configured to connect to AWS with IAM user credentials (tf-user). The IAM user has permission to work only with the dynamodb table and the s3 bucket used for managing the tfstate.
Once the IAM user (tf-user) is authorized, terraform will assume an IAM role with permission to build infrastructure in AWS (tf-role).

## Prerequisites

Have Docker installed. We'll run terraform from a docker container.
.env file with AWS credentials for IAM user (tf-user).


## Configure IAM user, IAM user policy and an IAM role
```
# create IAM user
aws iam create-user --user-name tf-user

# create policy
aws iam create-policy --policy-name tf-policy --policy-document file://policies/tf-user-policy.json

# attach policy to user
aws iam attach-user-policy --user-name tf-user --policy-arn arn:aws:iam::961857703676:policy/tf-policy

# verify policy is attached to user
aws iam list-attached-user-policies --user-name tf-user

# create access key and secret for IAM user (populate .env file with AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY, AWS_DEFAULT_REGION)
aws iam create-access-key --user-name tf-user

# create IAM role that can be assumed by IAM user
aws iam create-role --role-name tf-role --assume-role-policy-document file://policies/tf-role-trust-policy.json

# attach policy to role
aws iam attach-role-policy --role-name tf-role --policy-arn "arn:aws:iam::aws:policy/AdministratorAccess"

# verify policy was successfully attached to role
aws iam list-attached-role-policies --role-name tf-role
```

## Run terraform

.env file should be populated with tf-user IAM credentials (AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY, AWS_DEFAULT_REGION).
.env file will be used by terraform container to create the AWS creds environment variables.

```
make deploy-auto-approve
make destroy-auto-approve
```

## Other tf commands
```
docker-compose run terraform init
docker-compose run terraform plan -out terraform.tfplan
docker-compose run terraform apply terraform.tfplan
docker-compose run terraform destroy -auto-approve
```