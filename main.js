var months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];

var getAppointments = function(query){
	var query = query || "";
	var data = "getAppointments=true";

	if (query != "") {
		data+="&q="+query;
	}

	//call CGI script with getAppointments param
	$.ajax({
		type: "GET",
		url: "/cgi-bin/echo.pl",
		dataType: "json",
		data: data,
		error: function(a,b,c) {
			alert(b);
		},
		success: function(perl_data, textStatus, jqXHR) {
			makeTable(perl_data);
		}
	});
}

var makeTable = function(data){
	var table = $("<table />");
	var appointments = data.appointments;
	var row, datetime, date, dateString, hour, ampm, time, timeString, desc;

	row = $("<tr><th>Date</th><th>Time</th><th>Description</th></tr>");
	table.append(row);

	for (var c=0; c<appointments.length; c++) {
		row = $("<tr />");
		table.append(row);

		//separate date and time
		datetime = new Date(appointments[c].time);
		dateString = months[datetime.getMonth()]
			+" "+datetime.getDate()+" "+datetime.getFullYear();

		hour = datetime.getHours();
		ampm = hour > 12 ? "pm" : "am";
		// convert to 12 hour format, set to 12 if hour is 0 
		hour = hour ? hour%12 : 12;
		timeString = hour+":"
			+("0"+datetime.getMinutes()).slice(-2)+ampm;

		desc = appointments[c].description;	

		row.append($("<td>" + dateString + "</td>"));
		row.append($("<td>" + timeString + "</td>"));
		row.append($("<td>" + desc + "</td>"));
	}
	$("#appointments").html(table);
}

$(document).ready(function(){
	var addFormDisplayed = false;
	getAppointments();
	$(".add").hide();
	
	$("#search_form").submit(function(e) {
		var query = $("#q").val(); 
		getAppointments(query);
		e.preventDefault();
	});

	$("#new_add").click(function(e) {
		if (!addFormDisplayed) {
			//change add to new
			$("#new_add").val("Add");
			addFormDisplayed = true;
			$(".add").show();
			e.preventDefault();
		}
	});

	$("#cancel").click(function(e) {
		$("#new_add").val("New");
		addFormDisplayed = false;
		$(".add").hide();
	});
});
