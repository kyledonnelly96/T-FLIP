Class FLIP.Imaging.Process.RealtimeDataIngestion Extends Ens.BusinessProcess [ ClassType = persistent ]
{

Method OnRequest(msg As EnsLib.HL7.Message, Output pResponse As Ens.Response) As %Status
{

	set t=$$$OK


	
	//Grab demographics from PID segment
	//Loop through PID 3 to grab mrn and nhs	
	set mrn="" set nhs="" set dod="" set nhsTrace=""
	
	set x=msg.FindSegmentValues("PID:3(*)")
	for i=1:1:x
		{
			if (msg.FindSegmentValues("PID:3("_i_").5")="NHS") || (msg.FindSegmentValues("PID:3("_i_").5")="NH")
			{
				set nhs=msg.FindSegmentValues("PID:3("_i_").1")
					
			}
			
		}
	//Check trace status
	
	$$$LOGINFO(nhs)
	
	set nhsTrace=msg.FindSegmentValues("PID:32")
	if (nhsTrace'="01") || (nhs="")
	{
		$$$TRACE("NHS NUMBER NOT TRACED - DISCARDING MESSAGE")
		quit t
		
	}	
	
	
	set img=##class(FLIP.Classes.Images).%New()
	set pat=##class(FLIP.Classes.Patient).%New()
	
	
		
	set sex=msg.FindSegmentValues("PID:8")
	set dob=msg.FindSegmentValues("PID:7.1")
	
	//IF death indicator =Y we need to grab DOD
		
		if msg.FindSegmentValues("PID:30")="Y"
		{
			set dod=msg.FindSegmentValues("PID:29")
	
		}
		
	if msg.FindSegmentValues("OBR:4.1")'="" 
	{
		set img.procedureCode= msg.FindSegmentValues("OBR:4.1")
	}

	if msg.FindSegmentValues("OBR:4.2")'="" 
	{
		set img.procedureName=msg.FindSegmentValues("OBR:4.2")
	} 

	SET fillerID=msg.FindSegmentValues("ORC:3.1")
	
	//BODY SITE and Laterality
	set bodySiteCode="" set laterality="" set bodysiteName =""
	
	set bodySiteCode=msg.FindSegmentValues("OBR:15.4")
	
	set laterality=msg.FindSegmentValues("OBR:15.5")
	
	
	if msg.FindSegmentValues("OBR:20.1")'="" 
	{
		set img.accessionID=msg.FindSegmentValues("OBR:20.1")
		
	} 

	
	if msg.FindSegmentValues("OBR:24.1")'="" 
	{
		set img.modalityCode=msg.FindSegmentValues("OBR:24.1")
	}
	
	set obsValue=msg.FindSegmentValues("OBX:5.1")
		
	set obsDttm=msg.FindSegmentValues("OBX:14.1")  
	
	set observer=msg.FindSegmentValues("OBR:32.1")  
	
	if msg.FindSegmentValues("OBR:7.1")'="" 
	{
		set img.dateOfStudy=msg.FindSegmentValues("OBR:7.1")
	}	
	
	//DICOM ID's 
	set seriesUID="" set instanceUID="" set sopclassUID=""
	set seriesUID=msg.FindSegmentValues("ZDI:1")	
	set instanceUID=msg.FindSegmentValues("ZDI:2")
	set sopclassUID=msg.FindSegmentValues("ZDI:3")		
	if obsValue'="" set img.observationValue=obsValue
	if obsDttm'="" set img.obsdttm=obsDttm
	set img.fillerID=fillerID
	if laterality'="" set img.laterality=laterality
	if bodySiteCode'="" set img.bodysiteCode=bodySiteCode
	if observer'="" set img.peformedBy=observer
	if seriesUID'="" set img.seriesUID=seriesUID
	if instanceUID'="" set img.instanceUID=instanceUID
 	if sopclassUID'="" set img.sopclassUID=sopclassUID
	
	set pat.nhs=nhs 
	set pat.sex=sex
	set pat.dob=dob 
	if dod'="" set pat.dod=dod
	
	set img.Patient=pat


	
	IF (img.accessionID'="") && (img.dateOfStudy'="") && (img.modalityCode'="") && (img.procedureCode'="")
	&& (img.procedureName'="") && (pat.dob'="") && (pat.nhs'="")
	{
	
		set t=..SendRequestSync("FHIRProcessor",img)
	}
	else
	{
		$$$TRACE("Missing values from message")
		$$$TRACE("Discarding message")
		
	}	
		
		
	
	
	
	q t
}

Storage Default
{
<Type>%Storage.Persistent</Type>
}

}
