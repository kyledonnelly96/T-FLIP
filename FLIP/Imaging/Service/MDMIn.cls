Class FLIP.Imaging.Service.MDMIn Extends Ens.BusinessService
{

Parameter ADAPTER = "EnsLib.SQL.InboundAdapter";

Method OnProcessInput(pInput As EnsLib.SQL.Snapshot, Output pOutput As %RegisteredObject) As %Status
{

	set t=$$$OK
	
	set string=pInput.Get("hl7")
	
	
	set hl7=##class(EnsLib.HL7.Message).ImportFromString(string,.t)
	set t=hl7.PokeDocType("2.3:ORU_R01")
	
	
	set t=..SendRequestSync("Img_ProcessORU",hl7)	
	
	quit t
}

}
