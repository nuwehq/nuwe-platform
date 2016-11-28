$(function(){
  //show notices for a while, then remove.
  $(".notice").delay(3000).slideUp(500);
  $(".notice").click(function(event){
    $(this).hide();
    event.preventDefault();
  });
});
