Class FLIP.Service.Scheduler Extends Ens.BusinessService
{

Parameter ADAPTER = "Ens.InboundAdapter";

Method OnProcessInput(pInput As %RegisteredObject, Output pOutput As %RegisteredObject) As %Status
{

	set t=$$$OK
	
	
	set run=##class(Ens.Util.FunctionSet).Lookup("FLIP.Configuration","patient_historic_run")
	if run="stop" quit t
	
	set t=..SendRequestSync("BulkInsertProcess","",.resp)
	
	q t
}

}
