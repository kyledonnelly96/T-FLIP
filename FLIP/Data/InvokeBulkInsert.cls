Class FLIP.Data.InvokeBulkInsert Extends Ens.BusinessService
{

Parameter ADAPTER = "Ens.InboundAdapter";

Method OnProcessInput(pInput As %RegisteredObject, Output pOutput As %RegisteredObject) As %Status
{

	set t=$$$OK
	
	set qry=##class(FLIP.Data.InsertQuery).BulkInsert(100)
	
	$$$LOGINFO(qry)
	
	set stringContainer=##class(Ens.StringContainer).%New()
	set stringContainer.StringValue=qry
	
	set t=..SendRequestSync("BulkDataOp",stringContainer)	
	
	
	quit t
}

}
