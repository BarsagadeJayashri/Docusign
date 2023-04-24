public class DocsignDocument {
    
    @future (callout=true)
    public static void Document(set<id> docList){
        for (Id doc : docList) {
            DocuObj__c objDoc= new DocuObj__c();
              objDoc=  [select Id,Envelope_Id__c,Document_Id__c,Envelope_Status__c from DocuObj__c where Id=:doc];
            if(objDoc.Envelope_Status__c=='Completed'){
            String envelopeId = objDoc.Envelope_Id__c;
            String documentId = objDoc.Document_Id__c;
            Lead objLead =[Select Id, Envelope_Id__c FROM Lead where Envelope_Id__c=: envelopeId];
            String accessToken; 
            List<Docusign__c> docuList = [SELECT access_token__c FROM Docusign__c WHERE Name = 'First'];
            if(!docuList.isEmpty()){
                Docusign__c Docu = docuList[0];
                accessToken = Docu.access_token__c;
            } else {
                System.debug('No record');
                return;
            }
            
            HttpRequest request = new HttpRequest();
            request.setEndpoint('https://demo.docusign.net/restapi/v2.1/accounts/300fc488-1ea1-4669-9f98-c3bdeba1ca5a/envelopes/' + envelopeId + '/documents/' + documentId);
            request.setMethod('GET');
            request.setHeader('Authorization', 'Bearer ' + accessToken);
            request.setHeader('Content-Transfer-Encoding', 'base64');
            Http http = new Http();
            HttpResponse response = http.send(request);
            Attachment att = new Attachment();
            system.debug('@@@@@@'+response.getBody());
            if (response.getStatusCode() == 200){
                att.Name = 'Lead Document'+documentId;
                att.Body = EncodingUtil.base64Decode(response.getBody());
                att.ParentId = objLead.Id;
                att.ContentType = 'application/pdf';
                
            } else {
                System.debug('Error: ' + response.getStatusCode());
            }
            insert att;
            }
        }
        
    }
}