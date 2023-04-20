public class NDASave {
    public static Id RecordId {get;set;}
    public static Lead objLead{get;set;}
    public static String PDFNo{get;set;}
    public static String EFNo{get;set;}
    public static boolean show{get;set;}
    public static boolean showpdf{get;set;}
    public static ApexPages.PageReference page2{get;set;}
    
    public String errorMessage { get; set; } // Property to store error message
    public String successMessage { get; set; } // Property to store success message

    
    public NDASave(ApexPages.StandardController controller){
        RecordId  = ApexPages.currentPage().getParameters().get('id');
        objLead =[select Id,Name,Title, Address from Lead where Id =: RecordId];        
    }
    
    
    
    
    
    @future(callout=true)
    public static  void save(){
        PageReference savepage ;
        savepage = Page.VfDocument;
        savepage.getParameters().put('id',RecordId);
        system.debug('id:- '+RecordId);
        blob pdfBlob;
        if (!Test.isRunningTest()) {
            pdfBlob = savepage.getContent(); //generate the pdf blob
        } else { 
            pdfBlob = Blob.valueOf('Test');
        }
        List<ContentDocumentLink> notesattch = [select id, ContentDocument.Title,LinkedEntityId from ContentDocumentLink where LinkedEntityId =: RecordId order by ContentDocument.Title asc];    
        list<string> docId = new list<string>();
        system.debug('notesattch## ' + notesattch);
        PageReference savepage2 = Page.VfDocument;
        ContentDocumentLink conDocLink = New ContentDocumentLink();
        ContentVersion conVer = new ContentVersion();
        
        
        
        
        
        
        
        
        /* if(notesattch.size() > 0)
{
string title =  notesattch[0].ContentDocument.Title;
system.debug('title111 ' + title);
List<String> titleSplit = title.split('R');
//String FinalTitle = titleSplit[0]+'R0'+notesattch.size();
String FinalTitle = 'R0'+notesattch.size();
system.debug('FinalTitle22 ' + FinalTitle);
PDFNo=FinalTitle;


conVer.ContentLocation = 'S'; // to use S specify this document is in Salesforce, to use E for external files
conVer.PathOnClient = FinalTitle+'.pdf'; 
conVer.Title = FinalTitle; 
conVer.VersionData = pdfBlob;
system.debug('conVer@@ ' + conVer);
insert conVer;  

Id conDoc = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:conVer.Id].ContentDocumentId;


conDocLink.LinkedEntityId = RecordId;
conDocLink.ContentDocumentId = conDoc; 
conDocLink.shareType = 'V';
insert conDocLink;
//update accObj;

show=false;
showpdf=true;
savepage2.getParameters().put('id',RecordId);
//if(!show)
// savepage2.getParameters().put('show','0');
// savepage2.setRedirect(true);

}
else{

//ContentVersion conVer = new ContentVersion();
conVer.ContentLocation = 'S'; // to use S specify this document is in Salesforce, to use E for external files
conVer.PathOnClient = PDFNo+'.pdf'; 
conVer.Title = 'R00'; 
conVer.VersionData = pdfBlob;
insert conVer;  

Id conDoc = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:conVer.Id].ContentDocumentId;

//ContentDocumentLink conDocLink = New ContentDocumentLink();
conDocLink.LinkedEntityId = RecordId;
conDocLink.ContentDocumentId = conDoc; 
conDocLink.shareType = 'V';
insert conDocLink;
//Addtext = 'File Attached';

//update accObj;

show=false;
showpdf=true;
//Cafactionpage;CAFFormPDF
savepage2.getParameters().put('id',RecordId);
//  if(!show)
//savepage2.getParameters().put('show','0');
//savepage2.setRedirect(true);


}
docId.add(conVer.Id);*/
        
        list<Lead> DD = new List<Lead>();
        Lead l = [SELECT id, Name, Title, Company, Email, Address FROM Lead WHERE Id =:RecordId];
        //Docusign__c Docu = [SELECT access_token__c FROM Docusign__c WHERE Name = 'First' LIMIT 1];
        //String accessToken = Docu.access_token__c;
        String accessToken;
        List<Docusign__c> docuList = [SELECT access_token__c FROM Docusign__c WHERE Name = 'First'];
        if(!docuList.isEmpty()){
            Docusign__c Docu = docuList[0];
            accessToken = Docu.access_token__c;
        } else {
            System.debug('No record');
        }
        system.debug('@@'+l);
        
        
        Http http = new Http();
        HttpRequest request = new HttpRequest(); 
        request.setEndpoint('https://demo.docusign.net/restapi/v2/accounts/300fc488-1ea1-4669-9f98-c3bdeba1ca5a/envelopes');
        request.setMethod('POST');
        request.setHeader('Authorization', 'Bearer ' + accessToken);
        request.setHeader('Content-Type', 'application/json');
        String ndaBase64 = EncodingUtil.base64Encode(pdfBlob);
        
        String payload1 = '{' +
            '"status": "sent",' +
            '"emailSubject": "Please sign the NDA",' +
            '"documents": [{' +
            '"documentBase64": "' +ndaBase64 + '",' +
            '"name": "NDA Document",' +
            '"fileExtension": "txt",' +
            '"documentId": "1"' +
            '}],' + 
            '"recipients": {' +
            '"signers": [{' +
            '"email": "' +l.Email+ '",' +
            '"name": "' + l.Name + '",' +
            '"recipientId": "1",' +
                '"routingOrder": "2",' + 

            '"tabs": {' + 
            '"signHereTabs": [{' +                   
            '"xPosition": "90",' +
            '"yPosition": "390",' +
            '"documentId": "1",' +
            '"pageNumber": "2"' +
            '}],' +
            '"dateSignedTabs": [{' +
            '"tabLabel": "Date Signed",' +
            '"xPosition": "95",' +
            '"yPosition": "485",' +
                        '"autoPlace": "true",' +  // Enable AutoPlace feature

            '"documentId": "1",' +
            '"pageNumber": "2"' +
            '}],' +
            '"textTabs": [{' +
            '"tabLabel": "This agreement is made on ",' +
            '"value": "' + String.valueOf(Date.today()) + '"' +
            '}, {' +
            /*'"tabLabel": "Date:",' +
            '"value": "",' +
            '"xPosition": "90",' +
            '"yPosition": "600",' +
            '"documentId": "1",' +
            '"pageNumber": "2"' +
            '}, {' +*/
            '"tabLabel": "By: ",' +
            '"value": "' + l.Company + '"' +
            '}, {' +
            '"tabLabel": "Name:",' +
            '"value": "'+ l.Name +'"' +
            '}, {' +
            '"tabLabel": "Title:",' +
            '"value": "'+ l.Title +'"' +
            '}, {' +
            '"tabLabel": "Address:",' +
            '"value": "'+ l.Address +'"' +
            '}]' +
            '}' +
            '}, {' +
            '"email": "' + UserInfo.getUserEmail()+ '",' +
            '"name": "' + UserInfo.getName() + '",' +
            '"recipientId": "2",' +
                '"routingOrder": "1",' + 

            '"tabs": {' + 
            '"signHereTabs": [{' +                   
            '"xPosition": "350",' +
            '"yPosition": "390",' +
            '"documentId": "1",' +
            '"pageNumber": "2"' +
            '}],' +
            '"dateSignedTabs": [{' +
            '"tabLabel": "Date Signed",' +
            '"xPosition": "360",' +
            '"yPosition": "485",' +
                        '"autoPlace": "true",' + 

            '"documentId": "1",' +
            '"pageNumber": "2"' +
            '}],' +
            '"textTabs": [{' +
            '"tabLabel": "This agreement is made on ",' +
            '"value": "' + String.valueOf(Date.today()) + '"' +
            '}, {' +
            /*'"tabLabel": "Date:",' +
            '"value": "",' +
            '"xPosition": "360",' +
            '"yPosition": "600",' +
            '"documentId": "1",' +
            '"pageNumber": "2"' +
            '}, {' +*/
            '"tabLabel": "By: ",' +
            '"value": "' + UserInfo.getOrganizationName() + '"' +
            '}, {' +
            '"tabLabel": "Name:",' +
            '"value": "' + UserInfo.getName() + '"' +
            '}, {' +
            '"tabLabel": "Title:",' +
            '"value": " Salesforce Developer"' +
            '}, {' +
            '"tabLabel": "Address:",' +
            '"value": " New Delhi"' +
            '}]' +
            '}' +
            '}' +
            ']}' +
            
            '}';
        
        
        request.setBody(payload1);
        HttpResponse response = http.send(request);
        system.debug('@@@@@@@'+response.getStatusCode());
        if (response.getStatusCode() == 201) {
            
            Map<String, Object> responseMap = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
            String envelopeId = (String) responseMap.get('envelopeId');
            
            l.Envelope_Id__c = envelopeId;
            DD.add(l);
        } else {
            System.debug('#######'+response.getBody());
        }
        upsert DD;
        

if ( DD.size()==0) {


ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Something went wrong...!!!'));

}

else{
ApexPages.addMessage(new ApexPages.message(ApexPages.severity.CONFIRM,'NDA sent successfully.')); 

}

        //return savepage2;
    }    
    
    
    /* 
Public class SendEmail
{
public String subject {get; set;}
public String body {get; set;}

private opportunity opp;

// Constructor to populate instance of your object
public SendEmail(ApexPages.StandardController controller) {
this.objInvoice= (Invoice_c )controller.getRecord();
objInvoice= [SELECT Invoice fields required
FROM objInvoice
WHERE id = :ApexPages.CurrentPage().getParameters().get('id')];
}

public objInvoice getInvoice(){
return objInvoice;
}
*/
    
    public pageReference send(){
        
        return null;  
    }
    
}