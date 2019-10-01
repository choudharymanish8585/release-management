@isTest
public with sharing class ExceptionLoggerTest {
    @isTest
    public static void testLogException(){
        try{
            Integer i = 10/0;
        } catch( Exception e){
            ExceptionLogger.logException(e, ExceptionLoggerTest.class.getName());
        }
    }
}
