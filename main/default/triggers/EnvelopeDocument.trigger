trigger EnvelopeDocument on DocuObj__c (after insert) {
        DocsignDocument.Document(trigger.newMap.Keyset());
}