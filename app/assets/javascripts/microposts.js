$(document).ready(function() {
  $("#micropost_content").keyup(function() {
  	var counter = $("#counter");
  	var charsRemaining = 140 - $(this).val().length;
  	counter.text(charsRemaining + ' characters left');
  	if (charsRemaining < 0) {
  		counter.css('color', 'red')
  	}
  });
});