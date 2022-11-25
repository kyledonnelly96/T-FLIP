Class FLIP.Documents.Process.MDMProcessor Extends Ens.BusinessProcess [ ClassType = persistent ]
{

Property TempFileConverterFolder As %String [ InitialExpression = "C:\Users\Administrator\Kyle" ];

Method OnRequest(pRequest As EnsLib.HL7.Message, Output pResponse As Ens.Response) As %Status
{
	set t=$$$OK
	
	set msg=pRequest
	
				
		//Grab demographics from PID segment
	//Loop through PID 3 to grab mrn and nhs
	set mrn="" set nhs="" set dod=""
		
	set x=msg.FindSegmentValues("PID:3(*)")
	for i=1:1:x
		{
			if msg.FindSegmentValues("PID:3("_i_").5")="NHS"
			{
				set nhs=msg.FindSegmentValues("PID:3("_i_").1")
					
			}
			
		}
		
	set sex=msg.FindSegmentValues("PID:8")
	set dob=msg.FindSegmentValues("PID:7.1")
	
		
	//IF death indicator =Y we need to grab DOD
		
		if msg.FindSegmentValues("PID:30")="Y"
		{
			set dod=msg.FindSegmentValues("PID:29")
		}	
	
		

	
	set document =##class(FLIP.Classes.Document).%New()
	
	set patient=##class(FLIP.Classes.Patient).%New()
	IF nhs'="" set patient.nhs=nhs
	set patient.dob=dob
	IF dod'="" set patient.dob=dod
	set patient.sex=sex
	set document.Patient=patient
	
	set document.ID=msg.FindSegmentValues("TXA:12")
	set document.Status=msg.FindSegmentValues("TXA:17")
	set document.TypeID=msg.FindSegmentValues("TXA:2.1")
	
	if msg.FindSegmentValues("TXA:2.2")'="" set document.TypeName=msg.FindSegmentValues("TXA:2.2")
	
	
	if msg.FindSegmentValues("TXA:2.3")'="" set document.CategoryID=msg.FindSegmentValues("TXA:2.3")
		if msg.FindSegmentValues("TXA:2.4")'="" set document.CategoryName=msg.FindSegmentValues("TXA:2.4")
	
	set document.documentdate=msg.FindSegmentValues("TXA:4.1")
	
	//Set document.ContentRef=msg.FindSegmentValues("TXA:16")
	
	$$$LOGINFO(document.ID)
		$$$LOGINFO(document.documentdate)
			$$$LOGINFO(patient.dob)
				$$$LOGINFO(patient.nhs)
	
	IF (document.ID="") || (document.documentdate="")  || (patient.dob="")
	 || (patient.nhs="")
	{
		$$$LOGERROR("Missing values from message - Discarding")
		quit t
		
	}	
	
	
	//check if the document is base64 encoded or reference pointed
	IF msg.FindSegmentValues("OBX(1):2")="ED" //If it is a encrypted document
	{
		
		
		set stream=##class(%Stream.GlobalBinary).%New()
		do stream.Write(msg.GetValueAt("OBX(1):5(1).5"))
		set directory=..TempFileConverterFolder
		$$$LOGINFO(directory)
		set filePath=##class(FLIP.Classes.UtilityMethods).DecodeBase64(stream,directory,document.ID)
		
			
		
	}
	ELSEIF msg.FindSegmentValues("OBX(1):2")="RP" //it is a referenced pointed document
	{
		set filePath=msg.FindSegmentValues("OBX(1):5(1)")
	}
	else
	{
		$$$LOGERROR("Unsupported media type") 
		quit t
		
	}	
	
	$$$LOGINFO(filePath)	
		
	
	set document.TextBlock=##class(FLIP.Classes.UtilityMethods).ExtractText(filePath)

	set t=..SendRequestSync("FHIRProcessor",document)
	
	
	
	
	quit t
}

Method DecodeBase64(base64 As %Stream.GlobalBinary, documentID As %String, Output fullFilePath As %String) As %String
{
	
	set directory="C:\Users\Administrator\Kyle\"_documentID
	
	$$$LOGINFO(base64)
	
	set t=##class(%Library.File).CreateDirectory(directory)
	$$$TRACE("Directory created "_t)
	
	
	set fileStrm=##class(%FileBinaryStream).%New()
	set fullFilePath=directory_"\"_documentID_".pdf"
	set fileStrm.Filename=fullFilePath	
		
	Do base64.Rewind()

	While 'base64.AtEnd {
     set ln = base64.Read()
    set lnDecoded = $system.Encryption.Base64Decode(ln)
	do fileStrm.Write(lnDecoded)
	}
	$$$TRACE(lnDecoded)


	set t=fileStrm.%Save()
	
	

	
		
	quit fullFilePath
}

Method ExtractText(filepath As %String, Output text As %String)
{
	
	$$$LOGINFO("FileIN"_filepath)
	//get directory
	set directory=##class(%File).GetDirectory(filepath)
		
	set cmd="java -jar C:\Users\Administrator\Kyle\tika-app-2.6.0.jar --text -i "_directory_" -o "_directory
	set cmdStatus=$ZF(-1,cmd) //run command
	$$$TRACE("Running command: "_cmd)
	$$$TRACE("CMD: "_cmdStatus)
	set t=$SELECT(cmdStatus=0:$$$OK,1:$$$ERROR($$$GeneralError,"Unable to extract text from pdf"))
	$$$TRACE($SYSTEM.Status.GetErrorText(t))
	IF $$$ISERR(t) $$$ThrowStatus(t)
	

	//update filename
	set oldFilePath=filepath_".txt"
	set newFilepath=($REPLACE(filepath,".pdf",".txt")) 
	
	$$$LOGINFO("old"_oldFilePath)
	$$$LOGINFO("new "_newFilepath)
	
	set sc=##class(%File).Rename(oldFilePath,newFilepath)
	

	/*set stream=##class(%Stream.FileCharacter).%New()
	set sc=stream.LinkToFile(newFilepath)
	
	while 'stream.AtEnd
	{ 
		set text=stream.ReadLine()
		
	}*/
	
	set fileObj=##class(%File).%New(newFilepath)
	do fileObj.Open("RU")
	

	set text=fileObj.Read()
	
	do fileObj.Rewind()
	do fileObj.Close()
	
	
	
			
	set t=##class(%File).Delete(filepath)
	$$$TRACE("PDF file deleted: "_t)
		
	set t=##class(%File).Delete(newFilepath)
	
	$$$TRACE(" Txt File deleted: "_t)
		
	set t=##class(%File).RemoveDirectory(directory)
	IF '$$$ISERR(t) $$$TRACE("Temp txt file deleted")
	
	quit text
}

Storage Default
{
<Data name="MDMProcessorDefaultData">
<Subscript>"MDMProcessor"</Subscript>
<Value name="1">
<Value>TempFolder</Value>
</Value>
<Value name="2">
<Value>TempFileConverterFolder</Value>
</Value>
</Data>
<DefaultData>MDMProcessorDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
