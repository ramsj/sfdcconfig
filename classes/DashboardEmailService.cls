global with sharing class DashboardEmailService implements Messaging.InboundEmailHandler{
	
	//Email Prcocessing Method handles upto 32768*2 character lengths
	global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email, Messaging.InboundEnvelope envelope){
	 	// Apex Email Service
    	Messaging.InboundEmailResult result = new Messaging.InboundEmailResult();
  		//Email Subject 
  		String subject = email.subject!=null ? (email.subject.length()>255? email.subject.substring(0, 254) :email.subject ): 'NA';
  		//From Address
  		String fromAddress = email.fromAddress!=null ? email.fromAddress : 'NA';
  		//html body response
    	String htmltemp= email!=null? (email.htmlBody!=null ? email.htmlBody : email.plainTextBody) : '';
    	//Split the body into two blocks if its greater than 32768 character 
    	String htmltext1 = htmltemp.length() > 32768 ? htmltemp.substring(0, 32767) : htmltemp;
    	String htmltext2 =  htmltemp.length() > 32769 ? htmltemp.substring(32767, (32767*2 -1)) : ''; 
    	try{
			//insert into dashboard table
			Dashboard_Snapshot__c snapshot = new Dashboard_Snapshot__c(Name =subject, From_Email_Address__c=fromAddress,
												HTML_Response1__c=htmltext1, HTML_Response2__c=htmltext2);
			insert snapshot;
			result.success = true;	
    	}catch(Exception ex){
    		System.debug(logginglevel.error, 'Error Ocuured -'+ex);
    		result.success = false;
    	}
		return result;
	}
}