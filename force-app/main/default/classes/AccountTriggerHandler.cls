public with sharing class AccountTriggerHandler {
    public static void handleAfterInsert(List<Account> newAccount) {
        List<Contact> conList = new List<Contact>();
        Set<Id> accSetId = new Set<Id>();

        for(Account acc: newAccount){
            if(acc.Industry == 'Agriculture'){
                accSetId.add(acc.Id);
            }

            Contact con = new Contact();
            con.FirstName = 'Marcus';
            con.LastName = 'Stoinis';
            con.Email = 'MStonis@aus.com';
            con.AccountId = acc.ID;
            conList.add(con);
            
            //Contact GlenPhilips = new Contact(FirstName='GlenPhilip', LastName = acc.Name, Email='GP@NZ.com', AccountId = acc.Id);
                //Contact PatCummins = new Contact(FirstName='PatCummins', LastName = acc.Name, Email='PC@AUS.com', AccountId = acc.Id);

                //conList.add(GlenPhilip);
               // conList.add(PatCummins);
        }
        if(!conList.isempty()){
            INSERT conList;
        }

        if(!accSetId.isEmpty()){
            createOpportunity(accSetId);
        }
    }

    public Static void handleAfterUpdate(Map<id,Account> oldAccountMap, List<Account> newAccount){
        Set<Id> accountId = new Set<Id>();// intializing the Id value to pass has parameter in createOpportunity method
        for(Account accObj: newAccount){
            Account accOld = oldAccountMap.get(accObj.id);
           
            if(accObj.Industry!=accOld.Industry && accObj.Industry == 'Agriculture'){
                accountId.add(accObj.Id);
            }
        }
        if(!accountId.isEmpty()){
            createOpportunity(accountId);
        }
    }

    public Static void handleBeforeDelete(List<Account> currentAccount){
        for(Account acc: currentAccount){
            List<Contact> conList = [SELECT Id, AccountId FROM Contact WHERE AccountId = :acc.Id];
            if(!conList.isEmpty()){
                acc.addError('Account with associated Contact(s) can not be deleted');
            }
        }
    }

    public Static void createOpportunity(Set<Id> accID){
        List<Opportunity> oppList = new List<Opportunity>();
        for(Account acc: [SELECT Id, Name, Industry FROM Account WHERE Id IN: accID]){
            Opportunity Oppo = new Opportunity();
            Date today = Date.today(); //Initializing CurrentDate
            Oppo.Name = 'TestAccount';
            Oppo.StageName = 'Prospecting';
            Oppo.Amount = 0;
            Oppo.CloseDate = today.addDays(90); //adding 90 days to CurrentDate
            Oppo.AccountId = acc.Id;
            oppList.add(Oppo);
        }
        if(!oppList.isEmpty()){
            INSERT oppList;
        }
    }
}