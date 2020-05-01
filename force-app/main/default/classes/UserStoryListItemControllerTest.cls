@isTest
public with sharing class UserStoryListItemControllerTest {
  @TestSetup
  static void makeData() {
    List<SObject> sprints = SprinterTestFactory.getSprints();
    List<SObject> userStories = SprinterTestFactory.getUserStories(sprints);
    List<SObject> userStoryComponents = SprinterTestFactory.getUserStoryComponents(
      userStories
    );
  }

  @IsTest
  static void testGetComponentsByUserStory() {
    List<SObject> userStories = Database.query('Select Id From User_Story__c');
    Test.startTest();
    List<SprinterUtil.UserStoryComponentWrapper> userStoryComponents = UserStoryListItemController.getComponentsByUserStory(
      userStories[0].Id
    );
    Test.stopTest();
    System.assert(
      userStoryComponents != null,
      'No user story components found'
    );
    System.assertEquals(
      2,
      userStoryComponents.size(),
      'User Story Components size does not match'
    );
    System.assertEquals(
      userStories[0].Id,
      userStoryComponents[0].userStoryId,
      'User story id does not match'
    );
  }

  @IsTest
  static void testGetComponentsByUserStoryNegative1() {
    Test.startTest();
    List<SprinterUtil.UserStoryComponentWrapper> userStoryComponents = UserStoryListItemController.getComponentsByUserStory(
      null
    );
    Test.stopTest();
    System.assert(
      userStoryComponents == null,
      'Invalid user story components found'
    );
  }

  @IsTest
  static void testGetComponentsByUserStoryNegative2() {
    Test.startTest();
    List<SprinterUtil.UserStoryComponentWrapper> userStoryComponents = UserStoryListItemController.getComponentsByUserStory(
      'Test id'
    );
    Test.stopTest();
    System.assert(
      userStoryComponents == null,
      'Invalid user story components found'
    );
  }

  @IsTest
  static void testUpdateUserStoryStatus() {
    List<SObject> userStories = Database.query('Select Id From User_Story__c');
    Test.startTest();
    String result = UserStoryListItemController.updateUserStoryStatus(
      'Dev Started',
      userStories[0].Id
    );
    Test.stopTest();
    System.assertEquals('success', result, 'Record not updated');
  }

  @IsTest
  static void testUpdateUserStoryStatusNegative1() {
    Test.startTest();
    String result = UserStoryListItemController.updateUserStoryStatus(
      'Dev Started',
      null
    );
    Test.stopTest();
    System.assert(result != 'success', 'invalid operation');
  }

  @IsTest
  static void testUpdateUserStoryStatusNegative2() {
    Test.startTest();
    String result = UserStoryListItemController.updateUserStoryStatus(
      'Dev Started',
      'Test id'
    );
    Test.stopTest();
    System.assert(result != 'success', 'invalid operation');
  }

  @IsTest
  static void testUpdateUserStoryStatusNegative3() {
    List<SObject> userStories = Database.query('Select Id From User_Story__c');
    Test.startTest();
    String result = UserStoryListItemController.updateUserStoryStatus(
      'Test status',
      userStories[0].Id
    );
    Test.stopTest();
    System.assert(result != 'success', 'invalid operation');
  }
}
