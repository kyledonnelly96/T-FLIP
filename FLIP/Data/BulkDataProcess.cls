Class FLIP.Data.BulkDataProcess Extends Ens.BusinessProcess [ ClassType = persistent ]
{

Method OnProcessInput(pInput As Ens.Request, Output pOutput As Ens.Response) As %Status
{
	
	
	set qry=##class(FLIP.Data.InsertQuery).BulkInsert(100,.qry)
	
	$$$LOGINFO(qry)
	
	set stringContainer=##class(Ens.StringContainer).%New()
	set stringContainer.StringValue=qry
	
	set t=..SendRequestSync("BulkDataOp",stringContainer)
}

Storage Default
{
<Type>%Storage.Persistent</Type>
}

}
