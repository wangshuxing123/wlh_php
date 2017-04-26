<!DOCTYPE html>
<html lang="en">
<meta charset="UTF-8">
<meta content="yes" name="apple-mobile-web-app-capable"/>
<meta content="yes" name="apple-touch-fullscreen"/>
<meta content="telephone=no" name="format-detection"/>
<meta content="black" name="apple-mobile-web-app-status-bar-style">
<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
<meta name="viewport" content="width=device-width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=no">
<title>AYE阿野</title>

<link rel="stylesheet" type="text/css" href="/kit/weui/css/base.css" />
<link rel="stylesheet" type="text/css" href="/kit/weui/css/weui.min.css" />
<link rel="stylesheet" type="text/css" href="/kit/weui/css/jquery-weui.min.css" />


<link rel="stylesheet" type="text/css" href="/kit/jquery_nav/css/normalize.css" />
<link href='/kit/jquery_nav/css/fonts.css' rel='stylesheet' type='text/css'>
<link href="/kit/jquery_nav/css/main.css" rel="stylesheet" type="text/css"/>

<script type="text/javascript" src="/kit/jquery/jquery.min.js"></script>
<script type="text/javascript" src="/kit/weui/js/jquery-weui.min.js"></script>
<script type="text/javascript" src="/kit/weui/js/swiper.min.js"></script>

<script type="text/javascript" src="http://res.wx.qq.com/open/js/jweixin-1.0.0.js"></script>

<style type="text/less">

    .swiper-container {
        width: 100%;
        img{
            display: block;
            width: 100%;
        }
    }

    .goodslist{
        padding: 5px 0;
        .goods{
            float: left;margin: 10px 1% 0 1%;width: 48%;background-color: #fff;
            .g_name{
                color: #333;font-size: 14px;overflow: hidden;text-overflow: ellipsis;white-space: nowrap;
            }
            .g_price{
                color: #f49a00;font-size: 18px;font-weight: bold;
            }
            .hot{
                position: absolute;
                left: 0;
                top:0;
                width: 40px;
            }
            .yushou{
                position: absolute;
                right: 10px;
                bottom:10px;
                width: 50px;
            }

        }
    }

</style>

<script type="text/javascript">

    wx.config({
        debug: false,
        appId: '{if isset($appId)}{$appId}{/if}',
        timestamp: '{if isset($timestamp)}{$timestamp}{/if}',
        nonceStr: '{if isset($nonceStr)}{$nonceStr}{/if}',
        signature: '{if isset($signature)}{$signature}{/if}',
        jsApiList: [
            'onMenuShareAppMessage','onMenuShareTimeline'
        ]
    });

    $(function(){

        $(".swiper-container").swiper({
            loop: true,
            autoplay: 3000
        });

        $(".mobile-inner-header-icon").click(function(){
            $(this).toggleClass("mobile-inner-header-icon-click mobile-inner-header-icon-out");
            $(".mobile-inner-nav").slideToggle(250);
        });
        $(".mobile-inner-nav a").each(function( index ) {
            $( this ).css({ 'animation-delay': (index/10)+'s'});
        });

        wx.ready(function(){

            //分享给朋友
            wx.onMenuShareAppMessage({
                title: 'AYE阿野微信官方商城', // 分享标题
                desc: '{if !empty($nickname)}我是{$nickname}，{/if}我为阿野代言。动动手指，坐享20%收益。', // 分享描述
                link: 'https://open.weixin.qq.com/connect/oauth2/authorize?appid={$appId}&redirect_uri=http://wechat.a-ye.cn?openid={$openid}&response_type=code&scope=snsapi_userinfo&state=STATE#wechat_redirect', // 分享链接
                imgUrl: 'http://wechat.a-ye.cn/images/wechat/sign_top_logo.png', // 分享图标
                type: 'link', // 分享类型,music、video或link，不填默认为link
                dataUrl: '', // 如果type是music或video，则要提供数据链接，默认为空
                success: function () {
                    // 用户确认分享后执行的回调函数
                    $.toast('分享成功！');
                },
                cancel: function () {
                    // 用户取消分享后执行的回调函数
                    $.toast('取消分享！');
                }
            });
            //分享给朋友圈
            wx.onMenuShareTimeline({
                title: 'AYE阿野微信官方商城', // 分享标题
                desc: '{if !empty($nickname)}我是{$nickname}，{/if}我为阿野代言。动动手指，坐享20%收益。', // 分享描述
                link: 'https://open.weixin.qq.com/connect/oauth2/authorize?appid={$appId}&redirect_uri=http://wechat.a-ye.cn?openid={$openid}&response_type=code&scope=snsapi_userinfo&state=STATE#wechat_redirect', // 分享链接
                imgUrl: 'http://wechat.a-ye.cn/images/wechat/sign_top_logo.png', // 分享图标
                success: function () {
                    // 用户确认分享后执行的回调函数
                    $.toast('分享成功！');
                },
                cancel: function () {
                    // 用户取消分享后执行的回调函数
                    $.toast('取消分享！');
                }
            });
        });

//        $.alert('感谢您的关注，现在我们正在进行内网测试，请不要购买，谢谢！');
    });
</script>

</head>

<body ontouchstart style="background-color: #f8f8f8;">
{*<a href="/home/logout">退出登录</a>*}
<div class="weui_tab">

    <div class="weui_navbar">

        <div class="mobile-inner">
            <div class="mobile-inner-header">
                <a href="javascript:;" style="position: absolute;left: 15px;"><img src="/images/logo.png" style="width: 80px;margin-top: 10px;"></a>
                AYE阿野
                {*<div class="mobile-inner-header-icon mobile-inner-header-icon-out"><span></span><span></span></div>*}
            </div>
            {*<div class="mobile-inner-nav" style="display: none;">*}
                {*<a href="#" style="animation-delay: 0s;">男士</a>*}
                {*<a href="#" style="animation-delay: 0.1s;">女士</a>*}
                {*<a href="#" style="animation-delay: 0.2s;">跑步</a>*}
                {*<a href="#" style="animation-delay: 0.3s;">滑雪</a>*}
            {*</div>*}
        </div>
    </div>
    <div class="weui_tab_bd" style="padding-bottom: 100px;">
        <div class="swiper-container">
            <!-- Additional required wrapper -->
            <div class="swiper-wrapper">
                <!-- Slides -->
                <div class="swiper-slide"><a href="http://mp.weixin.qq.com/s?__biz=MzI3NTIyMDExMA==&mid=100000216&idx=1&sn=589b270014b5c6f1655943c80098efbd&chksm=6b0952395c7edb2f099b36484ad81b2c98c6cd3bd482f4b09067dd261f69319988a45092d866&scene=0#wechat_redirect"><img src="/images/wechat/wechat_banner1.jpg?v=1" /></a></div>
                <div class="swiper-slide"><a href="http://mp.weixin.qq.com/s?__biz=MzI3NTIyMDExMA==&mid=100000216&idx=2&sn=040c2f82ce79fdb410ad0dec9ecb38a5&chksm=6b0952395c7edb2fb86359efd4397789c5f72d881ed15430ee5ff8e725876dd7ffd23e55b16c&scene=0#wechat_redirect"><img src="/images/wechat/wechat_banner2.jpg?v=1" /></a></div>
                <div class="swiper-slide"><a href="/goods/397140446104940128"><img src="/images/wechat/wechat_banner3.jpg?v=1" /></a></div>
            </div>
            <!-- If we need pagination -->
            <div class="swiper-pagination"></div>
        </div>

        <div class="goodslist">
            {foreach from=$goods item="item"}
                <div class="goods" onclick="location                      .href='/goods/{$item->goodsid}?colorid={$item->colorid}'">
                    <div style="position: relative;">
                        <img src="http://img.a-ye.cn{$item->cover}" style="width: 100%;min-height: 80px;">
                    </div>
                    <div style="padding: 0 10px;">
                        <div style="border-top:#f8f8f8;">
                            <p class="g_name">{$item->name}</p>
                            <p class="g_price">￥{$item->sellprice}</p>
                        </div>
                    </div>
                </div>
            {/foreach}
        </div>

    </div>

    {$page = 'index'}
    {include file="footer.tpl"}
</div>


</body>
</html>