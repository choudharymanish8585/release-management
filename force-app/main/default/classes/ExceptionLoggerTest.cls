@isTest
public with sharing class ExceptionLoggerTest {
  @isTest
  public static void testLogExceptionSync1() {
    try {
      Integer i = 10 / 0;
    } catch (Exception e) {
      ExceptionLogger.logException(
        e,
        ExceptionLoggerTest.class.getName(),
        false
      );
    }
  }

  @isTest
  public static void testLogExceptionSync2() {
    try {
      Integer i = 10 / 0;
    } catch (Exception e) {
      try {
        ExceptionLogger.logException(
          e,
          ExceptionLoggerTest.class.getName(),
          true
        );
      } catch (Exception e1) {
      }
    }
  }

  @isTest
  public static void testLogExceptionASync1() {
    try {
      Sobject s = (Sobject) Type.forName('Account').newInstance();
      s.put('Name', 'Test Account');
      for (Integer i = 0; i < 150; i++) {
        upsert s;
      }
      Integer i = 10 / 0;
    } catch (Exception e) {
      ExceptionLogger.logException(
        e,
        ExceptionLoggerTest.class.getName(),
        false
      );
    }
  }

  @isTest
  public static void testLogExceptionASync2() {
    try {
      Sobject s = (Sobject) Type.forName('Account').newInstance();
      s.put('Name', 'Test Account');
      for (Integer i = 0; i < 150; i++) {
        upsert s;
      }
      Integer i = 10 / 0;
    } catch (Exception e) {
      try {
        ExceptionLogger.logException(
          e,
          ExceptionLoggerTest.class.getName(),
          true
        );
      } catch (Exception e1) {
      }
    }
  }

  @isTest
  public static void testlogRecord() {
    ExceptionLogger.logRecord('TestMessage', 'TestDescription', 'TestClass');
  }

  @isTest
  public static void testlogRecordFuture() {
    Sobject s = (Sobject) Type.forName('Account').newInstance();
    s.put('Name', 'Test Account');
    for (Integer i = 0; i < 150; i++) {
      upsert s;
    }
    ExceptionLogger.logRecord('TestMessage', 'TestDescription', 'TestClass');
  }
}
