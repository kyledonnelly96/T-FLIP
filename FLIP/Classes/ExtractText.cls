Class FLIP.Classes.ExtractText Extends %RegisteredObject
{

Property FilePath As %String;

Method Extract(FilePath As %String)
{
	set t=$$$OK
	
	set cmd="java -jar C:\Users\Administrator\pdfbox\pdfbox-app-2.0.26.jar ExtractText "_filePath_ " C:\Users\Administrator\TempFolder\temp.txt"
	set cmdStatus=$ZF(-1,cmd) //run command
	$$$TRACE("Running command: "_cmd)
	$$$TRACE("CMD: "_cmdStatus)
	set t=$SELECT(cmdStatus=0:$$$OK,1:$$$ERROR($$$GeneralError,"Unable to extract text from pdf"))
	$$$TRACE($SYSTEM.Status.GetErrorText(t))
	IF $$$ISERR(t) $$$ThrowStatus(t)
	
	
	//now read txt file
	set file=##class(%File).%New("C:\Users\Administrator\TempFolder\temp.txt")
	set t=file.Open("RU")
	set t=file.Rewind()
	
	
	set text=""

	
	IF $$$ISERR(t) $$$LOGERROR("Unable to open txt") quit t
	while 'file.AtEnd
	{
		
		set readline=file.ReadLine(,.sc)
		set text=text_readline
		
	}	
	
	do file.Close()
	set t=##class(%File).Delete("C:\Users\Administrator\TempFolder\temp.txt")
	IF '$$$ISERR(t) $$$TRACE("Temp txt file deleted")
	
	$$$LOGINFO(text)
	
	quit text
}

}
