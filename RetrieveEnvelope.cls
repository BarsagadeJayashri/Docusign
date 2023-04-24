@RestResource(urlMapping='/docusignWebhook/*')
global with sharing class RetrieveEnvelope {
    
    @HttpPost
    global static void getDocuSignDetails() {
        RestRequest req = RestContext.request;
        String requestBody = req.requestBody.toString();
        System.debug('Request Body: ' + requestBody);
        
        Map<String, Object> parsedMap = (Map<String, Object>)JSON.deserializeUntyped(requestBody);
        Map<String, Object> dataMap = (Map<String, Object>)parsedMap.get('data');
        Map<String, Object> envelopeSummary = (Map<String, Object>)dataMap.get('envelopeSummary');
        List<Object> envelopeDocuments = (List<Object>)envelopeSummary.get('envelopeDocuments');
         
        String envelopeId = (String)dataMap.get('envelopeId');
        String event = (String)envelopeSummary.get('status');
        String signedDateStr = (String)parsedMap.get('generatedDateTime');
        Date generatedDateTime = Date.valueOf(signedDateStr);
        String documentId = (String)((Map<String, Object>)envelopeDocuments[0]).get('documentId');
        
       list<DocuObj__c> doc =new   list<DocuObj__c>();
          doc=  [select Id,Envelope_Id__c,Envelope_Status__c,Signed_Date__c,Document_Id__c from DocuObj__c ];
        
        map<string,DocuObj__c> docMap = new map<string,DocuObj__c>();
        for(DocuObj__c obj: doc){
			docMap.put(obj.Envelope_Id__c,obj);
        }
        DocuObj__c newDocuSign = new DocuObj__c();
        if(docMap.containsKey(envelopeId)){
            newDocuSign.Id = docMap.get(envelopeId).Id;
            system.debug(docMap.get(envelopeId).Id);
        }
        newDocuSign.Envelope_Id__c = envelopeId;
        
        newDocuSign.Signed_Date__c = generatedDateTime;
        newDocuSign.Document_Id__c = documentId;
        
        
        // Update Envelope_Status__c field in Salesforce based on event
        if (event.equalsIgnoreCase('completed')) {
            newDocuSign.Envelope_Status__c = 'Completed';
        } else if (event.equalsIgnoreCase('sent')) {
            newDocuSign.Envelope_Status__c = 'In Process';
        }
        
        upsert newDocuSign Id;
        
       /*   Map<String, Object> docMap =  (Map<String, Object>)envelopeDocuments[0];
        String documentContentBase64 = (String)docMap.get('PDFBytes');
        Blob documentContent = EncodingUtil.base64Decode(documentContentBase64);
        
        Attachment att = new Attachment();
        att.Name = (String)docMap.get('name')+'.pdf';
        att.ParentId = newDocuSign.Id;
        att.Body = documentContent;
        insert att;
        */
    }
}