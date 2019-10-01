public with sharing class SprintReleaseNotesController {
    @AuraEnabled(cacheable=true)
    public static ReleaseManagementUtil.ReleaseNotes getReleaseNotes(String sprintId){
        return ReleaseManagementUtil.getReleaseNotesWrapped(sprintId);
    }
}
