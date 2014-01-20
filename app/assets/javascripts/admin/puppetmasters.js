function updateProgress () {
  if ($("#progressbar").is(":visible")) {
  	var puppetmaster_id = $("#connection_status").attr("data-id");
  	$.getScript(puppetmaster_id + "/check_connection_status.js");
  }
}
