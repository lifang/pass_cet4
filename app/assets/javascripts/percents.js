//答题过程
$(document).ready(function(){
    var sum = 0;
    $('li').bind("click",function(){
        $(this).siblings().removeClass("dui");
        $(this).toggleClass("dui");   
    });
    $(".next_btn").bind("click",function(){
        var curr_p_div = $(this).parent().parent();
        curr_p_div.hide();
        var next_div = curr_p_div.next();
        if (next_div.attr("class") == "main") {
            curr_p_div.next().show();
        } else {
            if($("li.dui").length <= 0){
                next_div.prev().show();
                alert("请先回答问题");
                return false;
            }
            if($("li.dui").length<5){
                next_div.prev().show();
                alert("请回答所有问题");
                return false;
            }
            if ($("li.dui").length==5){
                for (var i=0; i<5; i++) {
                    sum += parseInt($($("li.dui")[i]).attr("value"));
                }
            }
            window.location.href="/percents/result?sum="+sum;
        }
    });
    $(".prev_btn").bind("click",function(){
        var curr_p_div = $(this).parent().parent();
        curr_p_div.hide();
        curr_p_div.prev().show();
    });
})



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

//生成图片
function sent_to_album(score, current_type) {
    $.ajax({
        async:true,
        data:{
            score :score,
            current_type : current_type
        },
        dataType:'script',
        url:"/images",
        type:'post'
    });
    return false;
}
