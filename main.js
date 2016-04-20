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
		error: function() {
			alert("fail");
		},
		success: function(perl_data, textStatus, jqXHR) {
			makeTable(perl_data);
		}
	});
}

var makeTable = function(data){
	var table = $("<table />");
	var appointments = data.appointments;
	var row, datetime, date, dateString, time, timeString, desc;

	for (var c=0; c<appointments.length; c++) {
		row = $("<tr />");
		table.append(row);

		//separate date and time
		datetime = appointments[c].time;
		alert(datetime);
		var a = new Date(datetime);
		alert(a);
		date = new Date(datetime.split(" ")[0]);
		dateString = date.getMonth()+" "+date.getDate();

		time = datetime.split(" ")[1];

		desc = appointments[c].description;	

		row.append($("<td>" + dateString + "</td>"));
		row.append($("<td>" + timeString + "</td>"));
		row.append($("<td>" + desc + "</td>"));
	}
	$("#appointments").append(table);
}

$(document).ready(function(){
	getAppointments();
	
	$("#search_form").submit(function(e) {
		var query = $("#q").val(); 
		getAppointments();
		e.preventDefault();
	});
});
