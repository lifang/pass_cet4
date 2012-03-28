//检查是否都选择了
function check_message_form(web_from) {
    if ($("#ability_ul input:checked").length <= 0) {
        alert("请回答‘你目前的英语能力’");
        return false;
    }
    if ($("#heart_ul input:checked").length <= 0) {
        alert("请回答‘面对四级考试，心情如何’");
        return false;
    }
    if ($("#attritude_ul input:checked").length <= 0) {
        alert("请回答‘你学英语的态度’");
        return false;
    }
    $.ajax({
        async:true,
        data:{
            ability :$("#ability_ul input:checked").val(),
            heart :$("#heart_ul input:checked").val(),
            attitude :$("#heart_ul input:checked").val()
        },
        dataType:'script',
        url:"/percents?web=" + web_from,
        type:'post'
    });
    return false;
}

function send_message(web_from) {
    var message = $(".m_text div:first").html() + $(".m_text div:last").html();
    $.ajax({
        async:true,
        data:{
            message :message
        },
        dataType:'script',
        url:"/percents/send_message?web=" + web_from,
        type:'post'
    });
    return false;
}