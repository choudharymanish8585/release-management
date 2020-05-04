## Script starts from here

# Create New Directory
printf "\nSTEP 1 : Create new directory\n"
mkdir $(date +'%Y%m%d')
cd $(date +'%Y%m%d')

# Clone github repo 
printf "\nSTEP 2 : Clone github repo\n"
git clone https://github.com/choudharymanish8585/release-management.git
cd release-management

# Authorize Dev Hub
# Create Connected App and Authorize automatically

# Create Scratch Org with current date as alias 
printf "\nSTEP 3 : Creating scratch org\n"
sfdx force:org:create --setdefaultusername --definitionfile config/project-scratch-def.json --setalias "RM$(date +'%Y%m%d')" --wait 10 --durationdays 30

# Push all source to scratch org
printf "\nSTEP 4 : Pushing metadata to org\n"
sfdx force:source:push 

# Assign permission set to user
printf "\nSTEP 5 : Assigning Permission Set\n"
sfdx force:user:permset:assign -n Release_Management

# Upload Sample Data
printf "\nSTEP 6 : Uploading Sample Data\n"
sfdx force:data:tree:import --plan sample-data/import-plan.json

# Open Scratch Org
printf "\nSTEP 7 : Open Scratch Org\n"
sfdx force:org:open

# Package Create
# sfdx force:package:create --name Sprint360 --description "Sprint360 Version 1" --packagetype Unlocked --path force-app --nonamespace --targetdevhubusername RMDevHub
# Package version create (withou installation key)
# sfdx force:package:version:create -p Sprint360 -d force-app --wait 10 -v RMDevHub -x