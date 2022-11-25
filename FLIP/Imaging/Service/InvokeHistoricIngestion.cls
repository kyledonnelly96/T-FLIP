Class FLIP.Imaging.Service.InvokeHistoricIngestion Extends Ens.BusinessService
{

Parameter ADAPTER = "EnsLib.SQL.InboundAdapter";

Method OnProcessInput(pInput As EnsLib.SQL.Snapshot, Output pOutput As %RegisteredObject) As %Status
{
	set t=$$$OK
	
	set t=..SendRequestSync("Img_ProcessHistoricData",pInput)
	
	quit t
}

}
