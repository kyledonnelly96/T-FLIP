Class FLIP.Process.FHIRConvertor Extends Ens.BusinessProcess [ ClassType = persistent ]
{

Method OnRequest(pRequest As Ens.Request, Output pResponse As Ens.Response) As %Status
{
	set sc =$$$OK 

	IF $CLASSNAME(pRequest)=("FLIP.Classes.Images")
  	{

	  	do ..CreateImagingBundle(pRequest,.fhir)
	  	 	
  	}
  	ELSEIF $CLASSNAME(pRequest)=("FLIP.Classes.Document")
  	{
	  	do ..CreateDocumentBundle(pRequest,.fhir)
	  	
  	} ELSE
  	{
	  	quit sc
  	}
  	
  				
				
	IF sc
	{
		
		$$$TRACE("Sending FHIR to FLIP endpoint")
		//$$$TRACE(fhir.JSONString)
	
		
		set sc=..SendRequestSync("HTTP_SendToFlip",fhir)
					
	}	
		
			
	quit sc
}

Method CreateImagingBundle(obj As FLIP.Classes.Images, Output strmc As Ens.StreamContainer)
{
	
	set bundle={}
	set bundle.resourceType="Bundle"
	set bundle.type="collection"
	set bundle.entry=[]
	
	//IMAGING STUDY RESOURCE
	set img={}
	set img.resource={}
	set img.resource.resourceType="ImagingStudy"
	set img.resource.meta={}
	set img.resource.meta.profile="https://aicentre.co.uk/flip/ImagingStudy"
	
	set img.resource.subject={}
	set img.resource.subject.reference="Patient/"_obj.Patient.nhs
	
	set img.resource.status="available"
	set img.resource.started=##class(Ens.Util.Time).ConvertDateTime(obj.dateOfStudy,"%Y%m%d%H%M","%Y-%m-%d")
	
	
	set img.resource.modality={}
	set img.resource.modality.system="urn:oid:1.2.840.10008.6.1.19"
	set modalityCode=obj.modalityCode
	set img.resource.modality.code=modalityCode
	set modalityName=""
		
	&sql(SELECT CodeMeaning into :modalityName FROM FLIP_Tables.Modality WHERE CodeValue =:modalityCode)
	
	if modalityName'=""  set img.resource.modality.display=modalityName
	
	
	set img.resource.modality.display=modalityName
	
	
	
	set img.resource.procedureCode=[]
	set procedureCode={}
	set procedureCode.coding=[]
	set coding={}
	set coding.system="https://aicentre.co.uk/flip/PROCEDURE_CODE"
	set coding.code=obj.procedureCode
	set coding.display=obj.procedureName
	do procedureCode.coding.%Push(coding)
	do img.resource.procedureCode.%Push(procedureCode)
	
	//identifier
	
	//fillerID
	set img.resource.identifier=[]
	set filler={}
	set filler.use="official"
	set filler.type={}
	set filler.type.coding=[]
	set fillerCoding={}
	set fillerCoding.system="https://aicentre.co.uk/flip/PACS-LOCAL"
	set fillerCoding.code="FILLER"
	
	do filler.type.coding.%Push(fillerCoding)
	
	
	set filler.value=obj.fillerID
	
	//accessionID
	set acsn={}
	set acsn.use="official"
	set acsn.type={}
	set acsn.type.coding=[]
	set acsnCoding={}
	set acsnCoding.system="https://aicentre.co.uk/flip/PACS-LOCAL"
	set acsnCoding.code="ACSN"
	
	do acsn.type.coding.%Push(acsnCoding)
	
	set accessionID=obj.accessionID
	
	set acsn.value=accessionID
	
	
	do img.resource.identifier.%Push(filler)
	do img.resource.identifier.%Push(acsn)
	
	
	set img.resource.series=[]

	
	set series={}
	
	$$$LOGINFO(obj.seriesUID)
		$$$LOGINFO($L(obj.seriesUID))
	
	if (obj.seriesUID'="") && ($L(obj.seriesUID)>1)
	{ 	
		set seriesID=obj.seriesUID
	
	}
	else
	{
	//grab series id from local table
	
		set seriesID=""
		&sql(Select SeriesGUID into :seriesID from FLIP_Tables.ImageSeries WHERE AccessionID=:accessionID AND Modality=:modalityCode)
	
		IF seriesID=""
		{
			//create new guid
			set seriesID=$System.Util.CreateGUID()
		
			//insert into local table
			&sql(INSERT INTO FLIP_Tables.ImageSeries (Modality,AccessionID,SeriesGUID) VALUES (:modalityCode,:accessionID,:seriesID))
		}	
	
	}
	
	
	set series.uid=seriesID
	

	
	IF obj.peformedBy'="" && $L(obj.peformedBy)>1
	{
		set series.performer={}
		set series.performer.actor={}
		set series.performer.actor.identifier={}
		set series.performer.actor.identifier.system="https://aicentre.co.uk/flip/PACS-LOCAL"
		set series.performer.actor.identifier.value=obj.peformedBy
	}

		set series.modality={}
		set series.modality.system="urn:oid:1.2.840.10008.6.1.19"
		set series.modality.code=obj.modalityCode
		if modalityName'=""  set series.modality.display=modalityName
		
	set latDisplay="" set latCode=obj.laterality
	
	&sql(SELECT CodeMeaning into:latDisplay FROM FLIP_Tables.Laterality where CodeValue=:latCode)
		
	IF latDisplay'="" 
	{
		set series.laterality={}
		set series.laterality.system="urn:oid:1.2.840.10008.6.1.1284"
		set series.laterality.code=latCode
		set series.laterality.display=latDisplay


	}	
	IF obj.bodysiteCode'="" 
	{
		set bodySiteCode=obj.bodysiteCode
		set series.bodySite={}
		set series.bodySite.system="https://dicom.nema.org/medical/dicom/current/output/chtml/part16/chapter_L.html"
		set series.bodySite.code=obj.bodysiteCode
		
		set bodySiteName=""
		
		&sql(SELECT CodeMeaning into :bodySiteName FROM FLIP_Tables.BodyPart WHERE CodeValue =:bodySiteCode)
		
		IF bodySiteName'="" set series.bodySite.display=bodySiteName


	}
	
	if (obj.instanceUID'="") && (obj.sopclassUID'="")
	{
	
		set sopclassName="" set sopUID=obj.sopclassUID
		&sql(SELECT CodeMeaning into :sopclassName FROM FLIP_Tables.SopClass WHERE CodeValue =:sopUID)
		IF sopclassName'=""
		{
		set series.instance={}
		set series.instance.uid=obj.instanceUID	
		set series.instance.sopClass={}
		set series.instance.sopClass.display=sopclassName
		set series.instance.sopClass.system="1.2.840.10008.15.0.​3.​14"
		set series.instance.sopClass.code=obj.sopclassUID
		}
		
	
		
		
	}
	else
	{
		$$$TRACE("Empty or invalid values in instance uid or sopclass uid")
		
	}		
	
		do img.resource.series.%Push(series)
	
	
	do bundle.entry.%Push(img)
	
	//PATIENT RESOURCE
	
	set pat={}
	set pat.resource={}
	set pat.resource.resourceType="Patient"
	set pat.resource.identifier=[]
	
	
	if (obj.Patient.nhs'="") 
	{
	
		set identifierNHS={}
		set identifierNHS.use="official"
		set identifierNHS.type={}
		set identifierNHS.type.coding=[]
		set coding={}
		set coding.code="NHS"
		set identifierNHS.value=obj.Patient.nhs
		DO identifierNHS.type.coding.%Push(coding)
		do pat.resource.identifier.%Push(identifierNHS)
	}
	
	set patSex=##class(Ens.Util.FunctionSet).Lookup("FLIP.Gender",obj.Patient.sex,"unknown",3)

	set pat.resource.gender=patSex
	
	set pat.resource.birthDate=##class(Ens.Util.Time).ConvertDateTime(obj.Patient.dob,"%Y%m%d","%Y-%m-%d")
	if obj.Patient.dod'="" set pat.resource.deceasedDateTime=##class(Ens.Util.Time).ConvertDateTime(obj.Patient.dod,"%Y%m%d","%Y-%m-%d")	
	
	/*
	set name={} set name.use="official" set name.text="Not Disclosed" set name.family="Not Disclosed"
	set name.given=["Not Disclosed"] set name.prefix=["Not Disclosed"]
	set pat.resource.name=[]
	do pat.resource.name.%Push(name)
	

	
	
	set address={}
	set pat.resource.address=[]
	set address.use="home"
	set address.type="postal"
	set address.postalCode=obj.Patient.postCode
	DO pat.resource.address.%Push(address)
	
	//add extension for ethnic code
	set pat.resource.extension=[]
	set extension={}
	set extension.url="https://fhir.hl7.org.uk/StructureDefinition/Extension-CareConnect-EthnicCategory-1"
	set extension.valueCodeableConcept={}
	set extension.valueCodeableConcept.coding=[]
	 set coding={} 
	set coding.system="EthnicCategory" set coding.code=##class(Ens.Util.FunctionSet).Lookup("FLIP.Ethnicity",obj.Patient.ethnicGroup,"Z") //return Z (not stated) if no mapping found
	do extension.valueCodeableConcept.coding.%Push(coding)
	do pat.resource.extension.%Push(extension)*/
	
	
	do bundle.entry.%Push(pat)
	


	//OBSERVATION RESOURCE
	
	IF obj.observationValue'=""  && obj.obsdttm'=""
	{
	
	set obs={}
	set obs.resource={}
	set obs.resource.resourceType="Observation"
	set obs.resource.status="final"
	
	set obs.resource.code=[]
	 set code={}
	 set code.coding=[]
	
	
	set coding={}
	set coding.system="https://aicentre.co.uk/flip/PACS-LOCAL"
	set coding.code=obj.procedureCode
	set coding.display=obj.procedureName
	do code.coding.%Push(coding)
	do obs.resource.code.%Push(code)
	
	$$$LOGINFO(obj.dateOfStudy)
	
	set obs.resource.effectiveDateTime=##class(Ens.Util.Time).ConvertDateTime(obj.obsdttm,"%Y%m%d%H%M","%Y-%m-%d")
	set obs.resource.valueString=obj.observationValue
	
	do bundle.entry.%Push(obs)
	
	

	
	
	}
	
	
	

	
	$$$TRACE("TEST"_bundle.%ToJSON())
	/*set fhir=##class(FLIP.Classes.SendFHIR).%New()
	set fhir.JSONString=bundle.%ToJSON()*/
	
	set strmc=##class(Ens.StreamContainer).%New()
	set strm=##class(%Stream.GblChrCompress).%New()
	set jsonFormatter=##class(%JSON.Formatter).%New()
	set json= bundle.%ToJSON()
	do jsonFormatter.FormatToStream(json,.strm)
	
	set strmc.Stream=strm
}

Method CreateDocumentBundle(obj As FLIP.Classes.Document, Output strmc As Ens.StreamContainer)
{
		
	
	set bundle={}
	set bundle.resourceType="Bundle"
	set bundle.type="collection"
	set bundle.entry=[]
	
	//PATIENT RESOURCE
	
	//PATIENT RESOURCE
	
	set pat={}
	set pat.resource={}
	set pat.resource.resourceType="Patient"
	set pat.resource.identifier=[]
	
	
	if (obj.Patient.nhs'="") 
	{
	
		set identifierNHS={}
		set identifierNHS.use="official"
		set identifierNHS.type={}
		set identifierNHS.type.coding=[]
		set coding={}
		set coding.code="NHS"
		set identifierNHS.value=obj.Patient.nhs
		DO identifierNHS.type.coding.%Push(coding)
		do pat.resource.identifier.%Push(identifierNHS)
	}
	
	set patSex=##class(Ens.Util.FunctionSet).Lookup("FLIP.Gender",obj.Patient.sex,"unknown",3)

	set pat.resource.gender=patSex
	
	set pat.resource.birthDate=##class(Ens.Util.Time).ConvertDateTime(obj.Patient.dob,"%Y%m%d","%Y-%m-%d")
	if obj.Patient.dod'="" set pat.resource.deceasedDateTime=##class(Ens.Util.Time).ConvertDateTime(obj.Patient.dod,"%Y%m%d","%Y-%m-%d")	
	
	
	do bundle.entry.%Push(pat)
	
	//Doc Ref resource
	
	set doc={}
	set doc.resource={}
	set doc.resource.resourceType="DocumentReference"
	set doc.resource.id=obj.ID
	set doc.resource.status="current"

	set doc.resource.docStatus="final"
		
	
	set doc.resource.identifier=[]
	
	set identifier={}
	set identifier.use="official"
	set identifier.type={}
	set identifier.type.coding=[]
	set type={}
	set type.code="DRN"
	set type.system="https://aicentre.co.uk/flip/DocMan"
	do identifier.type.coding.%Push(type)
	set identifier.value=obj.ID
	do doc.resource.identifier.%Push(identifier)
	
	
	set doc.resource.type={}
	set doc.resource.type.coding=[]
	set codingType={}
	set codingType.system="https://aicentre.co.uk/flip/DocMan"
	set codingType.code=obj.TypeID
	set codingType.display=obj.TypeName
	do doc.resource.type.coding.%Push(codingType)
	
	
	
	//CATEGORY
	set doc.resource.category={}
	set doc.resource.category.coding=[]
	set codingCategory={}
	set codingCategory.system="https://aicentre.co.uk/flip/DocMan"
	set codingCategory.code=obj.CategoryID
	set codingCategory.display=obj.CategoryName
	do doc.resource.category.coding.%Push(codingCategory)

	
	set doc.resource.subject={}
	set doc.resource.subject.reference="Patient/"_obj.Patient.nhs
	
	
	set doc.resource.date=##class(Ens.Util.Time).ConvertDateTime(obj.documentdate,"%Y%m%d%H%M","%Y-%m-%dT%H:%M:%S")_".000Z"
	
	

	
	set doc.resource.content=[]
	set content={}
	set content.attachment={}
	

	set b64=$system.Encryption.Base64Encode(obj.TextBlock,1)
	
	set content.attachment.data=b64
	
	
	
	do doc.resource.content.%Push(content)
	

	do bundle.entry.%Push(doc)
	
	set strmc=##class(Ens.StreamContainer).%New()
	set strm=##class(%Stream.GblChrCompress).%New()
	set jsonFormatter=##class(%JSON.Formatter).%New()
	set json= bundle.%ToJSON()
	do jsonFormatter.FormatToStream(json,.strm)
	
	set strmc.Stream=strm
}

Storage Default
{
<Type>%Storage.Persistent</Type>
}

}
