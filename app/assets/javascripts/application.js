// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require_tree .

$(document).ready(function() {
        
    // Preloading set
     // hide spinner
    $(".loading").hide();
  
  
    // show spinner on AJAX start
    $(document).ajaxStart(function(){
      $(".loading").fadeIn(1000);
    });
  
    // hide spinner on AJAX stop
    $(document).ajaxStop(function(){
      $(".loading").fadeOut(1000);
    });
    
    // SmoothScroll Trigger
    smoothScroll.init();
    
    
    // ScrollReveal Trigger
    window.sr = ScrollReveal({ reset: true });
    sr.reveal('.tile',{duration:2000});
    sr.reveal('.tip');
    
    //TimeTable
    $(".schedule").css("visibility", "hidden");

    //Amazon Mobile Analytics
    AWS.config.region = 'us-east-1';
    AWS.config.credentials = new AWS.CognitoIdentityCredentials({
        IdentityPoolId: 'us-east-1:0311119e-fa46-4f05-86d6-91d78dbe851a' //Amazon Cognito Identity Pool ID
    });
    
    var options = {
        appId : 'c2490fa794144410b3f6d0f7411b3b1b', //Amazon Mobile Analytics App ID
    };
    
    var mobileAnalyticsClient = new AMA.Manager(options);
    mobileAnalyticsClient.submitEvents();
  
});

// Timetable
function addTimetableEvent(){
  var $type = $("#type optgroup option:selected").val();
  var $day = $("#day optgroup option:selected").val();
  var $startValue = $("#start optgroup option:selected");
  var $endValue = $("#end optgroup option:selected");
  if(parseInt($startValue.val()) > parseInt($endValue.val())){
    alert("시작 교시가 종료 교시보다 늦을 수 없습니다.");
  }else{
    var color = randColor();
    for($i=parseInt($startValue.val());$i<=parseInt($endValue.val());$i++){
      $(".check_"+$day+"_"+$i+"_"+$type).attr("value", 2);
      $(".td_"+$day+"_"+$i+"_"+$type).css("background-color", color);
    }
  }
}

function timetable_selection(value){
  if(value == 2){
    var numericOptions = {
      "1교시":1,
      "2교시":2,
      "3교시":3,
      "4교시":4,
      "5교시":5,
      "6교시":6,
      "7교시":7,
      "8교시":8,
      "9교시":9,
      "10교시":10,
      "11교시":11
    };
    
    var $start = $("#start > optgroup");
    $start.empty(); // remove old options
    $.each(numericOptions, function(key,value) {
      $start.append($("<option></option>")
         .attr("value", value).text(key));
    });
    var $end = $("#end > optgroup");
    $end.empty(); // remove old options
    $.each(numericOptions, function(key,value) {
      $end.append($("<option></option>")
         .attr("value", value).text(key));
    });
  }else if(value == 1){
    var literalOptions = {
      "A교시":1, "B교시":2,
      "C교시":3, "D교시":4,
      "E교시":5, "F교시":6,
      "G교시":7, "H교시":8
    };
    var $start = $("#start > optgroup");
    $start.empty(); // remove old options
    $.each(literalOptions, function(key,value) {
      $start.append($("<option></option>")
         .attr("value", value).text(key));
    });
    var $end = $("#end > optgroup");
    $end.empty(); // remove old options
    $.each(literalOptions, function(key,value) {
      $end.append($("<option></option>")
         .attr("value", value).text(key));
    });
  }
}

function resetSchedule(){
  $("td input").attr("value","1");
  $("td.time").css("background-color","#eff0f1");
}

function randColor(){
  var array = ["#3498db", "#9b59b6", "#34495e", "#2ecc71", "#e74c3c", "#f39c12"];
  return array[Math.floor((Math.random() * 6))];
}

function previewLoc(){
  $(".locationPreview").html('<iframe width="100%" height=auto frameborder="0" style="border:0" src="https://www.google.com/maps/embed/v1/search?q='+$("#preview").val()+'&key=AIzaSyBO67biQvnS3Bz6Ye9lUMD8s6e93OWZXTs"></iframe><a onClick="use_this_place();" class="btn btn-lg btn-block btn-inverse">이 위치 사용</a>');
}

function use_this_place(){
  $("#location").attr("value", $("#preview").val());
}

function like_it(user_id, place_id){
   if(!($(".like_"+place_id).hasClass("disabled"))){
      $.ajax({
        method:"post",
        url: '/find/place/like/',
        data:{uid: user_id, pid: place_id},
        success:function(data){
          $(".like_"+place_id).text("♥ "+data.likes).attr("disabled", "disabled").addClass("disabled").attr("data-toggle", "tooltip").attr("title", "이미 추천하셨습니다.");
        }
      });
   }
}

function isResvAvailable(date, start, end, place_id){
  $.ajax({
    method:"post",
    url: '/find/place/reservation/search/',
    data:{when: date, schedule: start, duration: end, pid: place_id},
    success:function(data){
      if(data.isAvailable == true){
        $("div#isAvailable").html("예약 가능").css("background", "linear-gradient(20deg, #6fe3e7, #4fb8d9 25%, #5648c1)");
        $("input[type='submit']").attr('disabled', false);
      }else{
        $("div#isAvailable").html("예약 불가").css("background", "linear-gradient(-20deg, #d23c39, #dca74a)");
       	$("input[type='submit']").attr('disabled', true);
      }
    }
  });
}