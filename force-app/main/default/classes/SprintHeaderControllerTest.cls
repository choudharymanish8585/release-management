@isTest
public with sharing class SprintHeaderControllerTest {
  @TestSetup
  static void makeData() {
    List<SObject> sprints = SprinterTestFactory.getSprints();
  }

  @IsTest
  static void getSprintByIdPositive() {
    List<SObject> sprints = Database.query('Select Id From Sprint__c');
    Test.startTest();
    SprinterUtil.SprintWrapper sw = SprintHeaderController.getSprintById(
      sprints[0].Id
    );
    Test.stopTest();

    System.assert(sw != null, 'Sprint object is null');
    System.assertEquals(sw.id, sprints[0].id, 'Sprint Id does not match');
  }

  @IsTest
  static void getSprintByIdNegative1() {
    Test.startTest();
    SprinterUtil.SprintWrapper sw = SprintHeaderController.getSprintById(null);
    Test.stopTest();

    System.assert(sw == null, 'Invalid data found');
  }

  @IsTest
  static void getSprintByIdNegative2() {
    Test.startTest();
    SprinterUtil.SprintWrapper sw = SprintHeaderController.getSprintById(
      'test id'
    );
    Test.stopTest();

    System.assert(sw == null, 'Invalid data found');
  }
}
