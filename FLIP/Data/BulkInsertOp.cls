Class FLIP.Data.BulkInsertOp Extends Ens.BusinessOperation
{

Parameter ADAPTER = "EnsLib.SQL.OutboundAdapter";

Property Adapter As EnsLib.SQL.OutboundAdapter;

Parameter INVOCATION = "Queue";

Method UpdateData(pRequest As Ens.StringContainer, Output pResponse As Ens.Response)
{
		Set sc = $$$OK
	Try {
		
		Set SQL = pRequest.StringValue
	
		Set sc = ..Adapter.ExecuteUpdate(.pResponse, SQL) 
		

	}
	Catch Ex {
		Set sc = Ex.AsStatus()
	}
	
	quit sc
}

XData MessageMap
{
<MapItems>
  <MapItem MessageType="Ens.StringContainer">
    <Method>UpdateData</Method>
  </MapItem>
  </MapItems>
}

}
