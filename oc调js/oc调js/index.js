$(function() {
    //alert("alert");
    $("#blank_div").text("这是js set的值");
    var user_info = JSON.parse(window.rrx.getUserInfo());
    alert(user_info.name)
    $("#rrx_content").text(user_info.name + ", " + user_info.idno + ", "+ user_info.mobile);
});


