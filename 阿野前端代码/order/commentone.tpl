<!DOCTYPE html>
<html lang="en">
<meta charset="UTF-8">
<link rel="shortcut icon" href="/images/favicon.ico"/>
<meta content="yes" name="apple-mobile-web-app-capable"/>
<meta content="yes" name="apple-touch-fullscreen"/>
<meta content="telephone=no" name="format-detection"/>
<meta content="black" name="apple-mobile-web-app-status-bar-style">
<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
<meta name="viewport" content="width=device-width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=no">
<title>评价商品</title>

<link rel="stylesheet" type="text/css" href="/kit/weui/css/base.css" />
<link rel="stylesheet" type="text/css" href="/kit/weui/css/weui.min.css" />
<link rel="stylesheet" type="text/css" href="/kit/weui/css/jquery-weui.min.css" />

<script type="text/javascript" src="/kit/jquery/jquery.min.js"></script>
<script type="text/javascript" src="/kit/weui/js/jquery-weui.min.js"></script>

<script type="text/javascript" src="http://res.wx.qq.com/open/js/jweixin-1.0.0.js"></script>
<script type="text/javascript" src="/kit/html5ImgCompress/html5ImgCompress.min.js"></script>

<style type="text/less">
    .star{
        display: inline-block;
        background: url(/images/wechat/comment_star.png) no-repeat;
        width: 26px;
        height: 26px;
        &.selected{
            background: url(/images/wechat/comment_star_selected.png) no-repeat;
        }
    }

    .uploadify-button{
        display: block;
        position: relative;
        width: 77px;
        height: 77px;
        border: 1px solid #D9D9D9;
    }
    .uploadify-button:before,.uploadify-button:after{
        content: " ";
        position: absolute;
        top: 50%;
        left: 50%;
        -webkit-transform: translate(-50%, -50%);
        transform: translate(-50%, -50%);
        background-color: #D9D9D9;
    }

    .uploadify-button:before{
        width: 2px;
        height: 39.5px;
    }

    .uploadify-button:after{
        width: 39.5px;
        height: 2px;
    }

    .weui_uploader_file{
        img{
            width: 100%;
            height: 100%;
        }
    }
</style>

<script type="text/javascript">

    wx.config({
        debug: false,
        appId: '{$appId}',
        timestamp: '{$timestamp}',
        nonceStr: '{$nonceStr}',
        signature: '{$signature}',
        jsApiList: [
            'hideOptionMenu'
        ]
    });

    $(function(){

        wx.ready(function(){
            wx.hideOptionMenu();
        });

        // 评分
        $('.star').on('click', function(){
            var rel = $(this).attr('rel');
            $('.star').removeClass('selected');
            $('.star[rel$=' + rel + ']').addClass('selected');
        });

        // 选择图片
        $('.uploadify-button').on('click', function(){
            $('#uploadfile').trigger('click');
        });

        // 压缩图片
        var imgnames = '', paths = '';
        $('#uploadfile').on('change', function(e){
            //单图
//            new html5ImgCompress(e.target.files[0], {
//                before: function(file) {
////                    console.log('单张: 压缩前...');
//                        $.showLoading('图片加载中…');
//                },
//                done: function (file, base64) {
//                    if(base64){
//                        if (imgnames.indexOf(file.name) === -1){
//                            insertImg(base64);
//                            imgnames += file.name;
//                        }else{
//                            console.log('已加载了');
//                            $.hideLoading();
//                        }
//                    }
//                },
//                fail: function(file) {
////                    console.log('单张: 压缩失败...');
//                },
//                complate: function(file) {
////                    console.log('单张: 压缩完成...');
//                },
//                notSupport: function(file) {
////                    $.alert('浏览器不支持！');
//                }
//            });

            // 多图
            var
                    i = 0,
                    files = e.target.files,
                    len = files.length,
                    notSupport = false;
            // 循环多张图片，需要for循环和notSupport变量支持（检测）
            for (; i < len; i++) {
                if (!notSupport) {
                    (function(i) {
                        new html5ImgCompress(files[i], {
                            before: function(file) {
                                $.showLoading('图片加载中…');
                            },
                            done: function (file, base64) { // 这里是异步回调，done中i的顺序不能保证
                                var imgdata = $('#imgdata').val();
                                if(base64){
                                    if (imgdata.indexOf(base64) === -1){
                                        insertImg(base64);
                                    }else{
                                        console.log('已加载了');
                                        $.hideLoading();
                                    }
                                }
                            },
                            fail: function(file) {
//                                console.log('多张: ' + i + ' 压缩失败...');
                            },
                            complate: function(file) {
//                                console.log('多张: ' + i + ' 压缩完成...');
                            },
                            notSupport: function(file) {
                                notSupport = true;
                                $.alert('浏览器不支持！');
                            }
                        });
                    })(i);
                }
            }
        });

        /**
         * 提交评论
         */
        $('.comment').on('click', function(){
            var starnums = $('.star.selected:last').attr('num');
            var content = $.trim($('textarea[name="commentinfo"]').val());
            var imgdata = $('#imgdata').val();
            var orderid = $('#orderid').val();
            var goodsid = $('#goodsid').val();

            $.post('/order/comment_goods', { starnums:starnums, content:content, imgdata:imgdata, orderid:orderid, goodsid:goodsid}, function(jd){
                if(jd.success){
                    $.modal({
                        title: "提示",
                        text: "提交成功，感谢您的评价！",
                        buttons: [
                            { text: "确定", onClick: function(){
                                location.href = '/order/comment_list/{$orderid}';
                            }}
                        ]
                    });
                }else{
                    $.alert(jd.msg);
                }
            }, 'json');

        });

    });

    // html中插入图片
    function insertImg(file) {
        var  img = new Image();
        img.src = file;
        img.onload = function() {
            $('.weui_uploader_files').append('<li class="weui_uploader_file"></li>');
            $('.weui_uploader_files .weui_uploader_file').last().append(img);
            $.hideLoading();
        };

        var imgdata = $('#imgdata').val();
        if(imgdata == ''){
            imgdata = file;
        }else{
            imgdata += '#' + file;
        }
        $('#imgdata').val(imgdata);
    };
</script>

</head>

<body ontouchstart>

<input id="orderid" type="hidden" value="{$orderid}">
<input id="goodsid" type="hidden" value="{$goodsid}">

<div class="weui_tab">
    <div style="background-color: #4c4c4c;text-align: center;color: #fff;display: block;position: relative;font-size: 16px;line-height: 48px;">
        <a href="javascript:history.go(-1);" style="position: absolute;left: 15px;"><img src="/images/wechat/back.png" style="width: 24px;height: 24px;margin-top: 12px;"></a>评价商品
    </div>

    <div class="weui_tab_bd" style="padding-bottom: 100px;padding-top: 0;">
        <div class="weui_panel weui_panel_access" style="margin-top: 15px;">
            <div class="weui_panel_bd" style="border-bottom: #ccc solid 1px;">
                <div class="weui_media_box weui_media_appmsg">
                    <div class="weui_media_hd">
                        <img class="weui_media_appmsg_thumb" src="{imageurl pic = $goods->imgurl size = '80x80'}" alt="">
                    </div>
                    <div class="weui_media_bd">
                        <h4 class="weui_media_title">评分</h4>
                        <a class="star selected" href="javascript:;" rel="11111" num="1"></a>
                        <a class="star selected" href="javascript:;" rel="1111" num="2"></a>
                        <a class="star selected" href="javascript:;" rel="111" num="3"></a>
                        <a class="star selected" href="javascript:;" rel="11" num="4"></a>
                        <a class="star selected" href="javascript:;" rel="1" num="5"></a>
                    </div>
                </div>
            </div>
        </div>

        <div class="weui_cells weui_cells_form">
            <div class="weui_cell">
                <div class="weui_cell_bd weui_cell_primary">
                    <textarea class="weui_textarea" name="commentinfo" placeholder="请输入评论" rows="3"></textarea>
                </div>
            </div>
            {*<div class="weui_cell">*}
                {*<div class="weui_cell_bd weui_cell_primary">*}
                    {*<div class="weui_uploader">*}
                        {*<div class="weui_uploader_hd weui_cell">*}
                            {*<div class="weui_cell_bd weui_cell_primary">图片上传</div>*}
                        {*</div>*}
                        {*<div class="weui_uploader_bd">*}
                            {*<ul class="weui_uploader_files">*}
                                {*上传完成的图片list*}
                            {*</ul>*}
                            {*<div style="display: inline-block;">*}
                                {*<div id="upload">*}
                                    {*<input id="uploadfile" type="file" style="display: none;"/>*}
                                    {*<input id="uploadfile" type="file" multiple="multiple" style="display: none;"/>*}
                                    {*<input id="imgdata" type="hidden" value="">*}
                                    {*<a class="uploadify-button" href="javascript:void(0)" id="file_upload_1-button"></a>*}
                                {*</div>*}
                            {*</div>*}
                        {*</div>*}
                    {*</div>*}
                {*</div>*}
            {*</div>*}
        </div>

        <div style="padding: 15px;margin-top: 15px;">
            <a href="javascript:;" class="weui_btn weui_btn_primary comment" style="background-color:#fff;border: #e60111 solid 1px;color: #e60111;">提交评论</a>
        </div>
    </div>
    {$page = 'order'}
    {include file="footer.tpl"}
</div>
</body>
</html>