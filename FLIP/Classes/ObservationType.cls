Class FLIP.Classes.ObservationType Extends %Persistent
{

Property Code As %String;

Property Desription As %String;

Property System As %String;

Storage Default
{
<Data name="ObservationTypeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Code</Value>
</Value>
<Value name="3">
<Value>Desription</Value>
</Value>
<Value name="4">
<Value>System</Value>
</Value>
</Data>
<DataLocation>^FLIP.Classes.ObservationTypeD</DataLocation>
<DefaultData>ObservationTypeDefaultData</DefaultData>
<IdLocation>^FLIP.Classes.ObservationTypeD</IdLocation>
<IndexLocation>^FLIP.Classes.ObservationTypeI</IndexLocation>
<StreamLocation>^FLIP.Classes.ObservationTypeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
