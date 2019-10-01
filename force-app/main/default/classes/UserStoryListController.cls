public with sharing class UserStoryListController {
    @AuraEnabled
    public static List<ReleaseManagementUtil.UserStoryWrapper> getUserStoriesBySprint(String sprintId){
        return ReleaseManagementUtil.getUserStoriesBySprintWrapped(sprintId);
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
            ExceptionLogger.logException(e.getStackTraceString(), e.getMessage(), UserStoryListController.class.getName(), true);
            return e.getMessage();
        }
    }
}
