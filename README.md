# T-FLIP Implementation Guide

It is advised to deploy T-FLIP to a new namespace. The following production has been developed using Intersystems technology and Postgres, if an alternative DBMS is to be used then the queries will have to be updated.

The following steps can be followed to implement T-FLIP:

1. Save Production XML file to trust server

2. Create new namespace:
Open Intersystems Management portal -> System Administration -> Configuration -> System Configuration -> NameSpaces -> Create new namespace -> Enter a suitable name for the namespace 'FLIP' -> Create new database -> choose suitable directory to hold the IRIS database

3. Create new production

Interoperability -> Configure -> Production -> New ->  Name the production "FLIP.Production" -> Choose Generic production

5. Deploy production 

Interoperability -> Manage -> Deployment changes -> Deploy -> Open deployment -> find production XML file -> Select target production -> deploy

6. Check to see if production components are visible 

Interoperability -> 


6. Set up OBDC connection to database if it does not already exist on the server
7. Import csv files for DICOM mappings
8. Import T-FLIP message schema 
9. Import lookup tables FLIP_Gender and FLIP_Configuration
10. Download Apache Tika from the following link:https://tika.apache.org/download.html (version 2.6 was used for testing)
11. Update the following T-FLIP components: 
- DSN for 'Doc_InvokeHistoricIngestion','Img_InvokeHistoricIngestion' and 'ExecuteQuery' with the name of the OBDC that has been set up 
-  Port numbers on components '' and '' for receiving ORU and MDM HL7 messages
- 'TempFileConvertorFolder' on components Doc_ProcessHistoricData and Doc_ProcessMDM with an appropriate location to temporarily store files during the text extraction process
- 'TikaFilePath' on components Doc_ProcessHistoricData and Doc_ProcessMDM with the location of .jar file downloaded
- 'URL' and 'FLIPAuthorisation' on HTTP_SendToFlip - the endpoint and Authorisation details will be sent seperately
.
