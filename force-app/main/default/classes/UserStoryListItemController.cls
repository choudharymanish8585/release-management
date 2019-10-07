public with sharing class UserStoryListItemController {
    @AuraEnabled
    public static List<ReleaseManagementUtil.UserStoryComponentWrapper> getComponentsByUserStory(String userStoryId){
        return ReleaseManagementUtil.getComponentsByUserStoryWrapped(userStoryId);
    }

    @AuraEnabled
    public static string updateUserStoryStatus(String status, String userStoryId){
        try{
            Schema.SObjectType sobjectType = ((Id)userStoryId).getSObjectType();
            SObject userStory = sobjectType.newSObject();
            userStory.Id = userStoryId;
            userStory.put('Status__c', status);
            return ReleaseManagementUtil.updateSObject(new List<SObject>{userStory});
        } catch(Exception e){
            ExceptionLogger.logException(e, UserStoryListController.class.getName(), true);
            return e.getMessage();
        }
    }
}
