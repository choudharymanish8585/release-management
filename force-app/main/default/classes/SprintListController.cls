public with sharing class SprintListController {

    @AuraEnabled(cacheable=true)
    public static List<ReleaseManagementUtil.SprintWrapper> getFilteredSprints(String type, String timespan){
        return  ReleaseManagementUtil.getFilteredSprintsWrapped(type, timespan);
    }
}
