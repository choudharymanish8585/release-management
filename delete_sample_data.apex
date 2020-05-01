// Use the following to execute anonymous apex so you can delete the sample data if needed

//run below command to execute this script
//>> sfdx force:apex:execute -f delete_sample_data.apex

List<SObject> recordsToDelete = new List<SObject>();
List<SObject> userStoryComponents = Database.query('SELECT Id FROM User_Story_Component__c WHERE CreatedDate=TODAY');
recordsToDelete.addAll(userStoryComponents);

List<SObject> userStories = Database.query('SELECT Id FROM User_Story__c WHERE CreatedDate=TODAY');
recordsToDelete.addAll(userStories);

List<SObject> sprints = Database.query('SELECT Id FROM Sprint__c WHERE CreatedDate=TODAY');
recordsToDelete.addAll(sprints);

List<SObject> productTags = Database.query('SELECT Id FROM Product_Tag__c WHERE CreatedDate=TODAY');
recordsToDelete.addAll(productTags);

delete recordsToDelete;