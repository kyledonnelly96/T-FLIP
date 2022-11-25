Class FLIP.Process.BulkInsertProcess Extends Ens.BusinessProcess [ ClassType = persistent ]
{

Method OnRequest(pInput As Ens.Request, Output pResponse As Ens.Response) As %Status
{

	set t=$$$OK
	
	//INSERTS 100 Records when invoked
	
	set Qry=##class(FLIP.Data.InsertQuery).BulkInsert(100,.Qry)
	
	set StringContainer=##class(Ens.StringContainer).%New()
	set StringContainer.StringValue=Qry
	
	set t=..SendRequestSync("ExecuteUpdate",StringContainer)
	
	$$$TRACE(Qry)
	
	q t
}

Storage Default
{
<Type>%Storage.Persistent</Type>
}

}
