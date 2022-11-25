Class FLIP.Classes.Patient Extends Ens.Request
{

Property mrn As %String(MAXLEN = 10);

Property nhs As %String(MAXLEN = 10);

Property postCode As %String;

Property dob As %String;

Property sex As %String;

Property dod As %String;

Property ethnicGroup As %String;

Property nhsTraced As %Integer;

Storage Default
{
<Data name="PatientDefaultData">
<Subscript>"Patient"</Subscript>
<Value name="1">
<Value>mrn</Value>
</Value>
<Value name="2">
<Value>nhs</Value>
</Value>
<Value name="3">
<Value>postCode</Value>
</Value>
<Value name="4">
<Value>patDOB</Value>
</Value>
<Value name="5">
<Value>sex</Value>
</Value>
<Value name="6">
<Value>patDod</Value>
</Value>
<Value name="7">
<Value>ethnicGroup</Value>
</Value>
<Value name="8">
<Value>dob</Value>
</Value>
<Value name="9">
<Value>dod</Value>
</Value>
<Value name="10">
<Value>nhsTraced</Value>
</Value>
<Value name="11">
<Value>nhsOptOut</Value>
</Value>
</Data>
<DefaultData>PatientDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
