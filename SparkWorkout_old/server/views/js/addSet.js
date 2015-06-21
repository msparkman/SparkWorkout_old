// FYI: I shamelessly stole this from www.randomsnippets.com/2008/02/21/how-to-dynamically-add-form-elements-via-javascript/ with a slight variation
var counter = 1;
function addSet(divId) {
	counter++;
	var newDiv = document.createElement('div');
	newDiv.innerHTML = "<b>Set " + counter + ":</b><br />" +
		"Number of reps: <input type=\"text\" name=\"set_array[][number_of_reps]\" /><br />" +
		"Weight: <input type=\"text\" name=\"set_array[][weight]\" /><br />" +
		"Comment: <input type=\"text\" name=\"set_array[][comment]\" /><br />";
	document.getElementById(divId).appendChild(newDiv);
}