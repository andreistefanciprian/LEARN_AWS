
## Prerequsites

AWS ARN Role (eg: arn:aws:iam::1234567890:role/test-role) has to be provided as positional parameter!


## How to run script

```
# create python3 virtual env
python3 -m venv .venv

# activate environment
source .venv/bin/activate

# install requirements
pip install -r requirements.txt

# execute script
python3 assume_role.py arn:aws:iam::1234567890:role/test-role
```