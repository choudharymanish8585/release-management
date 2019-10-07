public with sharing class UserStoryListController {
    @AuraEnabled
    public static List<ReleaseManagementUtil.UserStoryWrapper> getUserStoriesBySprint(String sprintId){
        return ReleaseManagementUtil.getUserStoriesBySprintWrapped(sprintId);
    }
}
