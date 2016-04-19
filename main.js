var getAppointments = function(query){
	var query = query || "";

	alert(query);
	//call CGI script with getAppointments param
}

$(document).ready(function(){
	getAppointments();
	
	$("#search_form").submit(function(e) {
		var query = $("#q").val(); 
		getAppointments();
		e.preventDefault();
	});
});
