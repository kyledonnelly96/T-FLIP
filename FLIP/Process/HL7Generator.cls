Class FLIP.Process.HL7Generator Extends Ens.BusinessProcess [ ClassType = persistent ]
{

Method OnRequest(pRequest As Ens.Request, Output pResponse As Ens.Response) As %Status
{
	set t=$$$OK
	
	Do ..CreateHL7(pRequest,.enrichedHL7)
		
	set hl7String=enrichedHL7.OutputToString()
		
	
		
	set req=##class(Ens.StringContainer).%New()
	set qry="INSERT INTO tflip.hl7_adt(hl7) VALUES ('"_hl7String_"')"
	set req.StringValue=qry
	
	$$$LOGINFO(qry)
		

		set t=..SendRequestSync("ExecuteUpdate", req)
		quit t
}

ClassMethod CreateHL7(pInput As Ens.Request, Output enrichedHL7 As EnsLib.HL7.Message)
{
	set t=$$$OK
	
	set hl7=##class(EnsLib.HL7.Message).%New()
	set hl7.DocType="2.4:ADT_A05"
	
	
	//msh
	set msh=##class(EnsLib.HL7.Segment).%New()
	set t=msh.SetValueAt("MSH","0")
	set t=msh.SetValueAt("^~\&","2")
	set t=msh.SetValueAt("PAS","3")
	set t=msh.SetValueAt("PAS","4")
	set t=msh.SetValueAt("FLIP","5")
	set t=msh.SetValueAt("FLIP","6")
	
	set dateTime=$ZDT($H,8,5)
	set dateTime=$E(dateTime,0,8)_$E(dateTime,10,11)_$E(dateTime,13,14)_$E(dateTime,16,17)
	set t=msh.SetValueAt(dateTime,"7")
	
	set t=msh.SetValueAt("ADT^A28","9")
	
	set guid=$System.Util.CreateGUID()
	
	set t=msh.SetValueAt(guid,"10.1")
	
	set t=msh.SetValueAt("2.4","12.1")
	
	set t=hl7.SetSegmentAt(msh,"1")
	
	//evn
	set evn=##class(EnsLib.HL7.Segment).%New()
	set t=evn.SetValueAt("EVN","0")
	set t=evn.SetValueAt(dateTime,"2.1")
	set t=evn.SetValueAt(dateTime,"6.1")
	set t=hl7.AppendSegment(evn)
	
	//pid
	set pid=##class(EnsLib.HL7.Segment).%New()
	set t=pid.SetValueAt("PID","0")
	
	set lastMRN=""
	set lastNHS=""
		
	set lastNHS=##class(Ens.Util.FunctionSet).Lookup("FLIP.Configuration","lastNHS")
	set lastMRN=##class(Ens.Util.FunctionSet).Lookup("FLIP.Configuration","lastMRN")	
	
		
	set nhs=lastNHS+1
	set mrn=lastMRN+1
	do ##class(Ens.Util.LookupTable).%UpdateValue("FLIP.Configuration","lastMRN",mrn)
	do ##class(Ens.Util.LookupTable).%UpdateValue("FLIP.Configuration","lastNHS",nhs)
	
	//get prefix
	set prefix=##class(Ens.Util.FunctionSet).Lookup("FLIP.Configuration","mrnPrefix")
	
	
	set t=pid.SetValueAt(prefix_mrn_"^^^CMMRN^MRN","3(1)")
	set t=pid.SetValueAt(nhs_"^^^NHS^NHS^NHS","3(2)")
	
	set x=$RANDOM(2)
	set x=$CASE(x,0:1,1:2)	
	set lastName=$ZCONVERT(##class(%PopulateUtils).LastName(),"U")
	
	set firstName=$ZCONVERT(##class(%PopulateUtils).FirstName(x),"U")
	
	set t=pid.SetValueAt(lastName_"^"_firstName,"5")

	
		
	set date=##class(%PopulateUtils).CDate(3,30000,55000)
	set date=$REPLACE(date,"-","")
	
	set t=pid.SetValueAt(date,"7.1")
	
	$$$LOGINFO(x)
	
	set sex=$CASE(x,1:"M",2:"F")
	
	set t=pid.SetValueAt(sex,"8")
	
	//post code
	set outcode=##class(%PopulateUtils).StringMin(2,2)_##class(%PopulateUtils).Integer(1,40)
	set inCode=$RANDOM(10)_##class(%PopulateUtils).StringMin(2,2)
	set postCode=$ZCONVERT(outcode_" "_inCode,"U")
	
	set t=pid.SetValueAt(postCode,"11(1).5")
		
	//ethnic category
	
	$$$LOGINFO("HERE")
		
	set x=$RANDOM(9)
	set ethnicCategory=$CASE(x,0:"A",1:"B",2:"C",3:"D",4:"E",5:"F",6:"G",7:"H",7:"J",8:"Z")
	
	set t=pid.SetValueAt(ethnicCategory,"22(1).1")
	set t=pid.SetValueAt("N","30")
	
	set t=hl7.AppendSegment(pid)
	
	set enrichedHL7=hl7
	
	$$$LOGINFO("HERE")
	
	
	quit t
}

Storage Default
{
<Type>%Storage.Persistent</Type>
}

}
