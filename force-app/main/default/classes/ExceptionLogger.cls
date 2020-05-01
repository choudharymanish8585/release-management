public with sharing class ExceptionLogger {
  @future
  public static void logExceptionFuture(
    String stackTrace,
    String errorMessage,
    String apexClass
  ) {
    if (Limits.getDmlStatements() == Limits.getLimitDmlStatements()) {
      System.debug(
        'Reached dml statment limit. Ignoring this exception--' + errorMessage
      );
    } else {
      SObject ex = (Sobject) Type.forName('Exception__c').newInstance();
      ex.put('Apex_Class__c', apexClass);
      ex.put('Stack_Trace__c', stackTrace);
      ex.put('Message__c', errorMessage);
      insert ex;
    }
  }

  public static void logException(
    Exception e,
    String apexClass,
    Boolean throwCustom
  ) {
    String stackTrace = e.getStackTraceString();
    String errorMessage = e.getMessage();

    if (errorMessage.length() > 255) {
      stackTrace = errorMessage + '\n' + stackTrace;
      errorMessage = errorMessage.substring(0, 254);
    }

    if (stackTrace.length() > 32768) {
      stackTrace = stackTrace.substring(0, 32767);
    }

    if (Limits.getDmlStatements() == Limits.getLimitDmlStatements()) {
      if (Limits.getFutureCalls() != Limits.getLimitFutureCalls()) {
        ExceptionLogger.logExceptionFuture(stackTrace, errorMessage, apexClass);
      } else {
        System.debug(
          'Reached dml statment limit. Ignoring this exception--' + errorMessage
        );
        if (throwCustom && !Test.isRunningTest()) {
          throw new CustomException(
            e.getMessage() +
            '---STACK_TRACE---' +
            e.getStackTraceString()
          );
        }
      }
    } else {
      SObject ex = (Sobject) Type.forName('Exception__c').newInstance();
      ex.put('Apex_Class__c', apexClass);
      ex.put('Stack_Trace__c', stackTrace);
      ex.put('Message__c', errorMessage);
      insert ex;

      if (throwCustom && !Test.isRunningTest()) {
        throw new CustomException(
          e.getMessage() +
          '---STACK_TRACE---' +
          e.getStackTraceString()
        );
      }
    }
  }

  @future
  public static void logRecordFuture(
    String message,
    String description,
    String apexClass
  ) {
    if (Limits.getDmlStatements() == Limits.getLimitDmlStatements()) {
      SObject ex = (Sobject) Type.forName('Exception__c').newInstance();
      ex.put('Apex_Class__c', apexClass);
      ex.put('Stack_Trace__c', description);
      ex.put('Message__c', message);
      insert ex;
    } else {
      System.debug(
        'Reached dml statment limit. Ignoring this exception-- ' +
        message +
        ' -- ' +
        description
      );
    }
  }

  public static void logRecord(
    String message,
    String description,
    String apexClass
  ) {
    if (Limits.getDmlStatements() == Limits.getLimitDmlStatements()) {
      if (Limits.getFutureCalls() != Limits.getLimitFutureCalls()) {
        logRecordFuture(message, description, apexClass);
      } else {
        System.debug(
          'Reached dml statment limit. Ignoring this exception-- ' +
          message +
          ' -- ' +
          description
        );
      }
    } else {
      SObject ex = (Sobject) Type.forName('Exception__c').newInstance();
      ex.put('Apex_Class__c', apexClass);
      ex.put('Stack_Trace__c', description);
      ex.put('Message__c', message);
      insert ex;
    }
  }

  public class CustomException extends Exception {
  }
}
