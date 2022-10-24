trigger QuoteTrigger on Quote (before insert,after update) {

    if(QuoteTriggerHandler.runTrigger){
        if(trigger.isInsert){
            new QuoteTriggerHandler().syncOpptyFieldToQuoteBeforeInsert(trigger.new);
        }else if(trigger.isUpdate){
             new QuoteTriggerHandler().syncOpptyFieldToQuoteAfterUpdate(trigger.new);
        }
    }
}