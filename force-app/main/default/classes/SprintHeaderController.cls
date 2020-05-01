public with sharing class SprintHeaderController {
    @AuraEnabled(cacheable=true)
    public static SprinterUtil.SprintWrapper getSprintById(String sprintId){
        List<SprinterUtil.SprintWrapper> sprints = SprinterUtil.getSprintByIdWrapped(sprintId);
        if(sprints != null && sprints.size() > 0){
            return sprints[0];
        }
        return null;
    }
}
