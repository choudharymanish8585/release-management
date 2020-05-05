public with sharing class PicklistPathController {
  @AuraEnabled
  public static List<PicklistItem> getPicklistValues(
    String sObjectName,
    String picklistFieldName
  ) {
    try {
      //describe sObject and get metadata property
      Schema.DescribeSobjectResult[] sObjects = getSObject(sObjectName);
      if (sObjects == null) {
        sObjects = getSObject('sfarm__' + sObjectName);
      }
      if (sObjects != null && sObjects.size() > 0) {
        //get a map of sobject fields for the passed sobject
        Map<String, Schema.SObjectField> fieldMap = sObjects[0].fields.getMap();
        //get picklist field
        Schema.SObjectField picklistField = fieldMap.get(picklistFieldName);
        if (picklistField == null) {
          picklistField = fieldMap.get('sfarm__' + picklistFieldName);
        }

        if (picklistField == null) {
          return null;
        }
        //get the list of picklist values using the picklist field name
        List<Schema.PicklistEntry> picklistValues = picklistField.getDescribe()
          .getPickListValues();

        List<PicklistItem> picklistItems = new List<PicklistItem>();
        for (Schema.PicklistEntry picklistValue : picklistValues) {
          PicklistItem picklistItem = new PicklistItem();
          picklistItem.label = picklistValue.getLabel();
          picklistItem.value = picklistValue.getValue();
          picklistItems.add(picklistItem);
        }
        return picklistItems;
      }
      return null;
    } catch (Exception e) {
      ExceptionLogger.logException(
        e,
        PicklistPathController.class.getName(),
        false
      );
      return null;
    }
  }

  public static Schema.DescribeSobjectResult[] getSObject(String sObjectName) {
    try {
      return Schema.describeSObjects(new List<String>{ sObjectName });
    } catch (Exception e) {
      return null;
    }
  }
  public class PicklistItem {
    @AuraEnabled
    public String label;
    @AuraEnabled
    public String value;
  }
}
