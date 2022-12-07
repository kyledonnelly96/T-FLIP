# T-FLIP Implementation Guide

The following production has been developed using Intersystems technology and Postgres for database management, if an alternative DBMS is to be used then the queries will have to be updated. This guide assumes the staging tables have been already created on postgres. If not, go to page 8 on the following guide: https://docs.google.com/document/d/1dzqWKm4k0zYn-9zFc2bqY-Ohqk3n1bqvXnD8PMobWKw/edit# and use the create scripts.

The following steps can be followed to implement T-FLIP:

1. Save Production XML file 'TFLIP.Production' to trust server

2. Create new namespace:
Open Intersystems Management portal -> System Administration -> Configuration -> System Configuration -> NameSpaces -> Create new namespace -> Enter a suitable name for the namespace 'FLIP' -> Create new database -> choose suitable directory to hold the IRIS database

More details can found here: https://docs.intersystems.com/latest/csp/docbook/DocBook.UI.Page.cls?KEY=EESB_CONFIGURE_SYSTEM#:~:text=Select%20System%20Administration%20%3E%20Configuration%20%3E%20System,button%20for%20the%20globals%20database.

3. Deploy production 

Interoperability -> Manage -> Deployment changes -> Deploy -> Open deployment -> find production XML file -> Select target production -> deploy

More details of this can be found here: https://docs.intersystems.com/irislatest/csp/docbook/DocBook.UI.Page.cls?KEY=EGDV_deploying

4. Check to see if production components are visible 

Interoperability -> Configure -> Production -> If not then the press open -> Select Production

5. Set up OBDC connection to database if it does not already exist on the server

6. Download Apache Tika from the following link:https://tika.apache.org/download.html (version 2.6 was used for testing)

7. Update the following T-FLIP components: 
- DSN for 'Doc_InvokeHistoricIngestion','Img_InvokeHistoricIngestion' and 'ExecuteQuery' with the name of the OBDC that has been set up 
-  Port numbers on components 'TestHL7In' and 'TestMDMIn' for receiving ORU and MDM HL7 messages (UPDATE NAMES)
- 'TempFileConvertorFolder' on components Doc_ProcessHistoricData and Doc_ProcessMDM with an appropriate location to temporarily store files during the text extraction process
- 'TikaFilePath' on components Doc_ProcessHistoricData and Doc_ProcessMDM with the location of .jar file downloaded
- 'URL' and 'FLIPAuthorisation' on HTTP_SendToFlip - the endpoint and Authorisation details will be sent seperately

