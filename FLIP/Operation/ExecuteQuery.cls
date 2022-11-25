Class FLIP.Operation.ExecuteQuery Extends Ens.BusinessOperation
{

Parameter ADAPTER = "EnsLib.SQL.OutboundAdapter";

Property Adapter As EnsLib.SQL.OutboundAdapter;

Parameter INVOCATION = "Queue";

Method SelectData(pRequest As Ens.Request, Output pResponse As Ens.Response)
{
	Set sc = $$$OK
	Try {
		Set pResponse = ##class(EnsLib.SQL.Snapshot).%New()
		Set SQL = pRequest.Query
	
		Set sc = ..Adapter.ExecuteQuery(.pResponse, SQL) 
		

	}
	Catch Ex {
		Set sc = Ex.AsStatus()
	}
	
	quit sc
}

Method UpdateData(pRequest As Ens.Request, Output pResponse As Ens.Response)
{
		Set sc = $$$OK
	Try {
		Set pResponse = ##class(EnsLib.SQL.Snapshot).%New()
		Set SQL = pRequest.qry
	
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
  <MapItem MessageType="FLIP.Classes.RequestLastProcessedRowID">
    <Method>SelectData</Method>
  </MapItem>
    <MapItem MessageType="FLIP.Classes.RequestImagingData">
    <Method>SelectData</Method>
  </MapItem>
   <MapItem MessageType="FLIP.Classes.UpdateRecProcessed">
    <Method>UpdateData</Method>
  </MapItem>
    <MapItem MessageType="FLIP.Classes.RequestDocumentData">
    <Method>SelectData</Method>
  </MapItem>
</MapItems>
}

}
