@isTest
public class QuoteTriggerTest{

    @testSetup static void createData() {
        List<Quote> lstQuote = new List<Quote>();

        Account objAccount = new Account(Name = 'Test Acc1', BillingCity = 'Test City',
                                                                    BillingStreet = 'Test Street', BillingPostalCode = '12345', 
                                                                    Phone = '123456');


        insert objAccount;
        
        
       /* Product2 objProduct = new Product2(Name = 'Test product1', family = 'Cafe');
                                                    
        insert objProduct;
       
        PriceBookEntry objPBE = new PriceBookEntry(UnitPrice = 300, PriceBook2Id = Test.getStandardPricebookId(),
                                                        Product2Id = objProduct.Id, IsActive = true);
                                                               
        
        insert objPBE;
        */
        Opportunity objOpp = new Opportunity(Name = 'Test Opp', AccountId = objAccount.Id, StageName = 'Verbal Confirmation', CloseDate = Date.today()+10);
        insert objOpp;
        
        for(Integer i=0; i< 10 ; i++)
        {
            lstQuote.add(new Quote(OpportunityId = objOpp.Id, Name = 'Test Quote' + i, Status = 'Review Pending'));
        }
        insert lstQuote;
    }

    public static testMethod void CreateQuote() {

        

    }
    
    public static testMethod void UpdateQuote() {

        Quote qu = [SELECT Id,Name,IsSyncing,OpportunityId FROM Quote LIMIT 1];
        Opportunity Opp = new Opportunity(Id=qu.OpportunityId,SyncedQuoteId=qu.id);
        update opp;
        qu.Name += '_Test';
       // qu.IsSyncing = true;
        Test.startTest();
            update qu;
        Test.stopTest();
        
        

    }
    
}