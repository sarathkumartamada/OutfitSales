public class SignUpAccountController {

     public Account account {get;set;}
     public Cart__c cart{get;set;}
     public String email{get;set;}
     public String name{get;set;}
     public String password{get;set;}
     public String phone{get;set;}
    
    
    public PageReference Save() {
    try{
        Account account=new Account();
        Cart__c cart=new Cart__c();
        account.Email__c=email;
        account.name=name;
        account.Password__c=password;
        account.phone=phone;
        insert account;
        cart.Account__c= account.Id;
        insert cart;
        
        return page.OutfitLoginPage;
        }
   catch(Exception ex){
          System.debug('Exception In SignUpAccountController'+ex.getMessage());
          ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Required Field Missing'));
          return null;
        }         
    }


    public PageReference Cancel() {
        return page.OutfitLoginPage;
    }


    

   
    
}