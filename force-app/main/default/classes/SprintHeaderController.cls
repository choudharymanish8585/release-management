public with sharing class SprintHeaderController {
  @AuraEnabled(cacheable=true)
  public static SprinterUtil.SprintWrapper getSprintById(String sprintId) {
    return SprinterUtil.getSprintByIdWrapped(sprintId);
  }
}
