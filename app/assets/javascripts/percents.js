//检查是否都选择了
function check_message_form() {
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
}