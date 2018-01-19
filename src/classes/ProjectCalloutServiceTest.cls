@isTest
private class ProjectCalloutServiceTest {

  @testSetup static void testSetupdata(){

    Opportunity opp1 = new Opportunity();
    opp1.Name = 'Test Opp 1';
    opp1.Type = 'New Project';
    opp1.Amount = 1000;
    opp1.CloseDate = Date.today();
    opp1.StageName = 'Submitted Project';
    insert opp1;

    Opportunity opp2 = new Opportunity();
    opp2.Name = 'Test Opp 2';
    opp2.Type = 'New Project';
    opp2.Amount = 1000;
    opp2.CloseDate = Date.today();
    opp2.StageName = 'Resubmit Project';
    insert opp2;

    ServiceTokens__c servToken = new ServiceTokens__c();
    servToken.Name = 'ProjectServiceToken';
    servToken.Token__c = 'faketoken';
    insert servToken;
  }

  @isTest static void testPostOpportunityToPMSSucceed() {
    Opportunity opp = [SELECT Id, Name FROM Opportunity WHERE Name = 'Test Opp 1' Limit 1];

    List<Id> oppIdList = new List<Id>();
    oppIdList.add(opp.Id);

    Test.startTest();
    Test.setMock(HttpCalloutMock.class, new ProjectCalloutServiceMock());
    ProjectCalloutService.postOpportunityToPMS(oppIdList);
    Test.stopTest();

    Opportunity verifyOpp = [SELECT StageName FROM Opportunity WHERE Id =: opp.Id];
    System.assertEquals('Submitted Project', verifyOpp.StageName);
  }

  @isTest static void testPostOpportunityToPMSFailure() {
    Opportunity opp = [Select Id, Name FROM Opportunity WHERE Name = 'Test Opp 2' Limit 1];

    List<Id> oppIdList = new List<Id>();
    oppIdList.add(opp.Id);

    Test.startTest();
    Test.setMock(HttpCalloutMock.class, new ProjectCalloutServiceMockFailure());
    ProjectCalloutService.postOpportunityToPMS(oppIdList);
    Test.stopTest();

    Opportunity verifyOpp = [SELECT StageName FROM Opportunity WHERE Id =: opp.Id];
    System.assertEquals('Resubmit Project',verifyOpp.StageName);
  }

}
