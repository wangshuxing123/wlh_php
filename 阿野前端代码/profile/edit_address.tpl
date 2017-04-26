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
<title>{if $addressid}修改地址{else}新增地址{/if}</title>

<link rel="stylesheet" type="text/css" href="/kit/weui/css/base.css" />
<link rel="stylesheet" type="text/css" href="/kit/weui/css/weui.min.css" />
<link rel="stylesheet" type="text/css" href="/kit/weui/css/jquery-weui.min.css" />

<script type="text/javascript" src="/kit/jquery/jquery.min.js"></script>
<script type="text/javascript" src="/kit/jquery/jquery.extends.min.js"></script>
<script type="text/javascript" src="/kit/weui/js/jquery-weui.min.js"></script>

<style type="text/less">

</style>

<script type="text/javascript">
    $(function(){
        var modifyflag = false;
        var rmodifyflag = false;
        var currCity = '',currRegion = '';
        var addressid = $('#addressid').val();
        if(addressid != 0){
            $.post('/profile/find_address', { addressid:addressid}, function(jd){
                {redirecturl url='home/signin'}
                if(jd.success){
                    $('input[name="acceptname"]').val(jd.data.acceptname);
                    currCity = jd.data.cityid;
                    currRegion = jd.data.regionid;
                    modifyflag = true;
                    rmodifyflag = true;
                    $('select[name="province"]').val(jd.data.provinceid).trigger('change');
                    $('textarea[name="addr"]').val(jd.data.addr);
                    $('input[name="mobile"]').val(jd.data.mobile);
                    if(jd.data.isdefault == '1'){
                        $('input[name="isdefault"]').attr('checked', 'checked');
                    }
                }
            }, 'json');
        }

        // 保存地址
        var saveflag = false;
        $('.save').on('click', function(){
            if(saveflag){
                return;
            }
            var addressid = $('input[name="addressid"]').val();
            var acceptname = $.trim($('input[name="acceptname"]').val());
            if(acceptname == ''){
                $.alert('请输入收货人姓名！');
                return;
            }

            var regionid = $('select[name="region"]').val();
            if(regionid === ''){
                $.alert('请选择地址区域！');
                return;
            }

            var addr = $.trim($('textarea[name="addr"]').val());
            if(addr == ''){
                $.alert('请输入详细地址信息！');
                return;
            }
            var mobile = $.trim($('input[name="mobile"]').val());
            if(!$.validator(mobile, 'req') ||!$.validator(mobile, 'phone')){
                $.alert('请输入正确格式的11位手机号！');
                return;
            }
            saveflag = true;
            $.post('/profile/save_address', $('#mainForm').serialize(), function(jd){
                {redirecturl url='home/signin'}
                if(jd.success){
                    $.toast('保存成功');
                    var from = $('#from').val();
                    if(from == ''){
                        location.href = '/profile/address';
                    }else{
                        location.href = '/order/confirm';
                    }
                }else{
                    $.alert(jd.msg);
                    saveflag = false;
                }
            }, 'json');

        });


        // 省份变化 加载市
        $('select[name="province"]').on('change', function(){
            var provinceid = $(this).val();
            if(provinceid == ''){
                $('select[name="city"]').html('<option value="" selected>市</option>');
                $('select[name="city"]').trigger('change');
                return;
            }
            $.post('/profile/find_citys_by_province', { provinceid:provinceid}, function(jd){
                {redirecturl url='home/signin'}
                if(jd.success){
                    var strHtml = '';
                    for(var i=0;i<jd.data.length;i++){
                        if(i == 0){
                            strHtml += '<option value="'+ jd.data[i].id+'" selected="selected">'+ jd.data[i].name+'</option>';
                        }else{
                            strHtml += '<option value="'+ jd.data[i].id+'">'+ jd.data[i].name+'</option>';
                        }
                    }
                    $('select[name="city"]').html(strHtml);

                    if(modifyflag && currCity != ''){
                        $('select[name="city"]').val(currCity);
                        modifyflag = false;
                    }

                    $('select[name="city"]').trigger('change');
                }
            }, 'json');
        });
        // 市变化 加载区县
        $('select[name="city"]').on('change', function(){
            var cityid = $(this).val();
            if(cityid == ''){
                $('select[name="region"]').html('<option value="" selected>区县</option>');
                return;
            }
            $.post('/profile/find_regions_by_city', { cityid:cityid}, function(jd){
                {redirecturl url='home/signin'}
                if(jd.success){
                    var strHtml = '';
                    for(var i=0;i<jd.data.length;i++){
                        if(i == 0){
                            strHtml += '<option value="'+ jd.data[i].id+'" selected="selected">'+ jd.data[i].name+'</option>';
                        }else{
                            strHtml += '<option value="'+ jd.data[i].id+'">'+ jd.data[i].name+'</option>';
                        }
                    }
                    $('select[name="region"]').html(strHtml);

                    if(rmodifyflag && currRegion != ''){
                        $('select[name="region"]').val(currRegion);
                        rmodifyflag = false;
                    }
                }
            }, 'json');
        });
    });
</script>

</head>

<body ontouchstart>

<input id="from" type="hidden" value="{$from}">

<div style="background-color: #4c4c4c;text-align: center;color: #fff;display: block;position: relative;font-size: 16px;line-height: 48px;">
    <a href="javascript:history.go(-1);" style="position: absolute;left: 15px;"><img src="/images/wechat/back.png" style="width: 24px;height: 24px;margin-top: 12px;"></a>{if $addressid}修改地址{else}新增地址{/if}
</div>

<form id="mainForm" class="weui_cells weui_cells_form">
    <input id="addressid" name="addressid" type="hidden" value="{$addressid}">
    <div class="weui_cell">
        <div class="weui_cell_hd"><label class="weui_label">收货人</label></div>
        <div class="weui_cell_bd weui_cell_primary">
            <input class="weui_input" name="acceptname" type="text" placeholder="姓名">
        </div>
    </div>
    <div class="weui_cell">
        <div class="weui_cell_hd"><label class="weui_label">手机号码</label></div>
        <div class="weui_cell_bd weui_cell_primary">
            <input class="weui_input" name="mobile" type="tel" placeholder="11位手机号">
        </div>
    </div>

    <div class="weui_cell weui_cell_select">
        <div class="weui_cell_bd weui_cell_primary">
            <select class="weui_select" name="province">
                <option selected="" value="">省/直辖市</option>
                {foreach from=$provincelist item="item"}
                    <option value="{$item->id}">{$item->name}</option>
                {/foreach}
            </select>
        </div>
    </div>

    <div class="weui_cell weui_cell_select">
        <div class="weui_cell_bd weui_cell_primary">
            <select class="weui_select" name="city">
                <option selected="" value="">市</option>
            </select>
        </div>
    </div>

    <div class="weui_cell weui_cell_select">
        <div class="weui_cell_bd weui_cell_primary">
            <select class="weui_select" name="region">
                <option selected="" value="">区县</option>
            </select>
        </div>
    </div>

    <div class="weui_cell">
        <div class="weui_cell_bd weui_cell_primary">
            <textarea class="weui_textarea" name="addr" placeholder="详细地址" rows="2"></textarea>
        </div>
    </div>

    <div class="weui_cell weui_cell_switch">
        <div class="weui_cell_hd weui_cell_primary">默认地址</div>
        <div class="weui_cell_ft">
            <input name="isdefault" class="weui_switch" type="checkbox">
        </div>
    </div>

    <a href="javascript:void(0);" class="save weui_btn weui_btn_primary" style="margin:15px;background-color:#e70111;">保存</a>
</form>


</body>
</html>