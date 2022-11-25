Class FLIP.Classes.TokenRequest Extends (Ens.Request, %JSON.Adaptor)
{

Property AuthFlow As %String;

Property ClientId As %String;

Property AuthParameters As FLIP.Classes.AuthParameters;

Storage Default
{
<Data name="TokenRequestDefaultData">
<Subscript>"TokenRequest"</Subscript>
<Value name="1">
<Value>AuthFlow</Value>
</Value>
<Value name="2">
<Value>ClientId</Value>
</Value>
<Value name="3">
<Value>AuthParameters</Value>
</Value>
</Data>
<DefaultData>TokenRequestDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
