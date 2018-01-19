@isTest
private class BillingCalloutServiceTest {

  @testSetup static void testSetupdata(){

    Opportunity opp = New Opportunity(Name='Test Opp', StageName='Prospecting',CloseDate=System.today());
    insert opp;

    Date startDate = Date.today();
    Date endDate = startDate.addDays(10);

    Project__c project = new Project__c(Name = 'project1', Opportunity__c = opp.Id, Start_Date__c = startDate, End_Date__c = endDate, Billable_Amount__c = 10000, Status__c = 'Running', ProjectRef__c = 'p-001');
    insert project;

    ServiceCredentials__c credentials = new ServiceCredentials__c();
    credentials.Name = 'BillingServiceCredential';
    credentials.Username__c = 'fakeusername';
    credentials.Password__c = 'fakepassword';
    insert credentials;
  }

  @isTest static void testBillingCallOutServiceSucceed() {
    Test.setMock(WebServiceMock.class, new BillingCalloutServiceMock());

    Project__c project = [SELECT Status__c FROM Project__c WHERE ProjectRef__c = 'p-001' LIMIT 1];

    Test.startTest();
    project.Status__c = 'Billable';
    update project;
    Test.stopTest();

    Project__c verifyProject = [SELECT Status__c FROM Project__c WHERE ProjectRef__c = 'p-001' LIMIT 1];
    System.assertEquals(verifyProject.Status__c, 'Billed');
  }

  @isTest static void testBillingCallOutServiceFailure() {
    Test.setMock(WebServiceMock.class, new BillingCalloutServiceMockFailure());

    Project__c project = [SELECT Status__c FROM Project__c WHERE ProjectRef__c = 'p-001' LIMIT 1];

    Test.startTest();
    project.Status__c = 'Billable';
    update project;
    Test.stopTest();

    Project__c verifyProject = [SELECT Status__c FROM Project__c WHERE ProjectRef__c = 'p-001' LIMIT 1];
    System.assertNotEquals(verifyProject.Status__c, 'Billed');
  }

}
