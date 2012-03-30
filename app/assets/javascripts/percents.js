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
//    if (web_from=="qq"){
//        $.ajax({
//            async:true,
//            data:{
//                ability :$("#ability_ul input:checked").val(),
//                heart :$("#heart_ul input:checked").val(),
//                attitude :$("#heart_ul input:checked").val(),
//                openid : openid,
//                openkey : openkey
//            },
//            dataType:'script',
//            url:"/percents/add_idol?web=" + web_from,
//            type:'post'
//        });
//        return false;
//    }else{
        $.ajax({
            async:true,
            data:{
                ability :$("#ability_ul input:checked").val(),
                heart :$("#heart_ul input:checked").val(),
                attitude :$("#attritude_ul input:checked").val(),
                web : web_from
            },
            dataType:'script',
            url:"/percents?web=" + web_from,
            type:'post'
        });
        return false;
//    }
}

function iframe_height(height){
    fusion2.canvas.setHeight
    ({
        // 可选。表示要调整的高度，不指定或指定为0则默认取当前窗口的实际高度。
        height : height
    });
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