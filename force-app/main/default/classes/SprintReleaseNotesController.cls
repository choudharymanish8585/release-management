public with sharing class SprintReleaseNotesController {
  @AuraEnabled
  public static SprinterUtil.ReleaseNotes getReleaseNotes(String sprintId) {
    return SprinterUtil.getReleaseNotesWrapped(sprintId);
  }
}
