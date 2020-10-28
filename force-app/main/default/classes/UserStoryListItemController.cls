public with sharing class UserStoryListItemController {
  @AuraEnabled
  public static List<SprinterUtil.UserStoryComponentWrapper> getComponentsByUserStory(
    String userStoryId
  ) {
    return SprinterUtil.getComponentsByUserStoryWrapped(userStoryId);
  }

  @AuraEnabled
  public static string updateUserStoryStatus(
    String status,
    String userStoryId
  ) {
    try {
      Schema.SObjectType sobjectType = ((Id) userStoryId).getSObjectType();
      SObject userStory = sobjectType.newSObject();
      userStory.Id = userStoryId;
      userStory.put('Status__c', status);
      return SprinterUtil.updateSObject(new List<SObject>{ userStory });
    } catch (Exception e) {
      ExceptionLogger.logException(
        e,
        UserStoryListController.class.getName(),
        true
      );
      return e.getMessage();
    }
  }

  @AuraEnabled
  public static SprinterUtil.UserStoryWrapper getUserStoryById(
    String userStoryId
  ) {
    return SprinterUtil.getUserStoryByIdWrapped(userStoryId);
  }
}
