@isTest
public class VolunteerRecordFinderCtrl_TEST {
    
    private static Contact c;
    
    static {
        c = new Contact(
            FirstName = 'test1',
            LastName = 'vrfctest',
            Email = 'test@vrfctest.test',
            HomePhone = '3216549870',
            Volunteer__c = true,
            Allowed_to_Volunteer__c = true
        );
        insert c;
    }
    
    static testMethod void testFindingOnEmail() {
        List<Id> fixedResults = new List<Id>{c.Id};
        Test.setFixedSearchResults(fixedResults);
        
        Test.startTest();
        
        VolunteerRecordFinderViewModel vrfvm = VolunteerRecordFinderCtrl.doSearch(c.Email);
        System.assertEquals(true, vrfvm.isSuccess);
        System.assertEquals(1, vrfvm.records.size());
        
        VolunteerRecordFinderViewModel match = VolunteerRecordFinderCtrl.doSecurityCheck(vrfvm.records[0].id, c.LastName);
        System.assertEquals(true, match.isSuccess);
        
        VolunteerRecordFinderViewModel noMatch = VolunteerRecordFinderCtrl.doSecurityCheck(vrfvm.records[0].id, 'xxxx');
        System.assertEquals(false, noMatch.isSuccess);
        
        Test.stopTest();
    }
    
    static testMethod void testFindingOnPhone() {
        List<Id> fixedResults = new List<Id>{c.Id};
        Test.setFixedSearchResults(fixedResults);
        
        Test.startTest();
        
        VolunteerRecordFinderViewModel vrfvm = VolunteerRecordFinderCtrl.doSearch('(321) 654-9870');
        System.assertEquals(true, vrfvm.isSuccess);
        System.assertEquals(1, vrfvm.records.size());
        
        Test.stopTest();
    }
    
    static testMethod void testNoResults() {
        
        VolunteerRecordFinderViewModel vrfvm = VolunteerRecordFinderCtrl.doSearch('999-888-7777');
        System.assertEquals(false, vrfvm.isSuccess);
        System.assertEquals(VolunteerRecordFinderCtrl.NO_MATCHES, vrfvm.errorType);
    }
}