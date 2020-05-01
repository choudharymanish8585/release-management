@isTest
public with sharing class UserStoryListControllerTest {
  @TestSetup
  static void makeData() {
    List<SObject> sprints = SprinterTestFactory.getSprints();
    List<SObject> userStories = SprinterTestFactory.getUserStories(sprints);
  }

  @IsTest
  static void testGetUserStoriesBySprint() {
    List<SObject> sprints = Database.query('Select Id From Sprint__c');
    Test.startTest();
    List<SprinterUtil.UserStoryWrapper> userStories = UserStoryListController.getUserStoriesBySprint(
      sprints[0].Id
    );
    Test.stopTest();
    System.assert(userStories != null, 'No user story found');
    System.assertEquals(
      1,
      userStories.size(),
      'User story size does not match'
    );
    System.assertEquals(
      sprints[0].Id,
      userStories[0].sprintId,
      'Invalid sprint id'
    );
  }

  @IsTest
  static void testGetUserStoriesBySprintNegative1() {
    Test.startTest();
    List<SprinterUtil.UserStoryWrapper> userStories = UserStoryListController.getUserStoriesBySprint(
      null
    );
    Test.stopTest();
    System.assert(userStories == null, 'Invalid release notes');
  }

  @IsTest
  static void testGetUserStoriesBySprintNegative2() {
    Test.startTest();
    List<SprinterUtil.UserStoryWrapper> userStories = UserStoryListController.getUserStoriesBySprint(
      'Test id'
    );
    Test.stopTest();
    System.assert(userStories == null, 'Invalid release notes');
  }
}
