public with sharing class SprinterUtil {
  /**
   * get org base url
   */
  @AuraEnabled(cacheable=true)
  public static String getBaseUrl() {
    return URL.getSalesforceBaseUrl().toExternalForm();
  }

  /**
   * Get all sprints
   * Max limit is 2000
   */
  /* public static List<SObject> getAllSprints() {
    try {
      String query =
        'SELECT Id, ' +
        'Name, ' +
        'Title__c, ' +
        'Description__c, ' +
        'Release_Date__c, ' +
        'SIT_Date__c, ' +
        'UAT_Date__c, ' +
        'Status__c, ' +
        'Type__c, ' +
        'Number_User_Stories__c, ' +
        'OwnerId, ' +
        'Owner.Name ' +
        'FROM Sprint__c ' +
        'ORDER BY Release_Date__c DESC ' +
        'LIMIT 2000';
      return Database.query(query);
    } catch (Exception e) {
      ExceptionLogger.logException(e, SprinterUtil.class.getName(), true);
      return null;
    }
  } */

  /**
   * Get all sprints wrapped
   * Max limit is 2000
   */
  /* public static List<SprintWrapper> getAllSprintsWrapped() {
    List<SObject> sprintObjs = SprinterUtil.getAllSprints();
    return SprinterUtil.wrapSprints(sprintObjs);
  } */

  /**
   * Get a sprint record based on record id
   * @param sprintId
   * Max limit is 2000
   */
  public static SObject getSprintById(String sprintId) {
    if (sprintId != null)
      sprintId = String.escapeSingleQuotes(sprintId);
    try {
      String query =
        'SELECT Id, ' +
        'Name, ' +
        'Title__c, ' +
        'Description__c, ' +
        'Release_Date__c, ' +
        'SIT_Date__c, ' +
        'UAT_Date__c, ' +
        'Status__c, ' +
        'Type__c, ' +
        'Number_User_Stories__c, ' +
        'OwnerId, ' +
        'Owner.Name ' +
        'FROM Sprint__c ' +
        'WHERE Id= :sprintId ' +
        'ORDER BY Release_Date__c DESC ' +
        'LIMIT 2000';
      List<SObject> sprints = Database.query(query);
      if (sprints != null && sprints.size() > 0)
        return sprints[0];
      else
        return null;
    } catch (Exception e) {
      ExceptionLogger.logException(e, SprinterUtil.class.getName(), true);
      return null;
    }
  }

  /**
   * Get a wrapped sprint record based on record id
   * @param sprintId
   * Max limit is 2000
   */
  public static SprintWrapper getSprintByIdWrapped(String sprintId) {
    SObject sprintObj = SprinterUtil.getSprintById(sprintId);
    if (sprintObj != null) {
      return SprinterUtil.wrapSprints(new List<SObject>{ sprintObj })[0];
    }
    return null;
  }

  /**
   * Get sprint record filtered by type and timespan
   * @param {type} sprint type
   * @param {timespan} timespan or duratio fo release dates
   * Max limit is 2000
   */
  public static List<SObject> getFilteredSprints(String type, String timespan) {
    type = String.escapeSingleQuotes(type);
    timespan = String.escapeSingleQuotes(timespan);
    try {
      String query =
        'SELECT Id, ' +
        'Name, ' +
        'Title__c, ' +
        'Description__c, ' +
        'Release_Date__c, ' +
        'SIT_Date__c, ' +
        'UAT_Date__c, ' +
        'Status__c, ' +
        'Type__c,' +
        'Number_User_Stories__c, ' +
        'OwnerId, ' +
        'Owner.Name ' +
        'FROM Sprint__c ';

      String filters = '';
      //add type filter
      if (String.isNotEmpty(type) && type != 'all') {
        switch on type {
          when 'stable' {
            filters += ' WHERE Type__c=\'Stable\' ';
          }
          when 'beta' {
            filters += ' WHERE Type__c=\'Beta\' ';
          }
          when 'emergency' {
            filters += ' WHERE Type__c=\'Emergency\' ';
          }
        }
      }

      //add timespan filter
      if (String.isNotEmpty(timespan) && timespan != 'last20') {
        if (filters.contains('WHERE')) {
          filters += ' AND ';
        } else {
          filters = ' WHERE ';
        }
        switch on timespan {
          when 'upcoming' {
            filters += ' Release_Date__c>TODAY ';
          }
          when 'onemonth' {
            filters += ' Release_Date__c=LAST_N_DAYS:30 ';
          }
          when 'sixmonths' {
            filters += ' Release_Date__c=LAST_N_MONTHS:6 ';
          }
          when else {
            Integer yearValue = Integer.valueOf(timespan);
            filters += ' CALENDAR_YEAR(Release_Date__c)=:yearValue ';
          }
        }
        query += filters;
        query += 'ORDER BY Release_Date__c DESC LIMIT 2000';
      } else {
        query += filters;
        query += 'ORDER BY Release_Date__c DESC LIMIT 20';
      }
      return Database.query(query);
    } catch (Exception e) {
      ExceptionLogger.logException(e, SprinterUtil.class.getName(), true);
      return null;
    }
  }

  /**
   * Get wrapped sprint record filtered by type and timespan
   * @param {type} sprint type
   * @param {timespan} timespan or duratio fo release dates
   * Max limit is 2000
   */
  public static List<SprintWrapper> getFilteredSprintsWrapped(
    String type,
    String timespan
  ) {
    List<SObject> sprintObjs = SprinterUtil.getFilteredSprints(type, timespan);
    return SprinterUtil.wrapSprints(sprintObjs);
  }

  /**
   * Get release notes of a sprint
   * @param sprintId
   */
  public static List<SObject> getReleaseNotes(String sprintId) {
    if (sprintId != null)
      sprintId = String.escapeSingleQuotes(sprintId);
    try {
      String query =
        'SELECT Id, ' +
        'Name, ' +
        'Patch_Notes__c, ' +
        'Type__c, ' +
        'Product_Tag__c, ' +
        'Product_Tag__r.Name, ' +
        'Work_Item__c ' +
        'FROM User_Story__c ' +
        'WHERE Sprint__c =: sprintId';
      return Database.query(query);
    } catch (Exception e) {
      ExceptionLogger.logException(e, SprinterUtil.class.getName(), true);
      return null;
    }
  }

  /**
   * Get release notes of a sprint
   * @param sprintId
   */
  public static ReleaseNotes getReleaseNotesWrapped(String sprintId) {
    List<SObject> userStoryObjs = SprinterUtil.getReleaseNotes(sprintId);
    List<UserStoryWrapper> userStories = SprinterUtil.wrapUserStory(
      userStoryObjs
    );

    SObject sprintObj = SprinterUtil.getSprintById(sprintId);
    if (sprintObj != null) {
      List<SprintWrapper> sprints = SprinterUtil.wrapSprints(
        new List<SObject>{ sprintObj }
      );
      ReleaseNotes releaseNotes = new ReleaseNotes();
      if (userStories != null && userStories.size() > 0) {
        releaseNotes.userStories = userStories;
      }
      if (sprints != null && sprints.size() > 0) {
        releaseNotes.sprint = sprints[0];
      }
      return releaseNotes;
    }

    return null;
  }

  /**
   * Get all user stories for a sprint
   * @param sprintId
   */
  public static List<SObject> getUserStoriesBySprint(String sprintId) {
    if (sprintId != null)
      sprintId = String.escapeSingleQuotes(sprintId);

    try {
      String query =
        'SELECT Id, ' +
        'Name, ' +
        'Dev_Owner__c, ' +
        'Dev_Owner__r.Name, ' +
        'Lead_Review__c, ' +
        'Lead_Reviewer__c, ' +
        'Patch_Notes__c, ' +
        'Peer_Review__c, ' +
        'Peer_Reviewer__c, ' +
        'Product_Tag__c, ' +
        'Product_Tag__r.Name, ' +
        'SIT_Owner__c, ' +
        'SIT_Owner__r.Name, ' +
        'Sprint__c, ' +
        'Status__c, ' +
        'Type__c, ' +
        'UAT_Owner__c, ' +
        'UAT_Owner__r.Name, ' +
        'Work_Item__c, ' +
        'Number_Of_Components__c, ' +
        'Story_Points__c, ' +
        'Dev_Effort_Hrs__c, ' +
        'QA_Effort_Hrs__c ' +
        'FROM User_Story__c ' +
        'WHERE Sprint__c =: sprintId';
      return Database.query(query);
    } catch (Exception e) {
      ExceptionLogger.logException(e, SprinterUtil.class.getName(), true);
      return null;
    }
  }

  /**
   * Get all user stories wrapped for a sprint
   * @param sprintId
   */
  public static List<UserStoryWrapper> getUserStoriesBySprintWrapped(
    String sprintId
  ) {
    List<SObject> userStoryObjs = SprinterUtil.getUserStoriesBySprint(sprintId);
    List<UserStoryWrapper> userStories = SprinterUtil.wrapUserStory(
      userStoryObjs
    );

    if (userStories != null && userStories.size() > 0) {
      return userStories;
    }
    return null;
  }

  /**
   * Get all user story component wrapped for a user story
   * @param userStoryId
   */
  public static List<SObject> getComponentsByUserStory(String userStoryId) {
    if (userStoryId != null)
      userStoryId = String.escapeSingleQuotes(userStoryId);

    try {
      String query =
        'SELECT Id, ' +
        'Name, ' +
        'Api_Name__c, ' +
        'Change_Type__c, ' +
        'Metadata_Type__c, ' +
        'User_Story__c, ' +
        'User_Story__r.Name ' +
        'FROM User_Story_Component__c ' +
        'WHERE User_Story__c =: userStoryId';
      return Database.query(query);
    } catch (Exception e) {
      ExceptionLogger.logException(e, SprinterUtil.class.getName(), true);
      return null;
    }
  }

  /**
   * Get all ser story components wrapped for a user story
   * @param userStoryId
   */
  public static List<UserStoryComponentWrapper> getComponentsByUserStoryWrapped(
    String userStoryId
  ) {
    List<SObject> userStoryCompObjs = SprinterUtil.getComponentsByUserStory(
      userStoryId
    );
    List<UserStoryComponentWrapper> userStoryComponents = SprinterUtil.wrapUserStoryComponent(
      userStoryCompObjs
    );

    if (userStoryComponents != null && userStoryComponents.size() > 0) {
      return userStoryComponents;
    }
    return null;
  }

  public static List<UserStoryComponentWrapper> wrapUserStoryComponent(
    List<SObject> userStoryCompObjs
  ) {
    if (userStoryCompObjs != null && userStoryCompObjs.size() > 0) {
      List<UserStoryComponentWrapper> userStoryComponents = new List<UserStoryComponentWrapper>();
      for (sObject userStoryCompObj : userStoryCompObjs) {
        //process record here
        UserStoryComponentWrapper userStoryComponent = new UserStoryComponentWrapper();
        userStoryComponent.id = userStoryCompObj.Id;
        userStoryComponent.name = getFieldValue(userStoryCompObj, 'Name') !=
          null
          ? String.valueOf(getFieldValue(userStoryCompObj, 'Name'))
          : null;
        userStoryComponent.apiName = getFieldValue(
            userStoryCompObj,
            'Api_Name__c'
          ) != null
          ? String.valueOf(getFieldValue(userStoryCompObj, 'Api_Name__c'))
          : null;
        userStoryComponent.changeType = getFieldValue(
            userStoryCompObj,
            'Change_Type__c'
          ) != null
          ? String.valueOf(getFieldValue(userStoryCompObj, 'Change_Type__c'))
          : null;
        userStoryComponent.metadataType = getFieldValue(
            userStoryCompObj,
            'Metadata_Type__c'
          ) != null
          ? String.valueOf(getFieldValue(userStoryCompObj, 'Metadata_Type__c'))
          : null;
        userStoryComponent.userStoryId = getFieldValue(
            userStoryCompObj,
            'User_Story__c'
          ) != null
          ? String.valueOf(getFieldValue(userStoryCompObj, 'User_Story__c'))
          : null;
        userStoryComponent.userStoryName = getSObjectValue(
            userStoryCompObj,
            'User_Story__r'
          ) != null
          ? (getFieldValue(
                userStoryCompObj.getSObject('User_Story__r'),
                'Name'
              ) != null
              ? String.valueOf(
                  getFieldValue(
                    userStoryCompObj.getSObject('User_Story__r'),
                    'Name'
                  )
                )
              : null)
          : null;

        userStoryComponents.add(userStoryComponent);
      }
      return userStoryComponents;
    }
    return null;
  }

  public static List<UserStoryWrapper> wrapUserStory(
    List<SObject> userStoryObjs
  ) {
    if (userStoryObjs != null && userStoryObjs.size() > 0) {
      List<UserStoryWrapper> userStories = new List<UserStoryWrapper>();
      for (sObject userStoryObj : userStoryObjs) {
        //process record here
        UserStoryWrapper userStory = new UserStoryWrapper();
        userStory.id = userStoryObj.Id;
        userStory.workItem = getFieldValue(userStoryObj, 'Work_Item__c') != null
          ? String.valueOf(getFieldValue(userStoryObj, 'Work_Item__c'))
          : null;
        userStory.title = getFieldValue(userStoryObj, 'Name') != null
          ? String.valueOf(getFieldValue(userStoryObj, 'Name'))
          : null;
        userStory.sprintId = getFieldValue(userStoryObj, 'Sprint__c') != null
          ? String.valueOf(getFieldValue(userStoryObj, 'Sprint__c'))
          : null;
        userStory.sprintTitle = getSObjectValue(userStoryObj, 'Sprint__r') !=
          null
          ? (getFieldValue(userStoryObj.getSObject('Sprint__r'), 'Title__c') !=
              null
              ? String.valueOf(
                  getFieldValue(
                    userStoryObj.getSObject('Sprint__r'),
                    'Title__c'
                  )
                )
              : null)
          : null;
        userStory.leadReviewerId = getFieldValue(
            userStoryObj,
            'Lead_Review__c'
          ) != null
          ? String.valueOf(getFieldValue(userStoryObj, 'Lead_Review__c'))
          : null;
        userStory.leadReviewerName = getSObjectValue(
            userStoryObj,
            'Lead_Review__r'
          ) != null
          ? (getFieldValue(userStoryObj.getSObject('Lead_Review__r'), 'Name') !=
              null
              ? String.valueOf(
                  getFieldValue(
                    userStoryObj.getSObject('Lead_Review__r'),
                    'Name'
                  )
                )
              : null)
          : null;
        userStory.peerReviewerId = getFieldValue(
            userStoryObj,
            'Peer_Reviewer__c'
          ) != null
          ? String.valueOf(getFieldValue(userStoryObj, 'Peer_Reviewer__c'))
          : null;
        userStory.peerReviewerName = getSObjectValue(
            userStoryObj,
            'Peer_Reviewer__r'
          ) != null
          ? (getFieldValue(
                userStoryObj.getSObject('Peer_Reviewer__r'),
                'Name'
              ) != null
              ? String.valueOf(
                  getFieldValue(
                    userStoryObj.getSObject('Peer_Reviewer__r'),
                    'Name'
                  )
                )
              : null)
          : null;
        userStory.numberOfComponents = getFieldValue(
            userStoryObj,
            'Number_Of_Components__c'
          ) != null
          ? Integer.valueOf(
              getFieldValue(userStoryObj, 'Number_Of_Components__c')
            )
          : null;
        userStory.type = getFieldValue(userStoryObj, 'Type__c') != null
          ? String.valueOf(getFieldValue(userStoryObj, 'Type__c'))
          : null;
        userStory.status = getFieldValue(userStoryObj, 'Status__c') != null
          ? String.valueOf(getFieldValue(userStoryObj, 'Status__c'))
          : null;
        userStory.devOwnerId = getFieldValue(userStoryObj, 'Dev_Owner__c') !=
          null
          ? String.valueOf(getFieldValue(userStoryObj, 'Dev_Owner__c'))
          : null;
        userStory.devOwnerName = getSObjectValue(
            userStoryObj,
            'Dev_Owner__r'
          ) != null
          ? (getFieldValue(userStoryObj.getSObject('Dev_Owner__r'), 'Name') !=
              null
              ? String.valueOf(
                  getFieldValue(userStoryObj.getSObject('Dev_Owner__r'), 'Name')
                )
              : null)
          : null;
        userStory.sitOwnerId = getFieldValue(userStoryObj, 'SIT_Owner__c') !=
          null
          ? String.valueOf(getFieldValue(userStoryObj, 'SIT_Owner__c'))
          : null;
        userStory.sitOwnerName = getSObjectValue(
            userStoryObj,
            'SIT_Owner__r'
          ) != null
          ? (getFieldValue(userStoryObj.getSObject('SIT_Owner__r'), 'Name') !=
              null
              ? String.valueOf(
                  getFieldValue(userStoryObj.getSObject('SIT_Owner__r'), 'Name')
                )
              : null)
          : null;
        userStory.uatOwnerId = getFieldValue(userStoryObj, 'UAT_Owner__c') !=
          null
          ? String.valueOf(getFieldValue(userStoryObj, 'UAT_Owner__c'))
          : null;
        userStory.uatOwnerName = getSObjectValue(
            userStoryObj,
            'UAT_Owner__r'
          ) != null
          ? (getFieldValue(userStoryObj.getSObject('UAT_Owner__r'), 'Name') !=
              null
              ? String.valueOf(
                  getFieldValue(userStoryObj.getSObject('UAT_Owner__r'), 'Name')
                )
              : null)
          : null;
        userStory.patchNotes = getFieldValue(userStoryObj, 'Patch_Notes__c') !=
          null
          ? String.valueOf(getFieldValue(userStoryObj, 'Patch_Notes__c'))
          : null;
        userStory.productTagId = getFieldValue(
            userStoryObj,
            'Product_Tag__c'
          ) != null
          ? String.valueOf(getFieldValue(userStoryObj, 'Product_Tag__c'))
          : null;
        userStory.productTagName = getSObjectValue(
            userStoryObj,
            'Product_Tag__r'
          ) != null
          ? (getFieldValue(userStoryObj.getSObject('Product_Tag__r'), 'Name') !=
              null
              ? String.valueOf(
                  getFieldValue(
                    userStoryObj.getSObject('Product_Tag__r'),
                    'Name'
                  )
                )
              : null)
          : null;
        userStory.storyPoint = getFieldValue(userStoryObj, 'Story_Points__c') !=
          null
          ? Integer.valueOf(getFieldValue(userStoryObj, 'Story_Points__c'))
          : null;
        userStory.devEffort = getFieldValue(
            userStoryObj,
            'Dev_Effort_Hrs__c'
          ) != null
          ? Integer.valueOf(getFieldValue(userStoryObj, 'Dev_Effort_Hrs__c'))
          : null;
        userStory.qaEffort = getFieldValue(userStoryObj, 'QA_Effort_Hrs__c') !=
          null
          ? Integer.valueOf(getFieldValue(userStoryObj, 'QA_Effort_Hrs__c'))
          : null;

        userStories.add(userStory);
      }
      return userStories;
    }
    return null;
  }

  public static List<SprintWrapper> wrapSprints(List<SObject> sprintObjs) {
    if (sprintObjs != null && sprintObjs.size() > 0) {
      List<SprintWrapper> sprints = new List<SprintWrapper>();
      for (sObject sprintObj : sprintObjs) {
        //process record here
        SprintWrapper sprint = new SprintWrapper();
        sprint.id = sprintObj.Id;
        sprint.description = getFieldValue(sprintObj, 'Description__c') != null
          ? String.valueOf(getFieldValue(sprintObj, 'Description__c'))
          : null;
        sprint.sprintNumber = getFieldValue(sprintObj, 'Name') != null
          ? String.valueOf(getFieldValue(sprintObj, 'Name'))
          : null;
        sprint.title = getFieldValue(sprintObj, 'Title__c') != null
          ? String.valueOf(getFieldValue(sprintObj, 'Title__c'))
          : null;
        sprint.status = getFieldValue(sprintObj, 'Status__c') != null
          ? String.valueOf(getFieldValue(sprintObj, 'Status__c'))
          : null;
        sprint.type = getFieldValue(sprintObj, 'Type__c') != null
          ? String.valueOf(getFieldValue(sprintObj, 'Type__c'))
          : null;
        sprint.numberOfUserStories = getFieldValue(
            sprintObj,
            'Number_User_Stories__c'
          ) != null
          ? Integer.valueOf(getFieldValue(sprintObj, 'Number_User_Stories__c'))
          : null;
        sprint.releaseDate = getFieldValue(sprintObj, 'Release_Date__c') != null
          ? Date.valueOf(getFieldValue(sprintObj, 'Release_Date__c'))
          : null;
        sprint.sitDate = getFieldValue(sprintObj, 'SIT_Date__c') != null
          ? Date.valueOf(getFieldValue(sprintObj, 'SIT_Date__c'))
          : null;
        sprint.uatDate = getFieldValue(sprintObj, 'UAT_Date__c') != null
          ? Date.valueOf(getFieldValue(sprintObj, 'UAT_Date__c'))
          : null;
        sprint.ownerId = getFieldValue(sprintObj, 'OwnerId') != null
          ? String.valueOf(getFieldValue(sprintObj, 'OwnerId'))
          : null;
        sprint.ownerName = getSObjectValue(sprintObj, 'Owner') != null
          ? (getFieldValue(sprintObj.getSObject('Owner'), 'Name') != null
              ? String.valueOf(
                  getFieldValue(sprintObj.getSObject('Owner'), 'Name')
                )
              : null)
          : null;

        sprints.add(sprint);
      }
      return sprints;
    }
    return null;
  }

  public static String updateSObject(List<SObject> sObjects) {
    Savepoint sp = Database.setSavepoint();
    try {
      update sObjects;
      return 'success';
    } catch (Exception e) {
      ExceptionLogger.logException(e, SprinterUtil.class.getName(), true);
      Database.rollback(sp);
      return e.getMessage();
    }
  }

  public static Object getFieldValue(SObject sobj, String field) {
    try {
      return sobj.get(field);
    } catch (System.SObjectException e) {
      return null;
    }
  }

  public static Object getSObjectValue(SObject sobj, String field) {
    try {
      return sobj.getSObject(field);
    } catch (System.SObjectException e) {
      return null;
    }
  }

  public class ReleaseNotes {
    @AuraEnabled
    public SprintWrapper sprint;
    @AuraEnabled
    public List<UserStoryWrapper> userStories;
  }

  public class SprintWrapper {
    @AuraEnabled
    public String id;
    @AuraEnabled
    public String sprintNumber;
    @AuraEnabled
    public String title;
    @AuraEnabled
    public String description;
    @AuraEnabled
    public Date releaseDate;
    @AuraEnabled
    public Date sitDate;
    @AuraEnabled
    public Date uatDate;
    @AuraEnabled
    public String ownerId;
    @AuraEnabled
    public String ownerName;
    @AuraEnabled
    public String type;
    @AuraEnabled
    public String status;
    @AuraEnabled
    public Integer numberOfUserStories;
  }

  public class UserStoryWrapper {
    @AuraEnabled
    public String id;
    @AuraEnabled
    public String workItem;
    @AuraEnabled
    public String title;
    @AuraEnabled
    public String sprintId;
    @AuraEnabled
    public String sprintTitle;
    @AuraEnabled
    public String leadReviewerId;
    @AuraEnabled
    public String leadReviewerName;
    @AuraEnabled
    public String peerReviewerId;
    @AuraEnabled
    public String peerReviewerName;
    @AuraEnabled
    public Integer numberOfComponents;
    @AuraEnabled
    public String type;
    @AuraEnabled
    public String status;
    @AuraEnabled
    public String devOwnerId;
    @AuraEnabled
    public String devOwnerName;
    @AuraEnabled
    public String sitOwnerId;
    @AuraEnabled
    public String sitOwnerName;
    @AuraEnabled
    public String uatOwnerId;
    @AuraEnabled
    public String uatOwnerName;
    @AuraEnabled
    public String patchNotes;
    @AuraEnabled
    public String productTagId;
    @AuraEnabled
    public String productTagName;
    @AuraEnabled
    public Integer storyPoint;
    @AuraEnabled
    public Integer devEffort;
    @AuraEnabled
    public Integer qaEffort;
  }

  public class UserStoryComponentWrapper {
    @AuraEnabled
    public String id;
    @AuraEnabled
    public String userStoryId;
    @AuraEnabled
    public String userStoryName;
    @AuraEnabled
    public String apiName;
    @AuraEnabled
    public String metadataType;
    @AuraEnabled
    public String changeType;
    @AuraEnabled
    public String name;
  }
}
