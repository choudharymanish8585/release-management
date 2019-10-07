public with sharing class PicklistPathController {
    @AuraEnabled
    public static List<PicklistItem> getPicklistValues(String sObjectName, String picklistFieldName){
        //describe sObject and get metadata property
        Schema.DescribeSobjectResult[] sObjects = Schema.describeSObjects(new List<String>{sObjectName});
        if(sObjects != null && sObjects.size() > 0){
            //get a map of sobject fields for the passed sobject
            Map<String, Schema.SObjectField> fieldMap = sObjects[0].fields.getMap();
            //get the list of picklist values using the picklist field name
            List<Schema.PicklistEntry> picklistValues = fieldMap.get(picklistFieldName).getDescribe().getPickListValues();

            List<PicklistItem> picklistItems = new List<PicklistItem>();
            for( Schema.PicklistEntry picklistValue : picklistValues)
            {
                PicklistItem picklistItem = new PicklistItem();
                picklistItem.label = picklistValue.getLabel();
                picklistItem.value = picklistValue.getValue();
                picklistItems.add(picklistItem);
            }
            return picklistItems;
        }
        return null;    
    }

    public class PicklistItem{
        @AuraEnabled public String label;
        @AuraEnabled public String value;
    }
}