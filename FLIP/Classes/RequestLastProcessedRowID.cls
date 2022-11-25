Class FLIP.Classes.RequestLastProcessedRowID Extends Ens.Request
{

Property Query As %String(MAXLEN = 10000);

Storage Default
{
<Data name="RequestLastProcessedRowIDDefaultData">
<Subscript>"RequestLastProcessedRowID"</Subscript>
<Value name="1">
<Value>Query</Value>
</Value>
</Data>
<DefaultData>RequestLastProcessedRowIDDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
