Class FLIP.Data.BulkInsert Extends Ens.BusinessProcess
{

Method OnProcessInput(pInput As Ens.Request, Output pOutput As Ens.Response) As %Status
{
	set t=$$$OK
	
	set t=..BulkInsert(100,.qry)
	
	$$$LOGINFO(qry)
	
	set stringContainer=##class(Ens.StringContainer).%New()
	set stringContainer.StringValue=qry
	
	set t=..SendRequestSync("BulkDataOp",stringContainer)	
	
	
	quit t
}

ClassMethod BulkInsert(NewRecords As %Integer, Output Qry As %String)
{
	set start=0
	set end=NewRecords
	
	set Qry="INSERT INTO tflip.imaging_results"
	set Qry=Qry_"(pat_mrn, pat_nhs, pat_name, pat_dob, pat_sex, pat_postcode, pat_ethnicgroup, pat_nhstracest, pat_nhsoptoutst, ires_obsdttm, ires_fillerid, ires_accessionid, ires_service_id, ires_service_name, ires_service_idtype, ires_diagserviceid, ires_diagservice, ires_value, ires_status,rec_process) VALUES "
	
	while start < end
	{
		set start=start+1
	zw start
		if start>1
		{
			set seperator=","
		}
		else
		{
			set seperator=""
		}
		
		
		set accessionNmb="ACCN-"_##class(%PopulateUtils).Random(1000)
		set fillerNumber="FILL-"_##class(%PopulateUtils).Random(1000)
		
		set id=##class(%PopulateUtils).Integer(98,127)
		
		zw id
		
		set numb=##class(%PopulateUtils).Integer(0,1)
		set nhsTrace=$CASE(numb,0:"01",1:"02")

		
	&SQL(SELECT lastName,nhsNumb,mrn,sex,postCode,dob,ethnicCategory into:lastName,:nhs,:mrn,:sex,:postCode,:dob,:ethnicCategory
			FROM FLIP_Data.Patients WHERE ID=:id)
			
		set status=$CASE(numb,0:"F",1:"A")	
		
		set Qry=Qry_seperator_"("_"'"_mrn_"',"_nhs_",'"_$ZCONVERT(lastName,"U")_"','"_dob_"','"_sex_"','"_postCode_"','"_ethnicCategory_"','"_nhsTrace_"',TRUE,'2022-08-"_##class(%PopulateUtils).Integer(20,30)_" 00:00:00','"_fillerNumber_"','"_accessionNmb_"','CT','CT SCAN','SNOMED','333','CAT SCAN','RESULTED-NORMAL','"_status_"','0')"
	zw Qry
	}
	quit Qry
}

Storage Default
{
<Type>%Storage.Persistent</Type>
}

}
