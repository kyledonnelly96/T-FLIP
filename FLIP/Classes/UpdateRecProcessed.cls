Class FLIP.Classes.UpdateRecProcessed Extends Ens.Request
{

Property qry As %String(MAXLEN = 100);

Storage Default
{
<Data name="UpdateRecProcessedDefaultData">
<Subscript>"UpdateRecProcessed"</Subscript>
<Value name="1">
<Value>qry</Value>
</Value>
</Data>
<DefaultData>UpdateRecProcessedDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
