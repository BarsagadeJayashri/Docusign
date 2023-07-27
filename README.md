# DocuSign-Integration-with-Salesforce

This repository offers a comprehensive solution for seamlessly integrating Salesforce with DocuSign, empowering Salesforce users to complete the Non-Disclosure Agreement (NDA) process entirely within Salesforce.

## Pre-requisites:

Before implementing this solution, ensure that the following pre-requisites are fulfilled:

Create an App in DocuSign: Set up an App in DocuSign to facilitate the integration and enable smooth data exchange between Salesforce and DocuSign.

Create Webhook in Salesforce: Establish a webhook in Salesforce to enable seamless communication and data synchronization with DocuSign.

Salesforce Account: Have access to a Salesforce account with necessary privileges to access the Lead object.

DocuSign Account: Ensure that your DocuSign account has API access enabled.

## Installation:

To set up the integration, follow these steps:

Connect DocuSign with Salesforce by creating a webhook and setting up the App (create a Quickbook Account in DocuSign).

Create custom objects named "DocuObj" and "DocuSign" in Salesforce to effectively manage and store DocuSign-related data.

Import and deploy the provided Apex classes and triggers into your Salesforce environment.

## Features:

This integration solution is designed to offer the following key features:

NDA Template Creation: Users can create NDA templates directly within Salesforce by simply clicking a button. The templates can be customized as needed.

Efficient Signature Process: The solution enables a streamlined NDA signature process, ensuring a smooth exchange of documents between receiving and disclosing parties. Once both parties have signed the NDA, the document is automatically retrieved and stored within Salesforce.

By implementing this solution, your organization can optimize the NDA process, allowing Salesforce users to efficiently handle NDAs within the Salesforce platform.

For detailed usage instructions and additional information, please refer to the documentation provided in the repository.
