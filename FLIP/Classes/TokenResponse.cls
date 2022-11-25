Class FLIP.Classes.TokenResponse Extends Ens.Response
{

Property AccessToken As %String(MAXLEN = 2000);

Property StatusCode As %Integer;

Storage Default
{
<Data name="TokenResponseDefaultData">
<Subscript>"TokenResponse"</Subscript>
<Value name="1">
<Value>AccessToken</Value>
</Value>
<Value name="2">
<Value>StatusCode</Value>
</Value>
</Data>
<DefaultData>TokenResponseDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
