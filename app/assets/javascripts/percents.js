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



function send_message(web_from,type) {
    var message = $(".m_text div:first").html() + $(".m_text div:last").html();
    $.ajax({
        async:true,
        data:{
            message :message
        },
        dataType:'script',
        url:"/percents/send_message?web=" + web_from + "&type=" + type,
        type:'post'
    });
    return false;
}

function send_qq_share(){
    var message = $("#result").html() + $("#link").html();
    fusion2.dialog.share
    ({
        // 可选。分享应用的URL，点击该URL可以进入应用，必须是应用在平台内的地址。
        url:"http://rc.qzone.qq.com/myhome/100625006",

        // 可选。默认展示在输入框里的分享理由。
        desc:message,

        // 必须。应用简要描述。
        summary :"赶考网开发，用于测试广大考生四六级通过概率，提升考生认知及自我鼓励。",

        // 必须。分享的标题。
        title :"测测你的四级通过概率",

        // 可选。图片的URL。
        pics :$("#img_url").val(),

        // 可选。透传参数，用于onSuccess回调时传入的参数，用于识别请求。
        context:"share",

        // 可选。用户操作后的回调方法。
        onSuccess : function (opt) {
        },

        // 可选。用户取消操作后的回调方法。
        onCancel : function () {
        },

        // 可选。对话框关闭时的回调方法。
        onClose : function () {
        }

    });

}

function go_back(){
    fusion2.nav.toHome
    ({
        // 可选。为true则在当前窗口打开，为false或不指定则在新窗口打开。
        self : true
    });
}

