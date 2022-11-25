Class FLIP.Classes.Document Extends Ens.Request
{

Property Patient As FLIP.Classes.Patient;

Property ID As %String;

Property TypeID As %String;

Property TypeName As %String;

Property CategoryID As %String;

Property CategoryName As %String;

Property ContentType As %String;

Property FileExt As %String;

Property Status As %String;

Property documentdate As %String;

Property fileSize As %Integer;

Property fileName As %String;

Property TextBlock As %String(MAXLEN = 50000);

Property ContentRef As %String;

Storage Default
{
<Data name="DocumentDefaultData">
<Subscript>"Document"</Subscript>
<Value name="1">
<Value>Patient</Value>
</Value>
<Value name="2">
<Value>DocumentID</Value>
</Value>
<Value name="3">
<Value>DocumentStatus</Value>
</Value>
<Value name="4">
<Value>DocumentType</Value>
</Value>
<Value name="5">
<Value>DocumentDateTime</Value>
</Value>
<Value name="6">
<Value>TextBlock</Value>
</Value>
<Value name="7">
<Value>FileName</Value>
</Value>
<Value name="8">
<Value>ID</Value>
</Value>
<Value name="9">
<Value>TypeID</Value>
</Value>
<Value name="10">
<Value>TypeName</Value>
</Value>
<Value name="11">
<Value>TypeSystem</Value>
</Value>
<Value name="12">
<Value>CategoryID</Value>
</Value>
<Value name="13">
<Value>CategoryDesc</Value>
</Value>
<Value name="14">
<Value>ContentType</Value>
</Value>
<Value name="15">
<Value>FileExt</Value>
</Value>
<Value name="16">
<Value>Status</Value>
</Value>
<Value name="17">
<Value>obsdttm</Value>
</Value>
<Value name="18">
<Value>ContentRef</Value>
</Value>
<Value name="19">
<Value>Notes</Value>
</Value>
<Value name="20">
<Value>CategoryName</Value>
</Value>
<Value name="21">
<Value>base64</Value>
</Value>
<Value name="22">
<Value>documentdate</Value>
</Value>
<Value name="23">
<Value>fileSize</Value>
</Value>
<Value name="24">
<Value>fileName</Value>
</Value>
</Data>
<DefaultData>DocumentDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
