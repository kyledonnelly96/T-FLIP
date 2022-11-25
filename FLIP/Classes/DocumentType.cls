Class FLIP.Classes.DocumentType Extends %Persistent
{

Property Code As %String;

Property Description As %String;

Property CodingSystem As %String;

Property CategoryCode As %String;

Property CategoryDescription As %String;

Property CategoryCoding As %String;

Storage Default
{
<Data name="DocumentTypeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>DocumentType</Value>
</Value>
<Value name="3">
<Value>Code</Value>
</Value>
<Value name="4">
<Value>Description</Value>
</Value>
<Value name="5">
<Value>CodingSystem</Value>
</Value>
<Value name="6">
<Value>CategoryCode</Value>
</Value>
<Value name="7">
<Value>CategoryDescription</Value>
</Value>
<Value name="8">
<Value>CategoryCoding</Value>
</Value>
</Data>
<DataLocation>^FLIP.Classes.DocumentTypeD</DataLocation>
<DefaultData>DocumentTypeDefaultData</DefaultData>
<ExtentSize>1</ExtentSize>
<IdLocation>^FLIP.Classes.DocumentTypeD</IdLocation>
<IndexLocation>^FLIP.Classes.DocumentTypeI</IndexLocation>
<Property name="%%CLASSNAME">
<AverageFieldSize>2</AverageFieldSize>
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="%%ID">
<AverageFieldSize>3</AverageFieldSize>
<Selectivity>1</Selectivity>
</Property>
<Property name="CategoryCode">
<AverageFieldSize>4</AverageFieldSize>
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="CategoryCoding">
<AverageFieldSize>8</AverageFieldSize>
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="CategoryDescription">
<AverageFieldSize>18</AverageFieldSize>
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="Code">
<AverageFieldSize>8</AverageFieldSize>
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="CodingSystem">
<AverageFieldSize>8</AverageFieldSize>
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="Description">
<AverageFieldSize>28</AverageFieldSize>
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="DocumentType">
<AverageFieldSize>7</AverageFieldSize>
<Selectivity>100.0000%</Selectivity>
</Property>
<SQLMap name="IDKEY">
<BlockCount>-4</BlockCount>
</SQLMap>
<StreamLocation>^FLIP.Classes.DocumentTypeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
