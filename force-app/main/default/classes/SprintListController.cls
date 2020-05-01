public with sharing class SprintListController {

    @AuraEnabled(cacheable=true)
    public static List<SprinterUtil.SprintWrapper> getFilteredSprints(String type, String timespan){
        return  SprinterUtil.getFilteredSprintsWrapped(type, timespan);
    }
}
