echo "please provide terraform workspace"
read tfwf
TERRAFORM_PATH="/mnt/c/ProgramData/chocolatey/bin/terraform.exe"
$TERRAFORM_PATH workspace new $tfwf
$TERRAFORM_PATH workspace select $tfwf
current_tfwsp=$($TERRAFORM_PATH workspace show)
$TERRAFORM_PATH init -backend-config=dev.conf
$TERRAFORM_PATH plan -var-file=${current_tfwsp}.tfvars
echo "do you want apply the infra ? (yes) to continue"
read tfapply
if [[ $tfapply == "yes" ]]; then 
    $TERRAFORM_PATH apply -var-file=envs/${current_tfwsp}.tfvars
    echo "Please follow the terminal output to verify the result of infrastructure provisioning."
else
    echo "Cancel apply for infra"
fi