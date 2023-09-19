# aws-nora-iac-v2
Infrastructure as Code for the Nora Application

## Workspace link
PTFE Workspace: https://ptfe.nylcloud.com/app/nyl-nora-<<env>env>/workspaces

## GitHub link
**GitHub**: https://git.nylcloud.com/RND/aws-nora-iac-v2

**Branches or <<env>env> allowed**: dev, qa, stage, prod

## Pre-Requisites Steps

1. Create a PTFE workspace. eg. aws-nora-iac-v2-<<env>env>

2. Configure GitHub and respective source version.

3. Provide the following as a variable to workspace:
    * **key_name** - Key Pair to run the servers, for Production this might be set to blank
    * **lob** - nora
    * **env** - dev, qa, stage, prod
    * **assume_role_arn** - Assume AWS role
    * **external_id** - AWS External ID
    * **ghe_token** - GitHub Machine User Token to allow connection between Code Build and Enterprise GitHub
    * **eis_oauth_client_id** - EIS token ID received from EIS team
    * **eis_oauth_client_secret** - EIS token Secret received from EIS team

4. Make sure the ACM Certificates are already present in the AWS account with Domain name and Additional Names as shown below:

    * **Domain Name**: 
       * <<env>env>.nora.insure.nylcloud.com
    * **Additional Names**: 
       * <<env>env>.app.nora.insure.nylcloud.com
       * <<env>env>.filestore.nora.insure.nylcloud.com
       * <<env>env>.validator.nora.insure.nylcloud.com

## Next Steps

5. Run the Workspace.

6. Once have the successful run, the AWS resources shall be provisioned.

7. Map the Load Balancers to the respective URL's.

    * **frontend-<<env>env>-lb** should be mapped to **https://<<env>env>.nora.insure.nylcloud.com**
    * **backend-<<env>env>-lb** should be mapped to **https://<<env>env>.app.nora.insure.nylcloud.com**
    * **midlwre-berwyn-<<env>env>-lb** should be mapped to **https://<<env>env>.validator.nora.insure.nylcloud.com**
    * **midlwre-encrypt-<<env>env>-lb** should be mapped to **https://<<env>env>.filestore.nora.insure.nylcloud.com**
  
8. Please take a note of the Cognito **User Pool Id** and the **Domain Name** in the AWS Cognito under Manage User Pool and **nora-<<env>env>-user-pool**.
  
9. Create a RITM ticket to Authentication_Security_L2 with the Cognito User Pool Id and Domain name in above step, and ask for the SAML file. This is needed to allow users to login to the application using their TID and Password.

10. Once you have the SAML file, come back to **nora-<<env>env>-user-pool** in AWS Cognito and follow below steps:
    * Under **Federation**, Click on the **SAML** button.
    * Upload the SAML file under Metadata Document.
    * Provider name should be **NYLPing**
    * Click on create provider.
    * Once created, go to Attribute Mapping and Select SAML.
    * From the Dropdown, Select NYLPing and then start mapping below attributes in a Key Value format. Here key is SAML Attribute and value is selected from the dropdown. Make a similar selection as shown below, exactly as shown:
      * **GroupName** to Profile
      * **FirstName** to Name
      * **LastName** to FamilyName
      * **email** to Email
    * Make sure all four attributes are selected. Above email attribute is email and not Email.
    * Go to **App Client Settings** and Select NYLPing and De-Select Cognito User Pool. 
    * Also make sure under OAuth 2.0 in **App Client Settings** following attributes are selected.
      * Authorization code grant
      * Implicit grant
      * email
      * openid
      * aws.cognito.signin.user.admin
      * profile
    * Click Save Changes.

11. You should be all set and should be able to access the website on NYL VPN.

## **IMPORTANT NOTE:**
_With every run of Terraform, it is must to got AWS account and change the Idenity provider to NYLPing from Cognito User pool under App Client Settings in Cognito._
