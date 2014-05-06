require "woundhl7/version"

module Woundhl7
  # Your code goes here...

  #<Status id: 124, wound_id: 1, stage: "III", stage_description: "Bear wound on foot.", appearance: "", drainage: "", odor: "", color: "#000000", treatment_response: "", treatment: "", length: nil, width: nil, depth: nil, tunnel: nil, pain: nil, note: "", active: true, created_at: "2014-05-05 18:54:54", updated_at: "2014-05-05 23:21:39", image_file_name: "image.jpg", image_content_type: "image/jpeg", image_file_size: 31510, image_updated_at: "2014-05-05 23:21:38">

  #Convert objects to messages or map 

  #Patient.find(n) 
  #Patient.find(n).wounds
  #Patient.find(n).wounds.select {|wound| wound.status }
  		#OUTPUT => {patient: {objinfo} }

  #SHOULD OUTPUT one hl7 msg per status
  def initialize(messages={})
  	@raw = messages
  	@segment_dlm = "\r"
  	@element_dlm = "|"
  	@item_dlm = "^"
  	SEGMENTS = ["MSH","NTE","PID","PV1","ORC","OBR"]
  end

  def delimit_msg(object)
  	if object.is_a (Patient)
  		delimit_patient(object)
  	elsif object.is_a (Wound)
  		delimit_wound(object)
  	elsif object.is_a (Status)
  		delimit_status(object)
  	end
  end

  def replace_ws_w_delim(string)
  	string.gsub(/\s/, '^')
  end

  def delimit_patient(patient)
  	#http://www.interfaceware.com/hl7-standard/hl7-segment-PID.html
  	"PV1||{patientclass_here}|#{patient.name}|{patient_bday_here}||#{patient.sex}"
  end

  def hl7_time
  	DateTime.now.strftime("%y%m%d%R").gsub(/:/,"")
  end

  def place_header
  	"MSH|^~\&|WA|WAMS|#{hl7_time}|MSG|{message_control_id_here}|{processing_id}|{version_id}"
  end



  #maps each status to hl7 segments
  	##MESSAGES

  		#THIS IS WHAT WE'LL RETURN
  		#http://www.interfaceware.com/hl7-standard/hl7-segment-OBX.html
  	# 	MSH |^~\&| WA1 |
		# 	NTE ||
			# PID ||	 		
  	# 	PV1 ||
  	
  	#   ORC || 
  	#		OBR ||



	  	##SEGMENTS
	  		#MSH - Message Header
	  		#EVN - Event
	  		#ERR - error
	  		#EVN - event type

	  		#FAC - Facility
				#PID - Patient ID
				#PV1 - Patient visit
				#PV2 - Patient visit - additional information

	  		#OBX - Observation/Result
	  		#NTE - Notes and comments

	  		# RDF - Table row definition
	  		# RDT - Table row data

				#-- -- 

	  		#WND = Wound
	  		#ULC = Ulcer
	  		#WNDA = Wound abscess
	  		#WNDE = Wound exudate
	  		#WNDD = Wound drainage

	  		#APER = appearance
	  		#COLOR = color
	  		#LEN = length

	  				### FIELDS

	  					#ST = string data
	  					#TX = text data
	  					#TM = time
	  					#DATE = date
	  					#DTM = date/time

  #outputs hl7 message 
  	#use '|' for delimiter
		  #fill all spaces with '^'

  PV1 = [:wound_id,
         :stage,
         :stage_description,
         :appearance,
         :drainage,
         :odor,
         :color,
         :treatment_response,
         :treatment,
         :length,
         :width,
         :depth,
         :tunnel,
         :pain,
         :note,
         :active, default: true]

end
