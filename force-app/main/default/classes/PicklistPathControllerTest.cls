@isTest
public with sharing class PicklistPathControllerTest {
  @IsTest
  static void getPicklistValuesPositive() {
    Test.startTest();
    //below list should have results from status field on user story object
    List<PicklistPathController.PicklistItem> picklistItems = PicklistPathController.getPicklistValues(
      'User_Story__c',
      'Status__c'
    );
    Test.stopTest();
    System.assert(picklistItems != null, 'No picklist values found');
    System.assert(picklistItems.size() > 0, 'No picklist values found');
  }

  @IsTest
  static void getPicklistValuesNegative1() {
    Test.startTest();
    //below list should have 0 results as no test__c field on user story object
    List<PicklistPathController.PicklistItem> picklistItems = PicklistPathController.getPicklistValues(
      'User_Story__c',
      'Test_Test__c'
    );
    Test.stopTest();
    System.assert(picklistItems == null, 'Incorrect data found');
  }

  @IsTest
  static void getPicklistValuesNegative2() {
    Test.startTest();
    List<PicklistPathController.PicklistItem> picklistItems = PicklistPathController.getPicklistValues(
      'Test_Test__c',
      'Test_Test__c'
    );
    Test.stopTest();
    System.assert(picklistItems == null, 'Incorrect data found');
  }
}
