<!DOCTYPE html>
<html>
  <head>
    <title>HCSC Status Report</title>
    <meta charset='utf-8' />
  </head>
  <body>
    <H2>HCSC Status report</h2>

    <!--Add buttons to initiate auth sequence and sign out-->
    <button id="authorize-button" style="display: none;">Authorize</button>
    <button id="signout-button" style="display: none;">Sign Out</button> </br>
    
    <button id="generateAllReports-button" style="display: none;">Generate All Reports</button> </br></br>
    
    <p>Testing</p>
	<button id="generateVantageReport-button" style="display: none;">Generate Vantage 1.0 Report</button></br>
	<button id="generateEMBReport-button" style="display: none;">Generate EMB Report</button></br>
	<button id="generateReadyToSellReport-button" style="display: none;">Generate Ready To Sell Report</button></br>
	<p>Prod</p>
	<button id="prodGenerateVantageReport-button" style="display: none;">Generate Vantage 1.0 Report</button></br>
	<button id="prodGenerateEMBReport-button" style="display: none;">Generate EMB Report</button></br>
	<button id="prodGenerateReadyToSellReport-button" style="display: none;">Generate Ready To Sell Report</button></br>
    <pre id="vantageContent"></pre>
    <pre id="retailServicesContent"></pre>
    <pre id="embContent"></pre>

    <script type="text/javascript">
      // Client ID and API key from the Developer Console
      var now = new Date();
      var morningStatusTime = new Date(now.getFullYear(), now.getMonth(), now.getDate(), 11, 30, 0, 0) - now;
	  var evngStatusTime = new Date(now.getFullYear(), now.getMonth(), now.getDate(), 20, 30, 0, 0) - now;
	  debugger;
	  if (morningStatusTime < 0 ) {
		  morningStatusTime += 86400000; // it's after 10am, try 10am tomorrow.
	  }
		setTimeout(function(){ //alert("It's Morning Status update time!");			
			if((now.getDay()+1)<6){
				debugger;
		  	 	generateReport(); 
		  	 }			
		}, morningStatusTime);
		
	 if (evngStatusTime < 0) {
		 evngStatusTime += 86400000; // it's after 10am, try 10am tomorrow.
      }
	  setTimeout(function(){//alert("It's Evng Status Time!");	  
	  	 if((now.getDay()+1)<6){
	  		debugger;
	  	 	generateReport(); 
	  	 }
	  }, evngStatusTime);	
	  
	  var Sheets_CLIENT_ID = '222139293275-2j9l2k31gvb4naj26154rl9bhkqhcd55.apps.googleusercontent.com';

      // Array of API discovery doc URLs for APIs used by the quickstart
      var Sheets_DISCOVERY_DOCS = ["https://sheets.googleapis.com/$discovery/rest?version=v4","https://www.googleapis.com/discovery/v1/apis/gmail/v1/rest"];
	  

      // Authorization scopes required by the API; multiple scopes can be
      // included, separated by spaces.
      var Sheets_SCOPES = "https://www.googleapis.com/auth/spreadsheets.readonly https://mail.google.com/";
	  
	  
      var authorizeButton = document.getElementById('authorize-button');
      var signoutButton = document.getElementById('signout-button');
      
      var generateAllReportsButton = document.getElementById('generateAllReports-button');
      
      var generateVantageReportButton = document.getElementById('generateVantageReport-button');
      var generateEMBReportButton =  document.getElementById('generateEMBReport-button');
      var generateReadyToSellReportButton =  document.getElementById('generateReadyToSellReport-button');
      
      var prodGenerateVantageReportButton = document.getElementById('prodGenerateVantageReport-button');
      var prodGenerateEMBReportButton =  document.getElementById('prodGenerateEMBReport-button');
      var prodGenerateReadyToSellReportButton =  document.getElementById('prodGenerateReadyToSellReport-button');
      
      /**
       *  On load, called to load the auth2 library and API client library.
       */
      function handleClientLoad() {
        gapi.load('client:auth2', initClient);
		
      }

      /**
       *  Initializes the API client library and sets up sign-in state
       *  listeners.
       */
      function initClient() {
	  
        gapi.client.init({
          discoveryDocs: Sheets_DISCOVERY_DOCS,
          clientId: Sheets_CLIENT_ID,
          scope: Sheets_SCOPES
        }).then(function () {
          // Listen for sign-in state changes.
          gapi.auth2.getAuthInstance().isSignedIn.listen(updateSigninStatus);

          // Handle the initial sign-in state.
          updateSigninStatus(gapi.auth2.getAuthInstance().isSignedIn.get());
          authorizeButton.onclick = handleAuthClick;
          signoutButton.onclick = handleSignoutClick;
          
          generateAllReportsButton.onclick = generateReport;
          
          generateVantageReportButton.onclick = generateVantageReport;
          generateEMBReportButton.onclick = generateEMBReport;
          generateReadyToSellReportButton.onclick = generateReadyToSellReport;
          
          prodGenerateVantageReportButton.onclick = prodGenerateVantageReport;
          prodGenerateEMBReportButton.onclick = prodGenerateEMBReport;
          prodGenerateReadyToSellReportButton.onclick = prodGenerateReadyToSellReport;
        });
      }
	  
      var generateVantageReport = function (){
    	  generateStatus('Vantage1.0','manikumar.ravva@ggktech.com');
      }
	  var generateEMBReport = function (){
		  generateStatus('EMB','manikumar.ravva@ggktech.com');
      }
	  var generateReadyToSellReport = function (){
		  generateStatus('ReadyToSell','manikumar.ravva@ggktech.com');
	  }
      
	  var prodGenerateVantageReport = function (){
		  generateStatus('Vantage1.0','HCSC.Vantage1.0@ggktech.com');
	  } 
	  var prodGenerateEMBReport = function (){
		  generateStatus('EMB','HCSC.EMB@ggktech.com');
	  } 
	  var prodGenerateReadyToSellReport = function (){
		  generateStatus('ReadyToSell','HCSC.Sales@ggktech.com');
	  } 
      var generateReport = function (){
    	  
    	  /* generateStatus('EMB','manikumar.ravva@ggktech.com');
          generateStatus('Vantage1.0','manikumar.ravva@ggktech.com');
          generateStatus('ReadyToSell','manikumar.ravva@ggktech.com'); */
          
          generateStatus('EMB','HCSC.EMB@ggktech.com');
          generateStatus('Vantage1.0','HCSC.Vantage1.0@ggktech.com');
          generateStatus('ReadyToSell','HCSC.Sales@ggktech.com');  
      }
      
      /**
       *  Called when the signed in status changes, to update the UI
       *  appropriately. After a sign-in, the API is called.
       */
      function updateSigninStatus(isSignedIn) {
        if (isSignedIn) {
          authorizeButton.style.display = 'none';
          signoutButton.style.display = 'block';
          
          generateAllReportsButton.style.display = 'block';
          
          generateVantageReportButton.style.display = 'block';
          generateEMBReportButton.style.display = 'block';
          generateReadyToSellReportButton.style.display = 'block';
          
          prodGenerateVantageReportButton.style.display = 'block';
          prodGenerateEMBReportButton.style.display = 'block';
          prodGenerateReadyToSellReportButton.style.display = 'block';
          
          //if(new Date().getHours() == 12 || new Date().getHours() == 21){
          //}

        } else {
          authorizeButton.style.display = 'block';
          signoutButton.style.display = 'none';
        }
      }

      /**
       *  Sign in the user upon button click.
       */
      function handleAuthClick(event) {
        gapi.auth2.getAuthInstance().signIn();
      }

      /**
       *  Sign out the user upon button click.
       */
      function handleSignoutClick(event) {
        gapi.auth2.getAuthInstance().signOut();
      }

      /**
       * Append a pre element to the body containing the given message
       * as its text node. Used to display the results of the API call.
       *
       * @param {string} message Text to be placed in pre element.
       */var pre ='';
      function appendPre(message) {
        pre=pre+message;
      }

      /**
       * Print the names and majors of students in a sample spreadsheet:
       * https://docs.google.com/spreadsheets/d/1BxiMVs0XRA5nFMdKvBdBZjgmUUqptlbs74OgvE2upms/edit
       */
       function generateStatus(sheetName,eMailAlias) {
    	   debugger;
       	   var ranges ='';   	   
           gapi.client.sheets.spreadsheets.values.get({
             range: sheetName+'!A1:K15',
             includeGridData: false,
             spreadsheetId: '1ftfPx8HbUFLD0OrA1MUyHaR2xFeMcE1_FN8BLTRnC7o',
           }).then(function(response) {
            ranges = response.result;
           }, function(response) {
             appendPre('Error: ' + response.result.error.message);
           });
    		setTimeout(function(){ 
    			sendEmail(sheetName,ranges,eMailAlias);  
    		}, 3000);
        }
      
       function sendEmail(sheetName,ranges,eMailAlias) {
			for(var i in ranges.values) { 
			    var statusRow = ranges.values[i];
			    for(var j = 0; j<11; j++) {
			    	var statusCell = statusRow[j];
				    if(statusCell==undefined){
				    	ranges.values[i][j]='';	
				    }
				}
			}
			if(sheetName=='ReadyToSell'){
		    	var subject     = 'Ready To Sell';
		    	var bgClr = '#CED2F1';
	    	}
	    	else if(sheetName=='Vantage1.0'){
	    		var subject     = 'Vantage 1.0 Daily';
	    		var bgClr = '#CBF5C3';
	    	}
		    else {
		    	var subject     = 'EMB Daily';
		    	var bgClr = '#F3E0DB';
		    }
		    
		    if(new Date().getHours() <= 16){
		    	subject+=' Tasks';
		    }
		    else{
		    	subject+=' Status';
		    }
		    var currentDate = new Date();
		    subject += ' '+currentDate.getDate()+'/'+(currentDate.getMonth()+1)+'/'+currentDate.getFullYear();
			var content = "";
			var needMail = false;
		    content += "<html>";
		    content += " <link rel='stylesheet' href='//maxcdn.bootstrapcdn.com/bootstrap/3.3.5/css/bootstrap.min.css'>";
		    content += " <link rel='stylesheet' href='//maxcdn.bootstrapcdn.com/bootstrap/3.3.5/css/bootstrap-theme.min.css'>";
		    content += "<body>";
		    content += "<table width='100%' ><tr><td>"; // Outer table
		    content += "<h4>Hi Team,</h4>";
		    content += "<h4>Please find today's Status</h4>"
		    content += "<table width='100%' border='3px' border=true style='background-color: ghostwhite;'>"; // Nested table
		    
		    for (i = 0;i<ranges.values.length; i++) {
		        var row = ranges.values[i];
		        if(ranges.values[i][0] == 'Application Name'){
		        	if(i==0){
		        		content += '<tr style="border:black;" bgcolor=\"'+bgClr+'\"><th style= "text-align: center; padding: 8px">'+row[0] + '</th style= "text-align: center; padding: 8px"><th style= "text-align: center; padding: 8px">'+ row[1] +'</th><th style= "text-align: center; padding: 8px">' +row[2] +'</th><th style= "text-align: center; padding: 8px">'+row[3] + '</th><th style= "text-align: center; padding: 8px">'+row[4]+'</th><th>'+row[6]+'</th><th style= "text-align: center; padding: 8px">'+row[7]+'</th>';
		        		if(new Date().getHours() > 16){
		        			content += '<th style= "text-align: center; padding: 8px">'+row[8]+'</th><th style= "text-align: center; padding: 8px">'+row[9]+'</th><th style= "text-align: center; padding: 8px">'+row[10]+'</th>';
		        		}
		        		content +='</tr>';
		        	}
		        }
		        else{
		        	if(ranges.values[i] && ranges.values[i].length > 0 ){
			        	var assignDateStr = ranges.values[i][5];
			        	var assignDate = new Date(assignDateStr.split('/')[2],assignDateStr.split('/')[0]-1,assignDateStr.split('/')[1]);
			        	if(assignDate.getDate() == new Date().getDate()){
			        		content += '<tr style="border:inset;" ><td style= "text-align: center; padding: 8px">'+row[0] + '</td><td style= "text-align: left; padding: 8px">'+ row[1] +'</td><td style= "text-align: left; padding: 8px">' +row[2] +'</td><td style= "text-align: center; padding: 8px">'+row[3] + '</td><td style= "text-align: center; padding: 8px">'+row[4]+'</td><td style= "text-align: center; padding: 8px">'+row[6]+'</td><td style= "text-align: center; padding: 8px">'+row[7]+'</td>'
			        		if(new Date().getHours() > 16){
			        			content += '<td style= "text-align: center; padding: 8px">'+row[8]+'</td><td style= "text-align: center; padding: 8px">'+row[9]+'</td><td style= "text-align: center; padding: 8px">'+row[10]+'</td>';
			        		}
			        		content += ' </tr>';
			        	}
			        	needMail = true;
		        	}		         	
		    	}    	
	    	}    
		    content += "</table>";
		    content += "</td></tr></table>";
		    content += "<h5><i>Note : It's an auto generated mail, please do not reply.</i></h5>"    
		    content += "</body>"
		    content += "<style>table {border-collapse: collapse;width: 100%;}"
		    content += "th, td {text-align: center;padding: 8px;}"
		    content += "tr:nth-child(even){background-color: #f2f2f2}"
		    content += "</style></html>";
			
		    if(sheetName=='ReadyToSell'){
		    	var div = document.getElementById('retailServicesContent');
	    	}
	    	else if(sheetName=='Vantage1.0'){
	    		var div = document.getElementById('vantageContent');
	    	}
		    else {
		    	var div = document.getElementById('embContent');
		    }		    

		    div.innerHTML += content;
		    
		    var receiver    = eMailAlias;
		    var to          = receiver;
		    
		    var contentType = 'Content-Type: text/plain; charset=utf-8';
		    var mime        = 'MIME-Version: 1.0';
		
		    //console.log(content)
		    
		    var message =
		    	"From:  \""+subject+"\"<manikumar.ravva@ggktech.com>\r\n" +
		        "To: " + to + "\r\n" +
		        "Subject: " + subject + "\r\n" +
		        "Content-Type: text/html; charset='UTF-8'\r\n" +
		        "Content-Transfer-Encoding: base64\r\n\r\n" +
		        "<html><body>" +
		        content +
		        "</body></html>";
		    if(needMail){
	        	sendMessage(message);	        	
	       	}
		};

function sendMessage(message) {
   //var headers = getClientRequestHeaders();
   debugger;
    var path = "gmail/v1/users/me/messages/send?key=" + Sheets_CLIENT_ID;
    var base64EncodedEmail = btoa(message).replace(/\+/g, '-').replace(/\//g, '_');
    gapi.client.request({
        path: path,
        method: "POST",
        headers: '',
        body: {
            'raw': base64EncodedEmail
        }
    }).then(function (response) {
		//alert('WOW!...Mail Sent');
    });
}
    </script>

    <script async defer src="https://apis.google.com/js/api.js"
      onload="this.onload=function(){};handleClientLoad()"
      onreadystatechange="if (this.readyState === 'complete') this.onload()">
    </script>
  </body>
  <style>
table {
    font-family: arial, sans-serif;
    border-collapse: collapse;
    width: 100%;
}

td, th {
    border: 1px solid #dddddd;
    text-align: center;
    padding: 8px;
}

tr:nth-child(even) {
    background-color: #dddddd;
}
</style>
</html>