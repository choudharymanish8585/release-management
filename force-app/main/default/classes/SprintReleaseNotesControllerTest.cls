@isTest
public with sharing class SprintReleaseNotesControllerTest {
  @TestSetup
  static void makeData() {
    List<SObject> sprints = SprinterTestFactory.getSprints();
    List<SObject> userStories = SprinterTestFactory.getUserStories(sprints);
  }

  @IsTest
  static void getReleaseNotes() {
    List<SObject> sprints = Database.query('Select Id From Sprint__c');
    Test.startTest();
    SprinterUtil.ReleaseNotes releaseNotes = SprintReleaseNotesController.getReleaseNotes(
      sprints[0].Id
    );
    Test.stopTest();
    System.assert(releaseNotes != null, 'Release notes are null');
    System.assertEquals(releaseNotes.sprint.id, sprints[0].Id);
    System.assert(releaseNotes.userStories != null, 'No user story in sprint');
    System.assertEquals(
      1,
      releaseNotes.userStories.size(),
      'User story size does not match'
    );
  }

  @IsTest
  static void getReleaseNotesNegative1() {
    Test.startTest();
    SprinterUtil.ReleaseNotes releaseNotes = SprintReleaseNotesController.getReleaseNotes(
      null
    );
    Test.stopTest();
    System.assert(releaseNotes == null, 'Invalid release notes');
  }

  @IsTest
  static void getReleaseNotesNegative2() {
    Test.startTest();
    SprinterUtil.ReleaseNotes releaseNotes = SprintReleaseNotesController.getReleaseNotes(
      'test id'
    );
    Test.stopTest();
    System.assert(releaseNotes == null, 'Invalid release notes');
  }
}
