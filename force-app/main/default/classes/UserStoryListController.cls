public with sharing class UserStoryListController {
    @AuraEnabled
    public static List<SprinterUtil.UserStoryWrapper> getUserStoriesBySprint(String sprintId){
        return SprinterUtil.getUserStoriesBySprintWrapped(sprintId);
    }
}
