# T-FLIP Implementation Guide

It is advised to deploy T-FLIP to a new namespace. The following production has been developed using Intersystems technology and Postgres, if an alternative DBMS is to be used then the queries will have to be updated

1. Save XML file to trust server
2. Open studio -> Tools -> Import Local -> Import XML file
3. Create new namespace 
4. Deploy production 
5. Set up OBDC connection to database if it does not already exist on the server
6. Import csv files for DICOM mappings
7. Import T-FLIP message schema 
8 Import lookup tables FLIP_Gender and FLIP_Configuration
9. Download Apache Tika from the following link:https://tika.apache.org/download.html (version 2.6 was used for testing)
10. Update the following T-FLIP components: 
- DSN for 'Doc_InvokeHistoricIngestion','Img_InvokeHistoricIngestion' and 'ExecuteQuery' with the name of the OBDC that has been set up 
-  Port numbers on components '' and '' for receiving ORU and MDM HL7 messages
- 'TempFileConvertorFolder' on components Doc_ProcessHistoricData and Doc_ProcessMDM with an appropriate location to temporarily store files during the text extraction process
- 'TikaFilePath' on components Doc_ProcessHistoricData and Doc_ProcessMDM with the location of .jar file downloaded on step 8
- 'URL' and 'FLIPAuthorisation' on HTTP_SendToFlip - the endpoint and Authorisation details will be sent seperately
