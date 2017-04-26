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
<title>{$goods->name}</title>

<link rel="stylesheet" type="text/css" href="/kit/weui/css/base.css" />
<link rel="stylesheet" type="text/css" href="/kit/weui/css/weui.min.css" />
<link rel="stylesheet" type="text/css" href="/kit/weui/css/jquery-weui.min.css" />

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

    .colors{
        padding:0 20px 10px 20px;
        margin-top:5px;
        a{
            display: inline-block;
            width: 46px;
            height: 46px;
            border:#ccc solid 2px;
            margin-right:5px;
            margin-top:10px;
            &.selected{
                 border:#e7001e solid 2px;
             }
            &.disabled{
                 color: #ddd;
                 cursor: not-allowed;
             }
        }
    }

    .sizes{
        padding:0 20px 10px 20px;
        a{
            display: inline-block;
            width: 46px;
            height: 46px;
            margin-right:5px;
            margin-top:10px;
            font-size:14px;
            line-height:46px;
            text-align:center;
            color:#333;
            background-color: #FFF;
            border: #ccc solid 2px;
            &.selected{
                 color:#FFF;
                 background-color:#e70120;
                 border: #e70120 solid 2px;
             }
            &.disabled{
                 color: #ddd;
                 background-color: #FFF;
                 border: #ccc solid 2px;
                 cursor: not-allowed;
             }
        }
    }

    .nums{
        display: inline-block;
        padding:5px 0;
        vertical-align: middle;
        a{
            display: inline-block;
            width: 30px;
            height: 30px;
            border:#d0d0d0 solid 1px;
            &.minus{
                 background:url(/images/www/minus.png) no-repeat 9px 14px;
             }
            &.add{
                 background:url(/images/www/add.png) no-repeat 9px 9px;
             }
            &:hover{
                 border:#f65857 solid 1px;
                &.minus{
                     background:url(/images/www/minus_hover.png) no-repeat 9px 14px #f65857;
                 }
                &.add{
                     background:url(/images/www/add_hover.png) no-repeat 9px 9px #f65857;
                 }
            }
        }
        .num{
            display: inline-block;
            width: 60px;
            height: 30px;
            border: none;
            border-top:#d0d0d0 solid 1px;
            border-bottom:#d0d0d0 solid 1px;
            text-align: center;
            vertical-align: top;
            font-size: 16px;
            line-height: 30px;
        }

        .store{
            display: inline-block;
            font-size: 14px;
            line-height: 30px;
            margin-left: 10px;
            vertical-align:top;
            .storenum{
                padding: 0 2px;
            }
        }
    }

    .goodsinfo{
        width: 100%;
        margin-top:20px;
        img{
            width: 100%;
        }
    }

    .footerdiv{
        width: 100%;
        height: 50px;
        background-color: #FFF;
        border-top: 1px solid #d9dad9;
        position: fixed;
        left: 0px;
        bottom: 0px;
        z-index: 9;
        a{
            display: inline-block;
            height: 50px;
            font-size: 14px;
            line-height: 50px;
            vertical-align: top;
            text-align: center;
            &.favor{
                width: 15%;
                margin-left: 2%;
             }
            &.favored{
                 width: 15%;
                 margin-left: 2%;
             }
            &.tocart{
                 width: 40%;
                 color: #FFF;
                 background-color: #f39900;
                 /*margin-left: 5%;*/
             }
            &.tobuy{
                 width: 40%;
                 color: #FFF;
                 background-color: #e80212;
                 /*margin-left: 4%;*/
             }

            &.cart{
                 width: 20%;
                 /*margin-left: 5%;*/
                 /*margin-right:2%;*/
                 position:relative;
                 margin-top:4px;
                .cart_nums{
                    position: absolute;
                    top:-5px;
                    right: 5px;
                    width: 20px;
                    height: 20px;
                    font-size: 12px;
                    line-height: 20px;
                    border-radius: 10px;
                    background-color: #e80212;
                    color: #fff;
                }
             }
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
            'onMenuShareAppMessage','onMenuShareTimeline'
        ]
    });

    /**
     * 返回图片的完整路径
     * add by lisheng
     * @param imgurl 相对路径
     * @param size 大小尺寸
     * @returns { string} 返回完整路径
     */
    function getFullImgurl(imgurl,size){
        var resourceurl = $('#resourceurl').val();
        var ext = imgurl.split('.')[1];
        return resourceurl + imgurl + '_' + size + '.' + ext;
    }

    $(function(){

        wx.ready(function(){

            //分享给朋友
            wx.onMenuShareAppMessage({
                title: '{$goods->name}，请多关注分享，小动作，大收益', // 分享标题
                desc: 'Alive! Your Energy 自由无界限', // 分享描述
                link: 'https://open.weixin.qq.com/connect/oauth2/authorize?appid={$appId}&redirect_uri=http://wechat.a-ye.cn/goods/{$goods->id}?openid={$openid}&response_type=code&scope=snsapi_userinfo&state=STATE#wechat_redirect', // 分享链接
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
                title: '{$goods->name}，请多关注分享，小动作，大收益', // 分享标题
                desc: 'Alive! Your Energy 自由无界限', // 分享描述
                link: 'https://open.weixin.qq.com/connect/oauth2/authorize?appid={$appId}&redirect_uri=http://wechat.a-ye.cn/goods/{$goods->id}?openid={$openid}&response_type=code&scope=snsapi_userinfo&state=STATE#wechat_redirect', // 分享链接
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

        var myswiper = new Swiper('.swiper-container', {
            loop: true,
            autoplay: 3000,
            pagination : '.swiper-pagination'
        });

        /**
         * 颜色切换
         */
        $('.colors a').on('click', function(){
            var colorspecid = $(this).attr('specid');
            var goodsid = $(this).attr('goodsid');
            var objthis = $(this);
            $.post('/goods/change_color',{ goodsid:goodsid, colorspecid:colorspecid},function(jd){
                if (jd.success){
                    var imgs = jd.data.imgs;
                    //改变上面的显示图片
                    var imgarray = [];
                    for(var i = 0; i < imgs.length; i++){
                        imgarray[i] = '<div class="swiper-slide"><img src="' + getFullImgurl(imgs[i],"640x640") + '" alt="商品图片"/></div>';
                    }
                    myswiper.removeAllSlides(); //移除全部
                    myswiper.appendSlide(imgarray);

                    //根据是否有存货 初始化尺码是否可选
                    $('.sizes a').removeClass('selected').addClass('disabled');
                    var sizes = jd.data.sizes;
                    for(var j = 0; j < sizes.length; j++){
                        $('.sizes a[specid = "' + sizes[j].id + '"]').removeClass('disabled').attr('stocknum', sizes[j].stocknum).attr('sellprice', sizes[j].sellprice);
                    }

                    objthis.addClass('selected').siblings().removeClass('selected');
                    $('.spec_selected').html($('.colors a.selected').attr('title')+'&nbsp;&nbsp;未选尺码');
                    $('.store').hide();
                }
            },'json');
        });

        /**
         * 尺码切换
         */
        $('.sizes a').on('click',function(){
            if($(this).hasClass('disabled')){
                return;
            }

            var stocknum = $(this).attr('stocknum');
            $('.storenum').html(stocknum);
            $('.store').css('display','inline-block');
            $(this).addClass('selected').siblings().removeClass('selected');

            var sellprice = $(this).attr('sellprice');
            $('.sellprice').html('￥' + sellprice);

            $('.spec_selected').html($('.colors a.selected').attr('title')+'&nbsp;&nbsp;'+$(this).html());

            $('.close-popup').trigger('click');
        });

        /**
         * 数量减少
         */
        $('.minus').on('click', function () {
            var num = parseInt($('.num').val());
            if(num > 1){
                $('.num').val(num-1);
            }
        }) ;

        /**
         * 数量增加
         */
        $('.add').on('click', function () {
            var num = parseInt($('.num').val());
            if(num < 100){
                $('.num').val(num + 1);
            }
        }) ;


        // 立即购买
        $('.tobuy').on('click', function(){
            var goodsid = $(this).attr('goodsid');
            var specid1 = $('.colors a.selected').attr('specid');
            var specname1 = $('.colors a.selected').attr('title');
            var specpic = $('.colors a.selected').attr('imgurl');

            if($('.sizes a.selected').length == 0){
                $.alert("请选择商品尺码！", "提醒");
                return;
            }

            var specid2 = $('.sizes a.selected').attr('specid');
            var specname2 = $('.sizes a.selected').attr('specname');
            var buynum = $('.num').val();

            $.post('/goods/buy_now', { goodsid:goodsid, specid1:specid1, specname1:specname1, specid2:specid2, specname2:specname2, specpic:specpic, buynum:buynum}, function(jd){
                {redirecturl url='home/signin'}
                if(jd.success){
                    location.href = '/order/confirm';
                }else{
                    $.alert(jd.msg, "提醒");
                }
            }, 'json');
        });


        // 加入购物车
        $('.tocart').on('click', function(){

            var goodsid = $(this).attr('goodsid');
            var specid1 = $('.colors a.selected').attr('specid');
            var specname1 = $('.colors a.selected').attr('title');
            var specpic = $('.colors a.selected').attr('imgurl');

            if($('.sizes a.selected').length == 0){
                $.alert("请选择商品尺码！", "提醒");
                return;
            }

            var specid2 = $('.sizes a.selected').attr('specid');
            var specname2 = $('.sizes a.selected').attr('specname');
            var buynum = $('.num').val();

            $.post('/goods/add_goods_to_basket', { goodsid:goodsid, specid1:specid1, specname1:specname1, specid2:specid2, specname2:specname2, specpic:specpic, buynum:buynum}, function(jd){
                {redirecturl url='home/signin'}
                if(jd.success){
                    $.toast("加入购物车成功");
                    var cart_nums = parseInt($('.cart_nums').html());
                    cart_nums = cart_nums + 1;
                    $('.cart_nums').html(cart_nums);
                }else{
                    $.alert(jd.msg, "提醒");
                }
            }, 'json');
        });

    });
</script>

</head>

<body ontouchstart>

<input id="resourceurl" type="hidden" value="{$resource_url}"/>

<div class="weui_tab">

    <div style="background-color: #4c4c4c;text-align: center;color: #fff;display: block;position: relative;font-size: 16px;line-height: 48px;">
        <a href="javascript:history.go(-1);" style="position: absolute;left: 15px;"><img src="/images/wechat/back.png" style="width: 24px;height: 24px;margin-top: 12px;"></a>商品详情
    </div>

    <div class="weui_tab_bd" style="padding-bottom: 100px;">
        <div class="swiper-container">
            <!-- Additional required wrapper -->
            <div class="swiper-wrapper ">
                <!-- Slides -->
                {foreach from = $defaultimgs item="item"}
                    <div class="swiper-slide"><img src="{imageurl pic = $item size = '640x640'}" alt="商品图片" /></div>
                {/foreach}
            </div>
            <!-- If we need pagination -->
            <div class="swiper-pagination"></div>
        </div>

        <div class="weui_cells weui_cells_access">
            <div class="weui_cell">
                <div class="weui_cell_bd weui_cell_primary">
                    <p class="sellprice" style="color:#f39900;font-size: 20px;">￥{$goods->sellprice}</p>
                </div>
            </div>
            <a class="weui_cell" href="/goods/info/{$goods->id}?tab=info">
                <div class="weui_cell_bd weui_cell_primary">
                    <p>{$goods->name}</p>
                </div>
                <div class="weui_cell_ft">
                </div>
            </a>
        </div>

        <div class="weui_cells weui_cells_access">
            <a class="weui_cell open-popup" href="javascript:;"  data-target="#spec_popup">
                <div class="weui_cell_bd weui_cell_primary">
                    <p>规格：<span class="spec_selected">{$goods->defaultcolorname} &nbsp;&nbsp;{$goods->defaultsizename}</span></p>
                </div>
                <div class="weui_cell_ft">
                </div>
            </a>
        </div>

        <div class="weui_cells">
            <div class="weui_cell">
                <div class="weui_cell_bd weui_cell_primary">
                    <div style="display: inline-block;vertical-align: middle;">数量：</div>
                    <div class="nums">
                        <a class="minus" href="javascript:void(0);"></a><input type="text" class="num" value="1" maxlength="3" onkeyup="value == '' ? '' : parseInt(value) == 0 ? value = 1 : value = value.replace(/[^\d]/g,'')" onblur="parseInt(value) == 0 || value == '' ? value = 1 : value = value.replace(/[^\d]/g,'')"/><a class="add" href="javascript:void(0);"></a>
                        <span class="store">库存<label class="storenum">{if isset($goods->default_size_stock)}{$goods->default_size_stock} {else}0{/if}</label>件</span>
                    </div>
                </div>
            </div>
        </div>

        <div class="weui_cells weui_cells_access">
            <a class="weui_cell" href="/goods/info/{$goods->id}?tab=info">
                <div class="weui_cell_bd weui_cell_primary">
                    <p>商品介绍</p>
                </div>
                <div class="weui_cell_ft">
                </div>
            </a>
            <a class="weui_cell" href="/goods/info/{$goods->id}?tab=addr">
                <div class="weui_cell_bd weui_cell_primary">
                    <p>规格参数</p>
                </div>
                <div class="weui_cell_ft">
                </div>
            </a>
            <a class="weui_cell" href="/goods/info/{$goods->id}?tab=comment">
                <div class="weui_cell_bd weui_cell_primary">
                    <p>商品评价(<span style="color: red;">{$commentnums}</span>)</p>
                </div>
                <div class="weui_cell_ft">
                </div>
            </a>
        </div>
    </div>

    {*<a href="javascript:;" class="favor" goodsid="{$goods->id}"><img src="/images/wechat/favor.png" width="54" height="42"></a>*}

    <div class="footerdiv"><a href="/cart" class="cart" goodsid="{$goods->id}"><img src="/images/wechat/cart.png" width="54" height="42"><span class="cart_nums">{$cart_nums}</span></a><a href="javascript:;" class="tocart" goodsid="{$goods->id}">加入购物车</a><a href="javascript:;" class="tobuy" goodsid="{$goods->id}">立即购买</a></div>
</div>

<div id="spec_popup" class='weui-popup-container popup-bottom' style="background-color: rgba(0,0,0,0.5);">
    <div class="weui-popup-modal">
        <div class="toolbar">
            <div class="toolbar-inner">
                <a href="javascript:;" class="picker-button close-popup">完成</a>
                <h1 class="title">请选择颜色分类，尺码</h1>
            </div>
        </div>
        <div class="modal-content">
            <div class="weui_panel weui_panel_access">
                <div class="weui_panel_bd">
                    <a href="javascript:void(0);" class="weui_media_box weui_media_appmsg" style="cursor: default;">
                        <div class="weui_media_hd">
                            <img class="weui_media_appmsg_thumb" src="{imageurl pic = $goods->defaultimgurl size = '80x80'}" alt="">
                        </div>
                        <div class="weui_media_bd">
                            <p class="weui_media_desc" style="color: #333;line-height: 20px;">{$goods->name}</p>
                            <h4 class="weui_media_title" style="color:#f39900;">￥{$goods->sellprice}</h4>
                        </div>
                    </a>
                </div>
            </div>


            <div class="weui_panel weui_panel_access">
                <div class="weui_panel_bd">
                    <div class="weui_media_box weui_media_text">
                        {*商品颜色*}
                        <h4 class="weui_media_title">颜色</h4>
                        <div class="colors">
                            {foreach from = $colors item="color"}
                                <a {if $color->id eq $goods->defaultcolorid}class="selected"{/if} href="javascript:void(0);" specid = {$color->id} title="{$color->name}" imgurl="{$color->imgurl}" goodsid="{$goods->id}">
                                    <img src="{imageurl pic = $color->imgurl size = '46x46'}" width="46" height="46" alt=""/>
                                </a>
                            {/foreach}
                        </div>
                        {*商品尺码*}
                        <h4 class="weui_media_title">尺码</h4>
                        <div class="sizes">
                            {foreach from = $sizes item="size"}
                                <a class="{if $size->havestock}{if $size->id eq $goods->defaultsizeid}selected {/if}{else}disabled{/if}" href="javascript:void(0);" specid = {$size->id} specname="{$size->name}" stocknum="{$size->stocknum}" sellprice="{$size->sellprice}">
                                    {$size->name}
                                </a>
                            {/foreach}
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
</body>
</html>