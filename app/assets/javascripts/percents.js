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


function send_qq_message(con){
    fusion2.dialog.tweet
    ({
        // 必须。默认显示在说说文字输入框中的文字内容。
        msg:con,

        // 可选。应用自定义参数，用于进入应用时CanvasUrl中的app_custom参数的值,应用可根据该参数判断用户来源。
        source:"adtag_tweet_share_exp",

        // 可选。要发表带贴图的说说时，这里需要传入图片的链接。
        url:"PictrueUrl",

        // 可选。用户操作后的回调方法。
        onSuccess : function (opt) {  },

        // 可选。用户取消操作后的回调方法。
        onCancel : function () {  },

        // 可选。对话框关闭时的回调方法。
        onClose : function () {  }

    });
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