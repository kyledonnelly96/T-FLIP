Class FLIP.Classes.UtilityMethods Extends %RegisteredObject
{

ClassMethod DecodeBase64(base64 As %Stream.FileBinary, directory As %String, documentID As %String, Output fullFilePath As %String) As %String
{
	
	set directory=directory_"\"_documentID
	

	
	set t=##class(%Library.File).CreateDirectory(directory)
	
	
	set fileStrm=##class(%FileBinaryStream).%New()
	set fullFilePath=directory_"\"_documentID_".pdf"
	set fileStrm.Filename=fullFilePath	
		
	Do base64.Rewind()

	While 'base64.AtEnd {
     set ln = base64.Read()
    set lnDecoded = $system.Encryption.Base64Decode(ln)
	do fileStrm.Write(lnDecoded)
	}
	


	set t=fileStrm.%Save()
	
	

	
		
	quit fullFilePath
}

ClassMethod ExtractText(filepath As %String, Output text As %String)
{
	

	//get directory
	set directory=##class(%File).GetDirectory(filepath)
		
	set cmd="java -jar C:\Users\Administrator\Kyle\tika-app-2.6.0.jar --text -i "_directory_" -o "_directory
	set cmdStatus=$ZF(-1,cmd) //run command

	

	//update filename
	set oldFilePath=filepath_".txt"
	set newFilepath=($REPLACE(filepath,".pdf",".txt")) 
	

	
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

		
	set t=##class(%File).Delete(newFilepath)

		
	set t=##class(%File).RemoveDirectory(directory)

	
	quit text
}

}
