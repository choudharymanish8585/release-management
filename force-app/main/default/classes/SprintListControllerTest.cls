@isTest
public with sharing class SprintListControllerTest {
  @TestSetup
  static void makeData() {
    List<SObject> sprints = SprinterTestFactory.getSprints();
  }

  @IsTest
  static void getFilteredSprints1() {
    String timespan = 'last20';
    String type = 'all';

    Test.startTest();
    List<SprinterUtil.SprintWrapper> sws = SprintListController.getFilteredSprints(
      type,
      timespan
    );
    Test.stopTest();
    System.assert(sws != null, 'No sprint found');
    System.assert(sws.size() > 0, 'No sprint found');
  }

  @IsTest
  static void getFilteredSprints2() {
    String timespan = 'upcoming';
    String type = 'stable';

    Test.startTest();
    List<SprinterUtil.SprintWrapper> sws = SprintListController.getFilteredSprints(
      type,
      timespan
    );
    Test.stopTest();
    System.assert(sws != null, 'No sprint found');
    System.assert(sws.size() > 0, 'No sprint found');
  }

  @IsTest
  static void getFilteredSprints3() {
    String timespan = 'sixmonths';
    String type = 'beta';

    Test.startTest();
    List<SprinterUtil.SprintWrapper> sws = SprintListController.getFilteredSprints(
      type,
      timespan
    );
    Test.stopTest();
    System.assert(sws != null, 'No sprint found');
    System.assert(sws.size() > 0, 'No sprint found');
  }

  @IsTest
  static void getFilteredSprints4() {
    String timespan = 'onemonth';
    String type = 'emergency';

    Test.startTest();
    List<SprinterUtil.SprintWrapper> sws = SprintListController.getFilteredSprints(
      type,
      timespan
    );
    Test.stopTest();
    System.assert(sws != null, 'No sprint found');
    System.assert(sws.size() > 0, 'No sprint found');
  }

  @IsTest
  static void getFilteredSprints5() {
    String timespan = '2019';
    String type = 'all';

    Test.startTest();
    List<SprinterUtil.SprintWrapper> sws = SprintListController.getFilteredSprints(
      type,
      timespan
    );
    Test.stopTest();
    System.assert(sws != null, 'No sprint found');
    System.assert(sws.size() > 0, 'No sprint found');
  }

  @IsTest
  static void getFilteredSprintsNegative1() {
    String timespan = '';
    String type = '';

    Test.startTest();
    List<SprinterUtil.SprintWrapper> sws = SprintListController.getFilteredSprints(
      type,
      timespan
    );
    Test.stopTest();
    System.assert(sws != null, 'No sprint found');
    System.assert(sws.size() > 0, 'No sprint found');
  }

  @IsTest
  static void getFilteredSprintsNegative2() {
    String timespan = '2010';
    String type = 'abcd';

    Test.startTest();
    List<SprinterUtil.SprintWrapper> sws = SprintListController.getFilteredSprints(
      type,
      timespan
    );
    Test.stopTest();
    System.assert(sws == null, 'No sprint found');
  }

  @IsTest
  static void getFilteredSprintsNegative3() {
    String timespan = '';
    String type = '0';

    Test.startTest();
    List<SprinterUtil.SprintWrapper> sws = SprintListController.getFilteredSprints(
      type,
      timespan
    );
    Test.stopTest();
    System.assert(sws != null, 'No sprint found');
    System.assert(sws.size() > 0, 'No sprint found');
  }
}
