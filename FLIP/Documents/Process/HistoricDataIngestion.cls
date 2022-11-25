Class FLIP.Documents.Process.HistoricDataIngestion Extends Ens.BusinessProcess [ ClassType = persistent ]
{

Property TempFileConverterFolder As %String [ InitialExpression = "C:\Users\Administrator\Kyle" ];

Parameter SETTINGS = "TempFileConverterFolder";

Method OnRequest(pInput As Ens.Request, Output pResponse As Ens.Response) As %Status
{

	set t=$$$OK
	
	#DIM RS As EnsLib.SQL.Snapshot
	Set RS = pInput
	

	while RS.Next()
	{
		set newRecords=RS.Get("numbRec_toProcess")
	}
		
	set rowsToInsert=##class(Ens.Util.FunctionSet).Lookup("FLIP.Configuration","doc_historic_recordsToSend") 
	$$$TRACE("Minimum rows required: "_rowsToInsert)
	$$$TRACE("Records available: "_newRecords)
	if newRecords<rowsToInsert
	{
		$$$TRACE("Not enough records available")
		quit t
			
	}
	
	//grab next batch
	
	set docReq=##class(FLIP.Classes.RequestDocumentData).%New()
	set qry="SELECT usdoc_rowid, pat_nhs, pat_mrn, pat_name, pat_dob, pat_sex, pat_dod, pat_nhstracest, usdoc_documentdate, usdoc_uniqueid, usdoc_typeid, usdoc_typename, usdoc_categoryid, usdoc_categoryname, usdoc_contenttype, usdoc_contentref, usdoc_fileextn "
	set qry=qry_"FROM tflip.usdoc_metadata WHERE rec_process=FALSE AND pat_nhstracest='01' "
	set qry=qry_"AND NOT (pat_dob='' OR pat_nhs='' OR usdoc_documentdate='' OR usdoc_uniqueid='' OR usdoc_contentref='')"
	set qry=qry_"ORDER BY usdoc_rowid  ASC LIMIT "_rowsToInsert
	set docReq.Query=qry
	
	set sc=..SendRequestSync("ExecuteQuery",docReq,.docRes)
	IF $$$ISERR(sc) $$$ThrowStatus(sc)
	#DIM docRes As EnsLib.SQL.Snapshot
	
	if docRes.RowCount>0
	{
		SET count=0
		
		while docRes.Next()
		{
			set send=1
			
			set doc=##class(FLIP.Classes.Document).%New()
			set pat=##class(FLIP.Classes.Patient).%New()
			set pat.nhs=docRes.Get("pat_nhs")
	
			set pat.sex=docRes.Get("pat_sex")
			
			set pat.dob=docRes.Get("pat_dob")
			if docRes.Get("pat_dod")'="" set pat.dod=docRes.Get("pat_dod")
			set pat.nhsTraced=docRes.Get("pat_nhstracest")
		
			
			set doc.Patient=pat
			
			set doc.ID=docRes.Get("usdoc_uniqueid")
			set doc.TypeID=docRes.Get("usdoc_typeid")
			set doc.TypeName=docRes.Get("usdoc_typename")
			set doc.CategoryID=docRes.Get("usdoc_categoryid")
			set doc.CategoryName=docRes.Get("usdoc_categoryname")
			set doc.ContentType=docRes.Get("usdoc_contenttype")
			set doc.FileExt=docRes.Get("usdoc_fileextn")
			set doc.documentdate=docRes.Get("usdoc_documentdate")
			
			//check if the document is base64 encoded or reference pointed
			IF docRes.Get("usdoc_contenttype")="ED" //If it is a encrypted document
			{
				set stream=##class(%Stream.GlobalBinary).%New()
				do stream.Write(docRes.Get("usdoc_contentref"))
				set directory=..TempFileConverterFolder
				$$$LOGINFO(directory)
				set filePath=##class(FLIP.Classes.UtilityMethods).DecodeBase64(stream,directory,doc.ID)
		
			
			}
			ELSEIF docRes.Get("usdoc_contenttype")="RP" //it is a referenced pointed document
			{
				set filePath=docRes.Get("usdoc_contentref")
			}
			else
			{
				GOTO END
			}	
		

			
			//file size 
			set fileSize=##class(%File).GetFileSize(filePath)
			set doc.fileSize=fileSize
			set doc.fileName=##class(%File).GetFilename(filePath)
			
			set doc.TextBlock=##class(FLIP.Classes.UtilityMethods).ExtractText(filePath)
			
			
			//grab first and last row id's to update table later
			if count=0 set startID=docRes.Get("usdoc_rowid")
			set count=count+1
			set endID=docRes.Get("usdoc_rowid")
			
			
		

			set t=..SendRequestSync("FHIRProcessor",doc)
			
			

			IF $$$ISERR(t) $$$ThrowStatus(t)
		
		
			}
		
		IF '$$$ISERR(t)
		{
			//Update records as processed
			set req=##class(FLIP.Classes.UpdateRecProcessed).%New()
			set sqlSt="UPDATE tflip.usdoc_metadata SET rec_process='TRUE' WHERE usdoc_rowid >= "_startID_" AND usdoc_rowid <="_endID
			set req.qry=sqlSt
			set sc=..SendRequestSync("ExecuteQuery",req)
			
				
			
		}	
	}		
	
		
	
END	
	q t
}

Storage Default
{
<Data name="HistoricDataIngestionDefaultData">
<Subscript>"HistoricDataIngestion"</Subscript>
<Value name="1">
<Value>TempFileConverterFolder</Value>
</Value>
</Data>
<DefaultData>HistoricDataIngestionDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
