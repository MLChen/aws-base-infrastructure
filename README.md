## Plan

```
AWS_PROFILE={your_aws_profile} terraform plan -state=state/{aws_account}/region/{region}/terraform.tfstate -backup=state/{aws_account}/region/{region}/terraform.tfstate.backup
```

### Example
```
AWS_PROFILE=ecowork terraform plan -state=state/ecowork/region/ap-northeast-1/terraform.tfstate -backup=state/ecowork/region/ap-northeast-1/terraform.tfstate.backup
```

## Apply

```
AWS_PROFILE={your_aws_profile} terraform apply -state=state/{aws_account}/region/{region}/terraform.tfstate -backup=state/{aws_account}/region/{region}/terraform.tfstate.backup
```
### Example
```
AWS_PROFILE=ecowork terraform apply -state=state/ecowork/region/ap-northeast-1/terraform.tfstate -backup=state/ecowork/region/ap-northeast-1/terraform.tfstate.backup
```
