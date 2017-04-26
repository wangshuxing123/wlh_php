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
<title>商品详情</title>

<link rel="stylesheet" type="text/css" href="/kit/weui/css/base.css" />
<link rel="stylesheet" type="text/css" href="/kit/weui/css/weui.min.css" />
<link rel="stylesheet" type="text/css" href="/kit/weui/css/jquery-weui.min.css" />

<script type="text/javascript" src="/kit/jquery/jquery.min.js"></script>
<script type="text/javascript" src="/kit/weui/js/jquery-weui.min.js"></script>
<script type="text/javascript" src="/kit/weui/js/swiper.min.js"></script>

<style type="text/less">

    .goodsinfo{
        width: 100%;
        margin-top:20px;
        background-color:#fff;
        img{
            width: 100%;
        }
    }

</style>

<script type="text/javascript">
    $(function(){
       $('.weui_navbar_item').on('click', function(){
          $(this).addClass('weui_bar_item_on').siblings().removeClass('weui_bar_item_on');
           var tab = $(this).attr('tab');
           if(tab == 'info'){
               $('.goodsinfo').show();
               $('.goodsaddr').hide();
               $('.goodscomment').hide();
           }else if(tab == 'addr') {
               $('.goodsinfo').hide();
               $('.goodsaddr').show();
               $('.goodscomment').hide();
           }else if(tab == 'comment') {
               $('.goodsinfo').hide();
               $('.goodsaddr').hide();
               $('.goodscomment').show();
           }
       });

       $('.weui-infinite-scroll').on('click', function(){
           $('.infinite-preloader').show();

           var goodsid = $('#goodsid').val();
           var commentid = $('.comment:last').attr('commentid');
           $.post('/goods/get_more_comments', { goodsid:goodsid,commentid:commentid}, function(jd){
                if(jd.success){
                    var strHtml = '';
                    for(var i = 0; i < jd.data.length; i++){
                        strHtml += '<div class="weui_panel comment" style="margin-top: 10px;" commentid="'+jd.data[i].id+'">';
                        strHtml += '<div class="weui_panel_bd">';
                        strHtml += '<div class="weui_media_box weui_media_text">';
                        strHtml += '<h4 class="weui_media_title">';
                        strHtml += '<img src="'+jd.data[i].avatar+'" width="30" height="30" style="border-radius: 15px;vertical-align: middle;"> <span style="vertical-align: middle;">';
                        if(jd.data[i].isanonymous == '1'){
                            strHtml += '匿名用户';
                        }else{
                            strHtml += jd.data[i].name + '</span>';
                        }

                        strHtml += '<span class="fr">';
                        var starnums = parseInt(jd.data[i].starnums);
                        for(var j = 0; j<starnums; j++){
                            strHtml += '<img src="/images/wechat/comment_star_selected.png">';
                        }
                        for(var m = 0; m<5-starnums; m++){
                            strHtml += '<img src="/images/wechat/comment_star.png">';
                        }
                        strHtml += '</span></h4>';
                        strHtml += '<p class="weui_media_desc">' + jd.data[i].content+'</p>';
                        strHtml += '<ul class="weui_media_info">';
                        strHtml += '<li class="weui_media_info_meta" style="float: right;">'+jd.data[i].cts+'</li>';
                        strHtml += '</ul></div></div></div>'
                    }
                    $('.comment:last').after(strHtml);
                    $('.infinite-preloader').hide();
                }else{
                    $('.weui-infinite-scroll').remove();
                    $.toast('没有更多的评论了');
                }
           }, 'json');

       });

    });
</script>

</head>

<body ontouchstart>
<input id="goodsid" type="hidden" value="{$goodsid}">
<div class="weui_tab">

    <div style="background-color: #4c4c4c;text-align: center;color: #fff;display: block;position: relative;font-size: 16px;line-height: 48px;">
        <a href="javascript:history.go(-1);" style="position: absolute;left: 15px;"><img src="/images/wechat/back.png" style="width: 24px;height: 24px;margin-top: 12px;"></a>商品详情
    </div>

    <div class="weui_navbar" style="margin-top: 48px;">
        <div class="weui_navbar_item {if $tab eq 'info' || $tab eq ''}weui_bar_item_on{/if}" tab="info">
            商品介绍
        </div>
        <div class="weui_navbar_item {if $tab eq 'addr'}weui_bar_item_on{/if}" tab="addr">
            规格参数
        </div>
        <div class="weui_navbar_item {if $tab eq 'comment'}weui_bar_item_on{/if}" tab="comment">
            商品评价
        </div>
    </div>
    <div class="weui_tab_bd" style="padding-bottom: 50px;">
        <div class="goodsinfo" {if $tab neq 'info' && $tab neq ''}style="display: none;"{/if}>
            {$goods->content}
        </div>

        <div class="goodsaddr" {if $tab neq 'addr'}style="display: none;"{/if}>
            <div style="margin: 15px;line-height: 36px;border: #ccc solid 1px;">
                {foreach from = $attrs item="item"}
                    <div style="border-bottom: #ccc solid 1px;">
                        <div style="display: inline-block; width: 30%;padding-left: 10px;vertical-align: top;">
                            {$item->attrname}
                        </div><div style="display: inline-block;width: 60%;border-left: #ccc solid 1px;padding-left: 10px;">
                            {$item->attrvalue}
                        </div>
                    </div>

                    {*<p>{$item->attrname}:{$item->attrvalue}</p>*}
                {/foreach}
            </div>

        </div>

        <div class="goodscomment" {if $tab neq 'comment'}style="display: none;"{/if}>

            {foreach from = $commentlist item="item"}
                <div class="weui_panel comment" style="margin-top: 10px;" commentid="{$item->id}">
                    <div class="weui_panel_bd">
                        <div class="weui_media_box weui_media_text">
                            <h4 class="weui_media_title">
                                <img src="{$item->avatar}" width="30" height="30" style="border-radius: 15px;vertical-align: middle;"> <span style="vertical-align: middle;">{if $item->isanonymous eq '1'}匿名用户{else}{$item->name}{/if}</span>
                                <span class="fr">
                                    <img src="/images/wechat/comment_star_selected.png">
                                    {if $item->starnums gte 2}
                                    <img src="/images/wechat/comment_star_selected.png">
                                    {else}
                                        <img src="/images/wechat/comment_star.png">
                                    {/if}

                                    {if $item->starnums gte 3}
                                        <img src="/images/wechat/comment_star_selected.png">
                                    {else}
                                        <img src="/images/wechat/comment_star.png">
                                    {/if}

                                    {if $item->starnums gte 4}
                                        <img src="/images/wechat/comment_star_selected.png">
                                    {else}
                                        <img src="/images/wechat/comment_star.png">
                                    {/if}

                                    {if $item->starnums eq 5}
                                        <img src="/images/wechat/comment_star_selected.png">
                                    {else}
                                        <img src="/images/wechat/comment_star.png">
                                    {/if}

                                </span>
                            </h4>
                            <p class="weui_media_desc">{$item->content}</p>
                            <ul class="weui_media_info">
                                <li class="weui_media_info_meta" style="float: right;">{$item->cts}</li>
                            </ul>
                        </div>
                    </div>
                </div>
            {/foreach}

            {if !empty($commentlist)}
                <div class="weui-infinite-scroll">
                    <div class="infinite-preloader" style="display: none;"></div>
                    点击加载更多
                </div>
            {else}
                <div style="margin-top: 20px;width: 100%;text-align: center;line-height: 50px;color:#666;">目前还没有评价！</div>
            {/if}
        </div>
    </div>
</div>

</body>
</html>