public with sharing class SprintHeaderController {
    @AuraEnabled(cacheable=true)
    public static ReleaseManagementUtil.SprintWrapper getSprintById(String sprintId){
        List<ReleaseManagementUtil.SprintWrapper> sprints = ReleaseManagementUtil.getSprintByIdWrapped(sprintId);
        if(sprints != null && sprints.size() > 0){
            return sprints[0];
        }
        return null;
    }
}
