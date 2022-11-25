Class FLIP.Classes.AuthParameters Extends (Ens.Request, %JSON.Adaptor)
{

Property USERNAME As %String;

Property PASSWORD As %String;

Storage Default
{
<Data name="AuthParametersDefaultData">
<Subscript>"AuthParameters"</Subscript>
<Value name="1">
<Value>USERNAME</Value>
</Value>
<Value name="2">
<Value>PASSWORD</Value>
</Value>
</Data>
<DefaultData>AuthParametersDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
