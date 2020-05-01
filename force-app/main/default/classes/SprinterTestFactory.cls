public with sharing class SprinterTestFactory {
  public static List<SObject> getSprints() {
    List<SObject> sprints = new List<SObject>();
    SObject sprint1 = (Sobject) Type.forName('Sprint__c').newInstance();
    sprint1.put('Title__c', '2017.06-r1');
    sprint1.put('Release_Date__c', Date.newInstance(2017, 6, 8));
    sprint1.put('SIT_Date__c', Date.newInstance(2017, 6, 7));
    sprint1.put('UAT_Date__c', Date.newInstance(2017, 6, 6));
    sprint1.put('Type__c', 'Stable');
    sprint1.put('Status__c', 'On Track');
    sprint1.put(
      'Description__c',
      'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor i'
    );
    sprints.add(sprint1);

    SObject sprint2 = (Sobject) Type.forName('Sprint__c').newInstance();
    sprint2.put('Title__c', '2019.09-r1');
    sprint2.put('Release_Date__c', Date.newInstance(2019, 9, 5));
    sprint2.put('SIT_Date__c', Date.newInstance(2019, 9, 4));
    sprint2.put('UAT_Date__c', Date.newInstance(2019, 9, 4));
    sprint2.put('Type__c', 'Stable');
    sprint2.put('Status__c', 'Completed');
    sprint2.put(
      'Description__c',
      'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor i'
    );
    sprints.add(sprint2);

    SObject sprint3 = (Sobject) Type.forName('Sprint__c').newInstance();
    sprint3.put('Title__c', '2019.09-r4');
    sprint3.put('Release_Date__c', Date.today().addDays(-100));
    sprint3.put('SIT_Date__c', Date.today().addDays(-100));
    sprint3.put('UAT_Date__c', Date.today().addDays(-100));
    sprint3.put('Type__c', 'Beta');
    sprint3.put('Status__c', 'On Track');
    sprint3.put(
      'Description__c',
      'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor i'
    );
    sprints.add(sprint3);

    SObject sprint4 = (Sobject) Type.forName('Sprint__c').newInstance();
    sprint4.put('Title__c', '2018-09-r1');
    sprint4.put('Release_Date__c', Date.today().addDays(-10));
    sprint4.put('SIT_Date__c', Date.today().addDays(-10));
    sprint4.put('UAT_Date__c', Date.today().addDays(-10));
    sprint4.put('Type__c', 'Emergency');
    sprint4.put('Status__c', 'On Track');
    sprint4.put(
      'Description__c',
      'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor i'
    );
    sprints.add(sprint4);

    SObject sprint5 = (Sobject) Type.forName('Sprint__c').newInstance();
    sprint5.put('Title__c', '2019.07-r1');
    sprint5.put('Release_Date__c', Date.today());
    sprint5.put('SIT_Date__c', Date.today());
    sprint5.put('UAT_Date__c', Date.today());
    sprint5.put('Type__c', 'Stable');
    sprint5.put('Status__c', 'On Track');
    sprint5.put(
      'Description__c',
      'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor i'
    );
    sprints.add(sprint5);

    SObject sprint6 = (Sobject) Type.forName('Sprint__c').newInstance();
    sprint6.put('Title__c', '2020.01-r1');
    sprint6.put('Release_Date__c', Date.today().addDays(2));
    sprint6.put('SIT_Date__c', Date.today().addDays(2));
    sprint6.put('UAT_Date__c', Date.today().addDays(2));
    sprint6.put('Type__c', 'Stable');
    sprint6.put('Status__c', 'On Track');
    sprint6.put(
      'Description__c',
      'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor i'
    );
    sprints.add(sprint6);

    insert sprints;
    return sprints;
  }

  public static List<SObject> getUserStories(List<SObject> sprints) {
    List<SObject> userStories = new List<SObject>();
    for (sObject sprint : sprints) {
      //process record here
      SObject ustory1 = (Sobject) Type.forName('User_Story__c').newInstance();
      ustory1.put(
        'Name',
        'Remove "Host list too long. See attached hostlist.json"'
      );
      ustory1.put(
        'Patch_Notes__c',
        'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.'
      );
      ustory1.put('Sprint__c', sprint.Id);
      ustory1.put('Status__c', 'Delivered');
      ustory1.put('Work_Item__c', 'W-6523479');
      ustory1.put('Type__c', 'Feature Request');
      userStories.add(ustory1);
    }
    insert userStories;
    return userStories;
  }

  public static List<SObject> getUserStoryComponents(
    List<SObject> userStories
  ) {
    List<SObject> userStoryComponents = new List<SObject>();
    for (sObject userStory : userStories) {
      //process record here
      SObject ustoryComp1 = (Sobject) Type.forName('User_Story_Component__c')
        .newInstance();
      ustoryComp1.put('Api_Name__c', 'TestClass');
      ustoryComp1.put('Change_Type__c', 'New');
      ustoryComp1.put('Metadata_Type__c', 'ApexClass');
      ustoryComp1.put('User_Story__c', userStory.Id);
      userStoryComponents.add(ustoryComp1);

      SObject ustoryComp2 = (Sobject) Type.forName('User_Story_Component__c')
        .newInstance();
      ustoryComp2.put('Api_Name__c', 'RMAHub');
      ustoryComp2.put('Change_Type__c', 'Update');
      ustoryComp2.put('Metadata_Type__c', 'AuraDefinitionBundle');
      ustoryComp2.put('User_Story__c', userStory.Id);
      userStoryComponents.add(ustoryComp2);
    }
    insert userStoryComponents;
    return userStoryComponents;
  }
}
