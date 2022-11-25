Class FLIP.Classes.RequestDocumentData Extends Ens.Request
{

Property Query As %String(MAXLEN = 10000);

Storage Default
{
<Data name="RequestDocumentDataDefaultData">
<Subscript>"RequestDocumentData"</Subscript>
<Value name="1">
<Value>qry</Value>
</Value>
<Value name="2">
<Value>Query</Value>
</Value>
</Data>
<DefaultData>RequestDocumentDataDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
