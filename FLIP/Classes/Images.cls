Class FLIP.Classes.Images Extends Ens.Request
{

Property fillerID As %String;

Property accessionID As %String;

Property procedureName As %String;

Property procedureCode As %String;

Property modalityCode As %String;

Property sopclassUID As %String;

Property seriesUID As %String;

Property instanceUID As %String;

Property bodysiteCode As %Integer;

Property laterality As %String;

Property peformedBy As %String;

Property dateOfStudy As %String;

Property obsdttm As %String;

Property observationValue As %String(MAXLEN = 100);

Property Patient As FLIP.Classes.Patient;

Storage Default
{
<Data name="ImagesDefaultData">
<Subscript>"Images"</Subscript>
<Value name="1">
<Value>Patient</Value>
</Value>
<Value name="2">
<Value>obsdttm</Value>
</Value>
<Value name="3">
<Value>fillerID</Value>
</Value>
<Value name="4">
<Value>accessionID</Value>
</Value>
<Value name="5">
<Value>serviceID</Value>
</Value>
<Value name="6">
<Value>serviceName</Value>
</Value>
<Value name="7">
<Value>serviceIDType</Value>
</Value>
<Value name="8">
<Value>diagService</Value>
</Value>
<Value name="9">
<Value>diagServiceID</Value>
</Value>
<Value name="10">
<Value>resValue</Value>
</Value>
<Value name="11">
<Value>resStatus</Value>
</Value>
<Value name="12">
<Value>device</Value>
</Value>
<Value name="13">
<Value>recStatus</Value>
</Value>
<Value name="14">
<Value>recUpdated</Value>
</Value>
<Value name="15">
<Value>recInserted</Value>
</Value>
<Value name="16">
<Value>procedureName</Value>
</Value>
<Value name="17">
<Value>procedureCode</Value>
</Value>
<Value name="18">
<Value>modalityName</Value>
</Value>
<Value name="19">
<Value>modalityCode</Value>
</Value>
<Value name="20">
<Value>peformedBy</Value>
</Value>
<Value name="21">
<Value>dateOfStudy</Value>
</Value>
<Value name="22">
<Value>sopclassUID</Value>
</Value>
<Value name="23">
<Value>sopclassName</Value>
</Value>
<Value name="24">
<Value>observationValue</Value>
</Value>
<Value name="25">
<Value>bodysiteCode</Value>
</Value>
<Value name="26">
<Value>bodySiteName</Value>
</Value>
<Value name="27">
<Value>laterality</Value>
</Value>
<Value name="28">
<Value>seriesUID</Value>
</Value>
<Value name="29">
<Value>instanceUID</Value>
</Value>
</Data>
<DefaultData>ImagesDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
