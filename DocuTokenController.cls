public class DocuTokenController {
    public static String clientId = 'd6920582-3574-49ef-9c64-28e75689801c';
    public static String clientSecret = 'f8bd9ed6-3d27-4bd0-845d-80a733d44702';
    public static String redirectUri = 'https://brave-goat-czzfn-dev-ed--c.trailblaze.vf.force.com/apex/DocuController';
    public static String authEndpoint = 'https://account-d.docusign.com/oauth/auth';
    public static String tokenEndpoint = 'https://account-d.docusign.com/oauth/token';
    public static String responseType = 'code';
    public static String grantType = 'authorization_code';
    public static id oppId{get;set;}
    public static string accessToken;
    //public static String state = 'your_state';
    
    public String authorize() {
        String authUrl = authEndpoint +
            '?response_type=' + responseType +
            '&client_id=' + clientId +
            '&redirect_uri=' + redirectUri +
            '&scope=' + 'signature' ;
        //'&state=' + state;
        return authUrl;
    }
    
    public static String getAccessToken() {
        String code = ApexPages.currentPage().getParameters().get('code');
        system.debug(code);
        HttpRequest req = new HttpRequest();
        req.setEndpoint(tokenEndpoint);
        req.setMethod('POST');
        // req.setHeader('Content-Type', 'application/x-www-form-urlencoded');
        req.setHeader('Authorization', 'Basic ' + EncodingUtil.base64Encode(Blob.valueOf(clientId + ':' + clientSecret)));
        req.setBody('grant_type=' + grantType +'&code=' + code);
        //'&redirect_uri=' + redirectUri +
        // '&client_id=' + clientId +
        // '&client_secret=' + clientSecret);
        Http http = new Http();
        HttpResponse res = http.send(req);
        
        Map<String, Object> responseMap = (Map<String, Object>)JSON.deserializeUntyped(res.getBody());
        
        accessToken=(String)responseMap.get('access_token');
        return (String)responseMap.get('access_token');
        
    }
    
    public static void saveAccessToken() {
        List<Docusign__c> docuList = [SELECT access_token__c FROM Docusign__c WHERE Name = 'First'];
        
        String accessToken = getAccessToken();
        
        if (!docuList.isEmpty()) {
            Docusign__c Docu = docuList[0];
            Docu.access_token__c = accessToken;
            upsert Docu;
        }
    }
}