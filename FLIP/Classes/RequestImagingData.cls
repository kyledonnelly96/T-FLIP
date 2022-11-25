Class FLIP.Classes.RequestImagingData Extends Ens.Request
{

Property Query As %String(MAXLEN = 10000);

Storage Default
{
<Data name="RequestImagingDataDefaultData">
<Subscript>"RequestImagingData"</Subscript>
<Value name="1">
<Value>Query</Value>
</Value>
</Data>
<DefaultData>RequestImagingDataDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
