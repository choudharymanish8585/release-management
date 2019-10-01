public with sharing class ExceptionLogger {
    @future
    public static void logExceptionFuture(String stackTrace, String errorMessage, String apexClass){
        if(Limits.getDmlStatements() == Limits.getLimitDmlStatements()){
            System.debug('Reached dml statment limit. Ignoring this exception--'+errorMessage);
        } else{
            SObject ex = (Sobject)Type.forName('Exception__c').newInstance();
            ex.put('Apex_Class__c',  apexClass);
            ex.put('Stack_Trace__c',  stackTrace);
            ex.put('Message__c',  errorMessage);
            insert ex;
        }
    }

    public static void logException(Exception e, String apexClass, Boolean throwCustom){
        String stackTrace = e.getStackTraceString();
        String errorMessage = e.getMessage();
        if(Limits.getDmlStatements() == Limits.getLimitDmlStatements()){
            if(Limits.getFutureCalls() != Limits.getLimitFutureCalls()){
                ExceptionLogger.logExceptionFuture(stackTrace, errorMessage, apexClass);
            } else{
                System.debug('Reached dml statment limit. Ignoring this exception--'+errorMessage);
                if(throwCustom){
                    throw new CustomException(errorMessage+'---STACK_TRACE---'+stackTrace);
                }
            }
        } else{
            SObject ex = (Sobject)Type.forName('Exception__c').newInstance();
            ex.put('Apex_Class__c',  apexClass);
            ex.put('Stack_Trace__c',  stackTrace);
            ex.put('Message__c',  errorMessage);
            insert ex;

            if(throwCustom){
                throw new CustomException(errorMessage+'---STACK_TRACE---'+stackTrace);
            }
        }
    }

    public class CustomException extends Exception{}
}
