public with sharing class SprintHeaderController {
  @AuraEnabled
  public static SprinterUtil.SprintWrapper getSprintById(String sprintId) {
    return SprinterUtil.getSprintByIdWrapped(sprintId);
  }
}
