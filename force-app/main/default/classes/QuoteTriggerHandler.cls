public class QuoteTriggerHandler{


   public static boolean runTrigger = true;
   
   public static List<Opportunity_To_Quote__mdt> mappings = [SELECT id, Opportunity_Field__c, Quote_Field__c FROM Opportunity_To_Quote__mdt WHERE Is_Active__c=True]; 
   public static List<Quote_To_Opportunity__mdt> quotemappings = [SELECT id, Opportunity_Field__c, Quote_Field__c FROM Quote_To_Opportunity__mdt WHERE Is_Active__c=True]; 
   
   
   public void  syncOpptyFieldToQuoteBeforeInsert(List<Quote> quotes ){
       Set<Id> opportunityIds = new Set<Id>();
       
       for(Quote eachQuote : quotes){
           opportunityIds.add(eachQuote.OpportunityId);
       }
       
       Map<Id,Opportunity> opps = getParentOpportunities(opportunityIds);
       
       
      for(Quote eachQuote : quotes){
           Opportunity parentOpp = opps.get(eachQuote.OpportunityId);
           
           for(Opportunity_To_Quote__mdt oppToQuote  : mappings)
           {
               String oppField = oppToQuote.Opportunity_Field__c;
               String quoteField = oppToQuote.Quote_Field__c;
               
               eachQuote.put(quoteField,parentOpp.get(oppField));
               
           }
       }
       
   }
   
   
    public void  syncOpptyFieldToQuoteAfterUpdate(List<Quote> quotes ){
       Set<Id> opportunityIds = new Set<Id>();
       
       for(Quote eachQuote : quotes){
           if(eachQuote.IsSyncing){
              opportunityIds.add(eachQuote.OpportunityId);
           }
       }
       
      if(!opportunityIds.isEmpty()){
      Map<Id,Opportunity> opps = getParentOpportunities(opportunityIds);
      for(Quote eachQuote : quotes){
           Opportunity parentOpp = opps.get(eachQuote.OpportunityId);
           
           for(Quote_To_Opportunity__mdt QuoteToOpportunity  : quotemappings)
           {
               String oppField = QuoteToOpportunity.Opportunity_Field__c;
               String quoteField = QuoteToOpportunity.Quote_Field__c;
               
               parentOpp.put(oppField,eachQuote.get(quoteField));
               
           }
       }
           update opps.values();
       }
       
   }
   
   
   
   private Map<Id,Opportunity> getParentOpportunities(Set<Id> opportunityIds){
       List<String> opportunityFields = new List<String>();
       
       for(Opportunity_To_Quote__mdt oppToQuote  : mappings)
       {
           opportunityFields.add(oppToQuote.Opportunity_Field__c);
       }
       
       String SOQL = 'SELECT Id , ';
              SOQL += String.Join(opportunityFields,',');
       SOQL += ' FROM Opportunity WHERE ID IN:opportunityIds';
       
       List<Opportunity> opportunities = database.query(SOQL);
       return new Map<Id,Opportunity>(opportunities);
   }

}