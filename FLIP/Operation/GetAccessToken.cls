Class FLIP.Operation.GetAccessToken Extends Ens.BusinessOperation
{

Parameter ADAPTER = "EnsLib.HTTP.OutboundAdapter";

Property Adapter As EnsLib.HTTP.OutboundAdapter;

Parameter INVOCATION = "Queue";

Method GetToken(pmsgIn As FLIP.Classes.TokenRequest, Output pResponse As Ens.Response) As %Status
{
	SET ts=$$$OK	
	SET ..Adapter.URL="https://cognito-idp.eu-west-2.amazonaws.com/"
	set strm=##class(%Stream.GlobalCharacter).%New()
	do ##class(Ens.Util.JSON).ObjectToJSONStream(pmsgIn,.strm)
	SET tHTTPReq=##class(%Net.HttpRequest).%New()	
	DO tHTTPReq.SetHeader("x-amz-target","AWSCognitoIdentityProviderService.InitiateAuth")
	DO tHTTPReq.SetHeader("Content-Type","application/x-amz-json-1.1")
	SET tHTTPReq.EntityBody=strm	
	
	SET ts=..Adapter.SendFormDataArray(.tHttpResponse, "POST", tHTTPReq)
	
	
	$$$TRACE(tHttpResponse)

	#DIM tHttpResponse as %Net.HttpResponse
	
	IF $ISOBJECT(tHttpResponse)
	{
	
		IF tHttpResponse.StatusCode="200"
		{
			
		
		
		set obj={}.%FromJSON(tHttpResponse.Data)
		set token=obj.AuthenticationResult.IdToken
		
		set tokenResponse=##class(FLIP.Classes.TokenResponse).%New()
		set tokenResponse.AccessToken=token
		set tokenResponse.StatusCode=tHttpResponse.StatusCode
		set pResponse=tokenResponse
		
		//ADD ACCESS TOKEN TO GLOBAL
		set ^tokenTS=$PIECE($HOROLOG,",",1)_$PIECE($HOROLOG,",",2)
		set ^token=token
		}
		
	}	
	

	
	


	quit ts
}

Method SendFHIR(pMsgIn As Ens.StreamContainer, Output pResponse As Ens.Response)
{
	set sc=$$$OK
	
	set strm=pMsgIn.Stream
	
	/*set strm=##class(%Stream.GlobalCharacter).%New()
	do ##class(Ens.Util.JSON).ObjectToJSONStream(pMsgIn.JSONString,.strm)*/
	
	SET tHTTPReq=##class(%Net.HttpRequest).%New()	

	DO tHTTPReq.SetHeader("Content-Type","application/json")
	SET tHTTPReq.EntityBody=strm	
	
	SET ts=..Adapter.SendFormDataArray(.tHttpResponse, "POST", tHTTPReq)
	SET ..Adapter.URL="http://hapi.fhir.org/baseR4"
	
	#DIM tHttpResponse As %Net.HttpResponse
	$$$TRACE("Status code: "_tHttpResponse.StatusCode)

	set pResponse=tHttpResponse.StatusCode

	
	quit sc
}

XData MessageMap
{
<MapItems>
<MapItem MessageType="FLIP.Classes.TokenRequest">
<Method>GetToken</Method>
</MapItem>
<MapItem MessageType="Ens.StreamContainer">
<Method>SendFHIR</Method>
</MapItem>
</MapItems>
}

}
