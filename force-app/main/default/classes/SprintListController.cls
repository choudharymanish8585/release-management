public with sharing class SprintListController {
  @AuraEnabled
  public static List<SprinterUtil.SprintWrapper> getFilteredSprints(
    String type,
    String timespan
  ) {
    return SprinterUtil.getFilteredSprintsWrapped(type, timespan);
  }
}
