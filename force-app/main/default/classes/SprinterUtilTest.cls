@isTest
public with sharing class SprinterUtilTest {
  @IsTest
  static void methodName() {
    String baseUrl = SprinterUtil.getBaseUrl();
    System.assert(baseUrl != null, 'Base url is null');
  }
}
