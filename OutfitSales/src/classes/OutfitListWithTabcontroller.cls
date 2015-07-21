public class OutfitListWithTabcontroller{

    public String selectedWorkstyle{get;set;}
    public String selectedEveningstyle{get;set;}
    public String selectedShirtfit{get;set;}
    public String selectedTrousersfit{get;set;}
    public String selectedBrand{get;set;}
    public String selectedSizes{get;set;}
    public List<SelectOption> workstyle{get;set;}
    public List<SelectOption> Eveningstyle{get;set;}
    public List<SelectOption> Shirts{get;set;}
    public List<SelectOption> Trousers{get;set;}
    public List<SelectOption> Brands{get;set;}
    public List<SelectOption> Sizes{get;set;}
    public String Assigned{get;set;}
    public String password{get;set;}
    public String username{get;set;}
    public Id accid {get;set;}
    public List<Account> Account{get;set;}
    public List<Product2> Products{get;set;}
    public List<Cart__c> Carts{get;set;}
    public String selectedOutfitId{get;set;}
    public String selectedOutfitName{get;set;}
    public List<Outfit__c> Outfits{get;set;}
    public Boolean CheckBox { get; set; }
    public List<Product2> selectedList {get;set;}
    public List<ProductWrapper> proList{get;set;}
    public integer NoOfRecords {get; set;}
    public set<id> ProductSetId;
    public integer pagesize {get;set;}
    public String qty{get;set;}
    private Map<String,String> parameters{get;set;}
     

 
    public OutfitListWithTabcontroller() {
   
       
      try{
      
      
        this.username=ApexPages.currentPage().getParameters().get('uname');
        System.debug('username---------------------------->'+username);
        Outfits=[SELECT Name,WORK_STYLE__c, EVENING_STYLE__c, SHIRT_FIT__c,TROUSERS_FIT__c,BRAND__c,SIZES__c ,CreatedDate  FROM Outfit__c WHERE Account__r.Email__c=:this.username order by CreatedDate  desc  ];
        Workstyle = new List<SelectOption>();
        Schema.DescribeFieldResult WorkstyleFieldDescript = Outfit__c.WORK_STYLE__c.getDescribe();
        Workstyle.add(new SelectOption('NONE','NONE'));
        for (Schema.Picklistentry picklistEntry : WorkstyleFieldDescript.getPicklistValues()){
            Workstyle.add(new SelectOption(pickListEntry.getValue(),pickListEntry.getLabel()));
        }
        
        Eveningstyle = new List<SelectOption>();
        Schema.DescribeFieldResult EveningstyleFieldDescript = Outfit__c.EVENING_STYLE__c.getDescribe();
        Eveningstyle.add(new SelectOption('NONE','NONE'));
        for (Schema.Picklistentry picklistEntry : EveningstyleFieldDescript.getPicklistValues()){
            Eveningstyle.add(new SelectOption(pickListEntry.getValue(),pickListEntry.getLabel()));
        }
        
        Shirts = new List<SelectOption>();
        Schema.DescribeFieldResult ShirtsFieldDescript = Outfit__c.SHIRT_FIT__c.getDescribe();
        Shirts.add(new SelectOption('NONE','NONE'));
        for (Schema.Picklistentry picklistEntry : ShirtsFieldDescript.getPicklistValues()){
            Shirts.add(new SelectOption(pickListEntry.getValue(),pickListEntry.getLabel()));
        }
        
        Trousers = new List<SelectOption>();
        Schema.DescribeFieldResult TrousersFieldDescript = Outfit__c.TROUSERS_FIT__c.getDescribe();
        Trousers.add(new SelectOption('NONE','NONE'));
        for (Schema.Picklistentry picklistEntry : TrousersFieldDescript.getPicklistValues()){
            Trousers.add(new SelectOption(pickListEntry.getValue(),pickListEntry.getLabel()));
        }
        
        Brands= new List<SelectOption>();
        Schema.DescribeFieldResult BrandsFieldDescript = Outfit__c.BRAND__c.getDescribe();
        Brands.add(new SelectOption('NONE','NONE'));
        for (Schema.Picklistentry picklistEntry : BrandsFieldDescript.getPicklistValues()){
            Brands.add(new SelectOption(pickListEntry.getValue(),pickListEntry.getLabel()));
        }
        
        Sizes = new List<SelectOption>();
        Schema.DescribeFieldResult SizesFieldDescript = Outfit__c.SIZES__c.getDescribe();
        Sizes.add(new SelectOption('NONE','NONE'));
        for (Schema.Picklistentry picklistEntry : SizesFieldDescript.getPicklistValues()){
            Sizes.add(new SelectOption(pickListEntry.getValue(),pickListEntry.getLabel()));
        } 
        
        ProductSetId=new set<ID>();
        proList=new List<ProductWrapper>();
        selectedList =new List<Product2>();
        
        //Products=[select Name,ProductCode,Description,Stock__c,Outfit__c,(SELECT UnitPrice FROM PricebookEntries WHERE IsActive=:true) from Product2];
        //system.debug('inside getProducts-------------->'+Products);
         
      
    }catch(Exception Ex){
        System.debug('Exception In outfit  '+ex.getMessage());
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'An Error Occured'));
        }
    }
    
  
     public PageReference ClickSubmit() {
         try{
            system.debug('Submit  OutfitController.ClickSubmit   ');
            this.Account=[SELECT Email__c FROM Account WHERE Email__c=:this.username];
            System.debug('Account username----->'+this.username);
            if(Account.isEmpty()){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Account Not Found'));
                return null;
            }
            system.debug('Accounts-------------------->'+Account);
            outfits=[SELECT Id,Account__c,Name FROM Outfit__c WHERE WORK_STYLE__c=: selectedWorkstyle AND EVENING_STYLE__c=: selectedEveningstyle AND SHIRT_FIT__c=: selectedShirtfit AND TROUSERS_FIT__c=: selectedTrousersfit AND  BRAND__c=: selectedBrand AND SIZES__c=: selectedSizes AND Account__c=:null AND Status__c='Assigned'];
            System.debug('Outfit list--->'+outfits);
            if(outfits.isEmpty())
                outfits.add(new Outfit__c(Name='Outfit '+DateTime.now(),WORK_STYLE__c= selectedWorkstyle,EVENING_STYLE__c= selectedEveningstyle,SHIRT_FIT__c= selectedShirtfit,TROUSERS_FIT__c= selectedTrousersfit,BRAND__c= selectedBrand ,SIZES__c= selectedSizes,Account__c=Account[0].Id,Status__c='Assigned'));
            else{
                outfits[0].Account__c=Account[0].Id;
            }
            upsert outfits[0];
            System.debug('OutfitController.submitDetails  outfits[0]  '+outfits[0]);
            Opportunity opportunity=new Opportunity(Name='Opportunity '+outfits[0].Name,StageName='Prospecting',CloseDate=Date.today(),AccountId=Account[0].Id);
            insert opportunity;
            
            Outfits=[SELECT Name,WORK_STYLE__c, EVENING_STYLE__c, SHIRT_FIT__c,TROUSERS_FIT__c,BRAND__c,SIZES__c ,CreatedDate  FROM Outfit__c WHERE Account__r.Email__c=:this.username order by CreatedDate  desc  ];
            
                   
        }catch(Exception ex){
            System.debug('Exception In OutfitController.submitDetails  '+ex.getMessage());
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'An Error Occured'));
           
         } 
          pageReference changeOutfitpage=New pageReference('/apex/OutfitListWithTabs?uname='+username);
          return changeOutfitpage;
    }   
   
  
  
  
   public pageReference Cancel(){
        PageReference changeFirstpage = new PageReference('/apex/OutfitListWithTabs');
        return changeFirstpage ;
   }
   
   public PageReference Signup() {
        return page.OutfitSignupPage;
   }

   public PageReference Signin() {
      System.debug('Before Try Account username--->'+username);
      try{  
        list<Account> verify=[select id,password__C from Account where Email__c=:username];
        System.debug('Account username--->'+ username);
        if(!verify.isempty())
        if(verify[0].password__c==password)
        {
            accid=verify[0].id;
            system.debug('Account id------------>'+accid);
            Account=[select id,name from Account where id=:accid];
            pageReference changeOutfitpage=New pageReference('/apex/OutfitListWithTabs?uname='+username);
            return changeOutfitpage;
            
            system.debug('Account password------------>'+verify[0].password__C);
        }else{
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Your Password is Wrong'));
        }
         
        return null;
        }catch(Exception ex){
           ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Your Password is Wrong'));
            return null;
        }
    }
   
   public PageReference addToCart() {
        
           try{
           parameters=ApexPages.currentPage().getParameters();
           String oid=parameters.get('oid');
           String pid=parameters.get('pid');
           
           //this.Products=[select Name,ProductCode,Description,Stock__c,Outfit__c,Family,(SELECT UnitPrice FROM PricebookEntries WHERE IsActive=:true),(SELECT Id,Name,ContentType FROM Attachments WHERE ContentType Like 'image%')  from Product2 Where Outfit__c=: ApexPages.currentPage().getParameters().get('oid') AND Id !=:ApexPages.currentPage().getParameters().get('pid')];
           //return null;
           List<Cart__c> carts=[SELECT Id From Cart__c WHERE Account__r.Email__c=:this.username];
           List<Product2> products=new List<Product2>();
           if(carts.isEmpty()){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'cart Not Found'));
                return null;   
            }
           this.Products=[select Name,ProductCode,Description,Stock__c,Outfit__c,Family,(SELECT UnitPrice FROM PricebookEntries WHERE IsActive=:true),(SELECT Id,Name,ContentType FROM Attachments WHERE ContentType Like 'image%')  from Product2 Where Outfit__c=: ApexPages.currentPage().getParameters().get('oid') AND Id !=:ApexPages.currentPage().getParameters().get('pid')];
           for(product2 prod : this.Products ){
           
                 prod.Cart__c=carts[0].Id;
                 system.debug('OutfitListWithTabs.carts[0].Id--->'+carts[0].Id);
                 products.add(prod);
                 system.debug('OutfitListWithTabs.prod--->'+prod);
            }
           System.debug('OutfitController.addToCart  products  '+products); 
           if(!products.isEmpty())
                   update products;
            //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info,'Product Is Added To The cart Successfully.......'));
            
            system.debug('OutfitListWithTabs.username'+this.username);
            return null;  //new PageReference('/apex/OutfitListWithTabs?email='+this.username);
            }catch(Exception ex){
            System.debug('Exception In OutfitListWithTabcontroller.addToCart  '+ex.getMessage());
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'An Error Occured'));
            return null;
        }
    }


    public void OutfitProducts() {
       try{
        Products=[select Name,ProductCode,Description,Stock__c,Outfit__c,(SELECT UnitPrice FROM PricebookEntries WHERE IsActive=:true),(SELECT Id,Name,ContentType FROM Attachments WHERE ContentType Like 'image%')  from Product2 Where Outfit__c=: ApexPages.currentPage().getParameters().get('ofid') AND Cart__c!=NULL];
        system.debug('OutfitProducts.Products----->'+Products); 
      }catch(Exception ex){
        
        }  
        
    }
    
     public PageReference logout() {
        return page.outfitloginpage;
    }

     
    
    public List<ProductWrapper> getProductList() {
      
         system.debug('productOutfit id-------------->'+ApexPages.currentPage().getParameters().get('oid'));
         system.debug('product id-------------->'+ApexPages.currentPage().getParameters().get('pid'));
         for(Product2 ol :[select Name,ProductCode,Description,Stock__c,Outfit__c,Family,(SELECT UnitPrice FROM PricebookEntries WHERE IsActive=:true),(SELECT Id,Name,ContentType FROM Attachments WHERE ContentType Like 'image%')  from Product2 Where Cart__c IN (SELECT Id FROM Cart__c Where Account__r.Email__c=:this.username) AND ID=:ApexPages.currentPage().getParameters().get('pid') order by CreatedDate  desc]){
            proList.add(new ProductWrapper(ol,ProductSetId.contains(ol.id)));
            
         }
         
         return proList;
    }
    
    public PageReference RemovefromCart() {
       
       this.Products=[select Name,ProductCode,Description,Stock__c,Outfit__c,Family,(SELECT UnitPrice FROM PricebookEntries WHERE IsActive=:true),(SELECT Id,Name,ContentType FROM Attachments WHERE ContentType Like 'image%')  from Product2 Where Outfit__c=: ApexPages.currentPage().getParameters().get('oid') AND ID=:ApexPages.currentPage().getParameters().get('pid')];
       pageReference removeproduct=New pageReference('/apex/OutfitListWithTabs?uname='+username);
       return removeproduct; 
    }

   
    public PageReference addRecord() {
        parameters=ApexPages.currentPage().getParameters();
        String schId=parameters.get('schId');
        System.debug('component.schid-------------->'+schId);
        Product2 Rec=[select Name,ProductCode,Description,(SELECT Id,Name,ContentType FROM Attachments WHERE ContentType Like 'image%')  from Product2 where id=:ApexPages.CurrentPage().getParameters().get('schId')];
        integer A=0;
        boolean CheckBox=false;
        A=selectedList.size();
        if(A>0)
            for (Integer i = A-1; i >= 0 ;i-- ) {
                if (selectedList.get(i) == Rec || selectedList.get(i).get('id') == Rec.get('id')) {
                    selectedList.remove(i); 
                    ProductSetId.remove((ID)Rec.get('id'));
                    CheckBox=true;
                }
            }
        if(CheckBox==false)
        {
            selectedList.add(Rec);
            ProductSetId.add(Rec.id);
        }
        return null;
    }
   
   
   
    public class ProductWrapper{
    public Product2 pr{get;set;}
    public Boolean CheckBox{get;set;}
    public ProductWrapper(Product2 prod, Boolean check){
            pr = prod;
            CheckBox = check;
        }
    }
}