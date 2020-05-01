public with sharing class SprintReleaseNotesController {
    @AuraEnabled(cacheable=true)
    public static SprinterUtil.ReleaseNotes getReleaseNotes(String sprintId){
        return SprinterUtil.getReleaseNotesWrapped(sprintId);
    }
}
