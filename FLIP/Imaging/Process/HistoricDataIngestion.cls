Class FLIP.Imaging.Process.HistoricDataIngestion Extends Ens.BusinessProcess [ ClassType = persistent ]
{

Method OnRequest(pInput As EnsLib.SQL.Snapshot, Output pResponse As Ens.Response) As %Status
{

	set t=$$$OK

	$$$TRACE("HELLO")
	

	#DIM RS As EnsLib.SQL.Snapshot
	Set RS = pInput
	

	while RS.Next()
	{
		set newRecords=RS.Get("numbRec_toProcess")
	}
		
	set rowsToInsert=##class(Ens.Util.FunctionSet).Lookup("FLIP.Configuration","img_historic_recordsToSend")
	$$$TRACE("Minimum rows required: "_rowsToInsert)
	$$$TRACE("Records available: "_newRecords)
	if newRecords<rowsToInsert
	{
		$$$TRACE("Not enough records available")
		quit t
			
	}	

		
		
	//Grab next batch
	set imgReq=##class(FLIP.Classes.RequestImagingData).%New()
	set qry="SELECT imgres_rowid, pat_nhs, pat_mrn, pat_sex, pat_name, pat_dob, pat_dod, pat_nhstracest, ires_fillerid, ires_accessionid, ires_procedurecode, ires_procedurename, ires_modality, ires_performedby, ires_bodysite, ires_laterality, ires_sopclassid, ires_seriesid, ires_instanceid,ires_dateofstudy, ires_obsdttm, ires_obsvalue "
	set qry=qry_"FROM tflip.imaging_results WHERE rec_process='0' AND pat_nhstracest='01' "
	set qry=qry_"AND NOT (pat_nhs='' OR ires_accessionid='' OR ires_procedurecode='' OR ires_procedurename='' OR ires_modality='' OR ires_dateofstudy='')"
	set qry=qry_"ORDER BY imgres_rowid ASC LIMIT "_rowsToInsert
	$$$LOGINFO(qry)
	set imgReq.Query=qry

	set sc=..SendRequestSync("ExecuteQuery",imgReq,.imgRes)
	IF $$$ISERR(sc) $$$ThrowStatus(sc)
	#DIM imgRes As EnsLib.SQL.GatewayResultSet
	

	if imgRes.RowCount>0
	{
		set count=0
		
		while imgRes.Next()
		
		{
			set img=##class(FLIP.Classes.Images).%New()
			set pat=##class(FLIP.Classes.Patient).%New()
			

			
			set pat.nhs=imgRes.Get("pat_nhs")
			set pat.sex=imgRes.Get("pat_sex")
			set pat.dob=imgRes.Get("pat_dob")
			IF imgRes.Get("pat_dod")'="" set pat.dod=imgRes.Get("pat_dod")
	
			set img.Patient=pat
			
			set img.observationValue=imgRes.Get("ires_obsdttm")
			set img.fillerID=imgRes.Get("ires_fillerid")
			set img.accessionID=imgRes.Get("ires_accessionid")
			set img.procedureCode=imgRes.Get("ires_procedurecode")
			set img.procedureName=imgRes.Get("ires_procedurename")
			set img.modalityCode=imgRes.Get("ires_modality")
			set img.laterality=imgRes.Get("ires_laterality")
			set img.bodysiteCode=imgRes.Get("ires_bodysite")
			set img.sopclassUID=imgRes.Get("ires_sopclassid")
			set img.seriesUID=imgRes.Get("ires_seriesid")
			set img.instanceUID=imgRes.Get("ires_instanceid")
			set img.peformedBy=imgRes.Get("ires_performedby")

			IF imgRes.Get("ires_obsvalue")'="" set img.observationValue=imgRes.Get("ires_obsvalue")
			if imgRes.Get("ires_dateofstudy")'="" set img.dateOfStudy=imgRes.Get("ires_dateofstudy")_"0000"
			if imgRes.Get("ires_obsdttm")'="" set img.obsdttm=imgRes.Get("ires_obsdttm")
		
			
			if count=0 set startID=imgRes.Get("imgres_rowid")
			set count=count+1
			set endID=imgRes.Get("imgres_rowid")
			
			
				
			set sc=..SendRequestSync("FHIRProcessor",img,.sc)
					
		
		}
		
		IF '$$$ISERR(sc)
		{
			//Update records as processed
			set req=##class(FLIP.Classes.UpdateRecProcessed).%New()
			set sqlSt="UPDATE tflip.imaging_results SET rec_process='TRUE' WHERE imgres_rowid >= "_startID_" AND imgres_rowid <="_endID
			set req.qry=sqlSt
			set sc=..SendRequestSync("ExecuteQuery",req)
		
			
		}	
		
	}
	else
	{
		$$$TRACE("Missing data in available rows")
	
		
	}	
	
END	
	quit t
}

Storage Default
{
<Type>%Storage.Persistent</Type>
}

}
