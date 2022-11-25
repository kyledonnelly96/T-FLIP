Class FLIP.Data.Patients Extends %Persistent
{

Property LastName As %String;

Property nhsNumb As %Integer;

Property mrn As %String;

Property sex As %String;

Property postCode As %String;

Property dob As %String;

Property ethnicCategory As %Char;

ClassMethod NewPatients(total As %Integer)
{
	
	
	set start=0 set end=total
	
	while start < end
	{
		set new=##class(FLIP.Data.Patients).%New()
		
		set start=start+1
		set lastNHS=##class(Ens.Util.FunctionSet).Lookup("FLIP.MockDataCreation","lastNHS")
		set lastMRN=##class(Ens.Util.FunctionSet).Lookup("FLIP.MockDataCreation","lastMRN")	
	
		set nhs=lastNHS+1
		set mrn=lastMRN+1
		do ##class(Ens.Util.LookupTable).%UpdateValue("FLIP.MockDataCreation","lastMRN",mrn)
		do ##class(Ens.Util.LookupTable).%UpdateValue("FLIP.MockDataCreation","lastNHS",nhs)
		
		set new.nhsNumb=lastNHS
		set new.mrn=lastMRN
		
		set new.LastName=##class(%PopulateUtils).LastName()
		
	
		
		set sex=$RANDOM(2)
		set new.sex=$CASE(sex,0:"M",1:"F")
		
		set dob=##class(%PopulateUtils).CDate(3,30000,55000)
		set dob=##class(Ens.Util.Time).ConvertDateTime(dob,"%Y-%m-%d","%d-%m-%y")
		set new.dob=dob
		//set date=$ZDATE(integerDate,15)
		//set date=$REPLACE(date,"/","-")
		
		//post code
		set outcode=##class(%PopulateUtils).StringMin(2,2)_##class(%PopulateUtils).Integer(1,40)
		set inCode=$RANDOM(10)_##class(%PopulateUtils).StringMin(2,2)
		set new.postCode=$ZCONVERT(outcode_" "_inCode,"U")
		
		//ethnic category
		
		set x=$RANDOM(9)
		set new.ethnicCategory=$CASE(x,0:"A",1:"B",2:"C",3:"D",4:"E",5:"F",6:"G",7:"H",7:"J",8:"Z")
		
		zw new
		do new.%Save()
		
	}
}

Storage Default
{
<Data name="PatientsDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>LastName</Value>
</Value>
<Value name="3">
<Value>nhsNumb</Value>
</Value>
<Value name="4">
<Value>mrn</Value>
</Value>
<Value name="5">
<Value>sex</Value>
</Value>
<Value name="6">
<Value>postCode</Value>
</Value>
<Value name="7">
<Value>dob</Value>
</Value>
<Value name="8">
<Value>ethnicCategory</Value>
</Value>
</Data>
<DataLocation>^FLIP.Data.PatientsD</DataLocation>
<DefaultData>PatientsDefaultData</DefaultData>
<ExtentSize>35</ExtentSize>
<IdLocation>^FLIP.Data.PatientsD</IdLocation>
<IndexLocation>^FLIP.Data.PatientsI</IndexLocation>
<Property name="%%CLASSNAME">
<AverageFieldSize>2</AverageFieldSize>
<Histogram>$lb(.06666666666666666667,0,16,$lb("-10000000000000000000","-10000000000000000000","-10000000000000000000","-10000000000000000000","-10000000000000000000","-10000000000000000000","-10000000000000000000","-10000000000000000000","-10000000000000000000","-10000000000000000000","-10000000000000000000","-10000000000000000000","-10000000000000000000","-10000000000000000000","-10000000000000000000","-10000000000000000000"),$lb(21,21,21,21,21,21,21,21,21,21,21,21,21,21,21),$lb(758198320,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,758198320))</Histogram>
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="%%ID">
<AverageFieldSize>3</AverageFieldSize>
<Histogram>$lb(.06666666666666666667,1,0,$lb("1","3","6","9","12","15","17","19","21","23","25","27","29","31","33","35"),$lb(0,0,0,0,1,1,1,0,1,1,1,1,0,1,1),$lb(822083584,822083584,855638016,855638016,905969664,905969664,956301312,956301312,825360384,838860800,889192448,889192448,922746880,922746880,956301312,825819136,842072064,822083584,855638016,855638016,889192448,889192448,922746880,922746880,956301312,842596352,858849280,822083584,855638016,855638016,889192448,859111424))</Histogram>
<Selectivity>1</Selectivity>
</Property>
<Property name="LastName">
<AverageFieldSize>3.11</AverageFieldSize>
<Histogram>$lb(.06666666666666666667,0,0,$lb(" "," "," "," "," "," "," "," "," "," "," "," "," "," GEOFFRION"," KING"," WIJNSCHENK"),$lb(2,2,2,2,2,2,2,2,2,2,2,2,1,1,1),$lb(536870912,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1195724614,1195724614,1263095367,1263095367,1464420942,542591306))</Histogram>
<OutlierSelectivity>.857143:</OutlierSelectivity>
<Selectivity>2.8571%</Selectivity>
</Property>
<Property name="dob">
<AverageFieldSize>12</AverageFieldSize>
<Histogram>$lb(.06666666666666666667,0,0,$lb(" 1924-01-17"," 1929-11-15"," 1934-01-03"," 1940-06-07"," 1943-12-28"," 1950-11-24"," 1956-11-26"," 1963-12-04"," 1970-11-17"," 1974-05-29"," 1976-05-05"," 1979-04-21"," 1981-02-27"," 1987-08-14"," 1989-01-16"," 1989-06-21"),$lb(4,3,3,4,3,4,3,3,4,4,4,3,4,4,7),$lb(540096818,875376689,959263025,842607921,859057456,859057456,875572528,808267830,858599730,875769137,892349745,808268081,908931377,892742961,909323569,909323569,925904177,808268081,875376693,875376693,908931125,908931125,959262772,926494000,942746928,825045042,925708344,925708344,959262769,825045302,908931633,540096824))</Histogram>
<Selectivity>2.8571%</Selectivity>
</Property>
<Property name="ethnicCategory">
<AverageFieldSize>3</AverageFieldSize>
<Histogram>$lb(.06666666666666666667,0,0,$lb(" A"," A"," B"," C"," D"," F"," F"," F"," G"," G"," H"," H"," H"," H"," Z"," Z"),$lb(3,1,1,1,1,3,3,1,3,1,3,3,3,1,3),$lb(541130752,0,0,1090519040,1107296256,1107296256,1124073472,1124073472,1140850688,1140850688,1174405120,0,0,0,0,1174405120,1191182336,0,0,1191182336,1207959552,0,0,0,0,0,0,1207959552,1509949440,0,0,542769152))</Histogram>
<Selectivity>11.1111%</Selectivity>
</Property>
<Property name="mrn">
<AverageFieldSize>2.57</AverageFieldSize>
<Histogram>$lb(.06666666666666666667,0,0,$lb(" "," "," "," "," "," "," "," "," "," "," "," "," "," 04572345"," 4572347"," 4572349"),$lb(2,2,2,2,2,2,2,2,2,2,2,2,1,1,7),$lb(536870912,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,808727863,808727863,875902770,922746880,956301312,540292407))</Histogram>
<OutlierSelectivity>.857143:</OutlierSelectivity>
<Selectivity>2.8571%</Selectivity>
</Property>
<Property name="nhsNumb">
<AverageFieldSize>2.71</AverageFieldSize>
<Histogram>$lb(.06666666666666666667,1,13,$lb("-10000000000000000000","-10000000000000000000","-10000000000000000000","-10000000000000000000","-10000000000000000000","-10000000000000000000","-10000000000000000000","-10000000000000000000","-10000000000000000000","-10000000000000000000","-10000000000000000000","-10000000000000000000","-10000000000000000000",9991234597,9991234599,9991234601),$lb(21,21,21,21,21,21,21,21,21,21,21,21,0,9,7),$lb(758198320,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,758198320,960051505,922746880,956301312,892942592,909127936,960051505))</Histogram>
<OutlierSelectivity>.857143:</OutlierSelectivity>
<Selectivity>2.8571%</Selectivity>
</Property>
<Property name="postCode">
<AverageFieldSize>9.83</AverageFieldSize>
<Histogram>$lb(.06666666666666666667,0,0,$lb(" BG18 2KS"," BQ34 5WE"," DT33 2DF"," FH34 6QJ"," GI34 9EN"," HP36 6KK"," IQ3 1AF"," KG1 7TH"," LS4 7ZX"," NM39 4CB"," QE36 3XA"," QR31 9HM"," UY22 4ZK"," VN31 7PB"," WZ33 2BH"," YK25 3DY"),$lb(2,1,1,1,1,1,1,1,1,1,2,1,1,1,1),$lb(541214513,1194407968,1362310176,1112617780,1146368819,1146368819,1179136820,1179136820,1195979572,1195979572,1213215542,1213215542,1230058272,1230058272,1262956832,1262956832,1280521248,1280521248,1313682233,1313682233,1363489590,1160984096,1379086624,1364341553,1431908914,1431908914,1447965489,1447965489,1465529139,1465529139,1498100277,542722866))</Histogram>
<Selectivity>2.8571%</Selectivity>
</Property>
<Property name="sex">
<AverageFieldSize>3</AverageFieldSize>
<Histogram>$lb(.06666666666666666667,0,0,$lb(" F"," F"," F"," F"," F"," F"," F"," M"," M"," M"," M"," M"," M"," M"," M"," M"),$lb(3,3,3,3,3,3,1,3,3,3,3,3,3,3,3),$lb(541458432,0,0,0,0,0,0,0,0,0,0,0,0,1174405120,1291845632,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,541917184))</Histogram>
<Selectivity>50.0000%</Selectivity>
</Property>
<SQLMap name="IDKEY">
<BlockCount>-4</BlockCount>
</SQLMap>
<StreamLocation>^FLIP.Data.PatientsS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
