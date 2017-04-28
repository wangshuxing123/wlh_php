<?php if ( ! defined('BASEPATH')) exit('No direct script access allowed');

class Order extends CI_Controller
{

    /**
     * 订单详情页
     * @param int $id 订单ID
     */
    public function detail($id = 0)
    {
        $package = wx_get_sign_package();
        $this->smarty->assign('appId', $package['appId']);
        $this->smarty->assign('timestamp', $package['timestamp']);
        $this->smarty->assign('nonceStr', $package['nonceStr']);
        $this->smarty->assign('signature', $package['signature']);

        $query = $this->db->query('SELECT a.id, a.orderno, a.expressid, a.expressno, a.status, b.name AS statusname, c.name AS deliverytime, a.acceptname, a.mobile, CONCAT(e.ancestornames, e.name, a.addr) AS address, a.payableamount, a.discountamount,a.couponamount,a.pointsamount,a.commissionamount, a.realamount, a.payablefreight, a.realfreight, (a.payableamount+a.realfreight) AS totalamount, a.userremark, a.isinvoice, a.invoicetitle,a.cts FROM tb_order AS a LEFT JOIN tb_dict AS b ON a.status=b.id LEFT JOIN tb_dict AS c ON a.deliverytimetp=c.id LEFT JOIN tb_region AS e ON a.regionid=e.id WHERE a.id=?', array($id));
        $order = $query->row();

        $goods = $this->db->query('SELECT a.goodsid, d.name AS goodsname, a.spec, a.productid, a.goodsprice, b.marketprice, a.realprice, a.goodsnums, (a.realprice*a.goodsnums) AS totalmoney, c.imgurl FROM tb_order_goods AS a LEFT JOIN tb_products AS b ON a.productid=b.id LEFT JOIN tb_goods_spec AS c ON b.goodsspecid1=c.id LEFT JOIN tb_goods AS d ON a.goodsid=d.id WHERE a.orderid=?', array($id));
        $order->goods = $goods->result();

        $this->smarty->assign('order', $order);

        $this->smarty->view('order/detail.tpl');
    }

    /**
     * 物流信息
     */
    public function express_info()
    {
        $orderid = intval($this->input->get('orderid'));
        $this->smarty->assign('orderid', $orderid);

        $expressno = $this->input->get('expressno');

        $this->load->library('yto');
        $result = $this->yto->way_bill_trace($expressno);
        $result = json_decode($result);
        if(!empty($result->message))
        {
            $result = array();
        }

        $this->smarty->assign('express_list', $result);

        $this->smarty->view('order/express_list.tpl');
    }


    /**
     * 订单信息确认
     */
    public function confirm()
    {
        $user = $this->bag->get("user");
        $userid = intval($user->id);

        $package = wx_get_sign_package();
        $this->smarty->assign('appId', $package['appId']);
        $this->smarty->assign('timestamp', $package['timestamp']);
        $this->smarty->assign('nonceStr', $package['nonceStr']);
        $this->smarty->assign('signature', $package['signature']);

        $addressid = intval($this->input->get('addressid'));

        $query = $this->db->query('SELECT a.id, a.acceptname, a.mobile, CONCAT(b.ancestornames,"-",b.name," ",a.addr) AS address, a.isdefault FROM tb_address AS a LEFT JOIN tb_region AS b ON a.regionid=b.id WHERE a.userid=? ORDER BY a.isdefault DESC', array($userid));
        $this->smarty->assign('addresslist', $query->result());

        if($addressid != 0)
        {
            $address = $this->db->query('SELECT a.id, a.acceptname, a.mobile, CONCAT(b.ancestornames,"-",b.name," ",a.addr) AS address, a.isdefault FROM tb_address AS a LEFT JOIN tb_region AS b ON a.regionid=b.id WHERE a.userid=? AND a.id=? LIMIT 1', array($userid, $addressid));
            $this->smarty->assign('defaultaddress', $address->row());
        }
        else if($query->num_rows() > 0)
        {
            $default = $this->db->query('SELECT a.id, a.acceptname, a.mobile, CONCAT(b.ancestornames,"-",b.name," ",a.addr) AS address, a.isdefault FROM tb_address AS a LEFT JOIN tb_region AS b ON a.regionid=b.id WHERE a.userid=? AND a.isdefault=1 LIMIT 1', array($userid));
            if($default->num_rows() == 0)
            {
                $default = $this->db->query('SELECT a.id, a.acceptname, a.mobile, CONCAT(b.ancestornames,"-",b.name," ",a.addr) AS address, a.isdefault FROM tb_address AS a LEFT JOIN tb_region AS b ON a.regionid=b.id WHERE a.userid=? LIMIT 1', array($userid));
            }
            $this->smarty->assign('defaultaddress', $default->row());
        }

        $goodslist = json_decode($this->redis->get('order_confirm_goods_'.$userid));
        $this->smarty->assign('goodslist', $goodslist);

        $cartids = json_decode($this->redis->get('order_confirm_cartids_'.$userid));
        $this->smarty->assign('cartids', $cartids);

        $query = $this->db->query('SELECT id,name FROM tb_region WHERE pid=\'001\'');
        $this->smarty->assign('provincelist', $query->result());

        // 优惠券
        $query = $this->db->query('SELECT id,info,lowerlimit,amount,begindate,expiredate FROM tb_user_coupon WHERE userid=? AND expiredate>=CURDATE() AND status = \'024001\'', array($userid));
        $this->smarty->assign('couponlist', $query->result());

        $this->smarty->view('order/confirm.tpl');
    }


    /**
     * 提交订单
     */
    public function submit_order()
    {
        $user = $this->bag->get("user");
        $userid = intval($user->id);

        $addressid = intval($this->input->post('addressid'));
        $deliverytimetp = $this->input->post('deliverytimetp');
        $cartids = $this->input->post('cartids');
        $userremark = $this->input->post('userremark');
        $isinvoice = intval($this->input->post('isinvoice'));
        $invoicetitle = $this->input->post('invoicetitle');

        $payableamount = $this->input->post('payableamount');
        $discountamount = $this->input->post('discountamount');
        $couponids = $this->input->post('couponids');
        $couponamount = $this->input->post('couponamount');
        $commissionbase = $this->input->post('commissionbase');
        $points = intval($this->input->post('points'));
        $pointsamount = $this->input->post('pointsamount');
        $commissionamount = $this->input->post('commissionamount');
        $realamount = $this->input->post('realamount');
        $realfreight = $this->input->post('realfreight');
        $totalamount = $this->input->post('totalamount');

        $tp = '019001';
        $source = '016002';
        $status = $totalamount == '0' ? '008002' : '008001';//如果付款金额为零 直接判断为付款已完成

        $goodslist = json_decode($this->redis->get('order_confirm_goods_'.$userid));
        if(!$goodslist)
        {
            render_failed_json('订单已失效，请重新提交！');
            return;
        }

        $this->db->trans_start();
        $orderid = trxid();
        // 生成16位唯一订单编号
        $orderno = date('Ymd').substr(implode(NULL, array_map('ord', str_split(substr(uniqid(), 7, 13), 1))), 0, 8);

        $address_query = $this->db->query('SELECT acceptname, mobile, regionid, addr FROM tb_address WHERE id=?', array($addressid));
        $address = $address_query->row();

        $this->db->query('INSERT INTO tb_order (id, orderno, userid, status, deliverytimetp, acceptname, mobile, regionid, addr, payableamount, discountamount, couponids, couponamount, commissionbase, points, pointsamount, commissionamount, realamount, realfreight, totalamount, userremark, isinvoice, invoicetitle, tp, source) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)', array($orderid, $orderno, $userid, $status, $deliverytimetp, $address->acceptname, $address->mobile, $address->regionid, $address->addr, $payableamount, $discountamount, $couponids, $couponamount, $commissionbase, $points, $pointsamount, $commissionamount, $realamount, $realfreight, $totalamount, $userremark, $isinvoice, $invoicetitle, $tp, $source));

        foreach($goodslist as $goods)
        {
            $order_goods_id = trxid();
            $specinfo = '颜色：'.$goods->specname1.' ,  尺码：'.$goods->specname2;
            $this->db->query('INSERT INTO tb_order_goods (id, orderid, orderno, goodsid, productid, goodsprice, realprice, goodsnums, goodsweight, iscomment, spec, status) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)', array($order_goods_id, $orderid, $orderno, $goods->goodsid, $goods->productid, $goods->sellprice, $goods->sellprice, $goods->buynum, $goods->totalweight, 0, $specinfo, '020001'));
        }

        // 优惠券失效 优惠券一旦使用就失效 即使退货也不返还
        if($couponids != '')
        {
            $this->db->query('UPDATE tb_user_coupon SET status = \'024002\' WHERE id in ('.$couponids.')');
        }

        $this->load->model('member');
        // 减去佣金 如果发生退货 佣金返还给用户
        if($commissionamount > 0)
        {
            $this->member->minus_commission_log($userid, $orderid, $commissionamount*-1);
        }
        // 减去积分 如果发生退货 积分不返还给用户
        if($points > 0)
        {
            $this->member->add_points_log($userid, '订单积分抵扣', $points*-1, $orderid);
        }

        // 如果是从购物车结算的  将购物车的商品记录删除
        if(!empty($cartids)){
            $this->db->query('DELETE FROM tb_cart WHERE id IN ('.$cartids.')');
        }

        $this->db->trans_complete();
        if($this->db->trans_status())
        {
            render_success_json(strval($orderid));
        }
        else
        {
            render_failed_json('操作失败，请重新提交！');
        }
    }

    /**
     * 订单提交成功 马上付款
     */
    public function online_charge($id = 0)
    {
        $package = wx_get_sign_package();
        $this->smarty->assign('appId', $package['appId']);
        $this->smarty->assign('timestamp', $package['timestamp']);
        $this->smarty->assign('nonceStr', $package['nonceStr']);
        $this->smarty->assign('signature', $package['signature']);

        $query = $this->db->query('SELECT id, orderno, realamount, status FROM tb_order WHERE id=?', array($id));
        $this->smarty->assign('order', $query->row());

        if($query->row()->status != '008001' && $query->row()->status != '008002')
        {
            redirect($this->config->base_url().'order/'.$query->row()->id);
        }

        $query = $this->db->query('SELECT c.name,a.spec FROM tb_order_goods AS a LEFT JOIN tb_warehouse_store AS b ON a.productid=b.productid AND b.warehouseid=1 LEFT JOIN tb_goods AS c ON a.goodsid=c.id WHERE a.orderid = ? AND a.goodsnums > IFNULL(b.stocknum - b.occupynum,0)', array($id));
        $this->smarty->assign('no_stock_goods', $query->result());

        $this->smarty->view('order/online_charge.tpl');
    }


    /**
     * 立即支付
     */
    public function to_pay(){
        $openid = get_cookie('aye_openid');

        $user = $this->bag->get("user");
        $userid= intval($user->id);

        $total_fee = $this->input->post('amount');
        $orderid = $this->input->post('orderid');
        $orderno = $this->input->post('orderno');

//        if(floatval($total_fee) <= 0){
//            $total_fee = 1;
//        }

        if(!empty($userid)){
            // 微信支付
            $body = '微商城下单';
            $notify_url = 'http://wechat.a-ye.cn/entry/wx_pay_success';
            $data = wx_pay($orderid, $orderno, $body, $notify_url, $total_fee, 'JSAPI', $openid);

            render_success_json($data);
        }else{
            $this->smarty->assign('errMsg','登录状态失效，请重新登录！');
            $this->smarty->view('error.tpl');
        }
    }

    /**
     * 取消订单
     */
    public function cancel_order(){
        $orderid = intval($this->input->post('orderid'));

        $query = $this->db->query('SELECT userid,orderno,couponids,points,commissionamount,realamount,status FROM tb_order WHERE id=?', array($orderid));
        $order = $query->row();
        $status = $order->status;
        if ($status != '008001' &&  $status != '008002' && $status != '008003')
        {
            render_failed_json('该订单状态已改变，无法取消！');
            return false;
        }

        $this->db->trans_start();

        // 如果订单已经发送给WMS，调用接口给WMS发送取消订单指令，取消发货
        if($status == '008003')
        { // 订单已发送给WMS 发送指令取消
            $this->load->library('Yto');
            $data = array(
                'objectNo'=>$order->orderno
            );

            $result = $this->yto->zebraoutstack_cancel($data);
            $result = json_decode($result);
            if($result->success)
            {
                //取消成功 更新订单状态
                $this->db->query("UPDATE tb_order SET status='008010' WHERE id=?",array($orderid));
            }
            else
            {
                render_failed_json('该订单状态已改变，无法取消！');
                return false;
            }
        }
        else
        {
            //取消成功 更新订单状态
            $this->db->query("UPDATE tb_order SET status='008010' WHERE id=?",array($orderid));
        }

        if ($status == '008002' || $status == '008003')
        {
            // 当退款金额不为零时 生成退款单
            if ($order->realamount != 0)
            {
                $this->db->query('INSERT INTO tb_order_refund (id,returnid,userid,orderid,orderno,productid,amount,paystatus) VALUES (?,?,?,?,?,?,?,?)', array(trxid(), 0, $order->userid, $orderid, $order->orderno, 0, $order->realamount, '009001'));
            }

            // 取消订单 将所购商品的库存占用取消
            $query = $this->db->query('SELECT productid, goodsnums FROM tb_order_goods WHERE orderid=?', array($orderid));
            foreach ($query->result() as $row)
            {
                // 库存占用数--
                $this->db->query('UPDATE tb_warehouse_store SET occupynum = occupynum - ? WHERE warehouseid=1 AND productid=?', array(intval($row->goodsnums), $row->productid));
            }
        }
        //如果有优惠券使用 取消之后 把优惠券返给客户
        if ($order->couponids != '')
        {
            $this->db->query('UPDATE tb_user_coupon SET status = \'024001\' WHERE id in ('.$order->couponids.')');
        }


        $this->load->model('member');
        // 佣金返还给用户
        if($order->commissionamount > 0)
        {
            $this->member->return_commission_log($order->userid, $orderid, $order->commissionamount);
        }
        // 积分返还给用户
        if($order->points > 0)
        {
            $this->member->return_points_log($order->userid, '订单积分退还', $order->points, $orderid);
        }

        $this->db->trans_complete();

        if($this->db->trans_status())
        {
            render_success_json();
        }
        else
        {
            render_failed_json();
        }
    }


    /**
     * 评价订单
     */
    public function comment_list($id = 0)
    {
        $package = wx_get_sign_package();
        $this->smarty->assign('appId', $package['appId']);
        $this->smarty->assign('timestamp', $package['timestamp']);
        $this->smarty->assign('nonceStr', $package['nonceStr']);
        $this->smarty->assign('signature', $package['signature']);

        $query = $this->db->query('SELECT DISTINCT a.orderid,a.goodsid,b.name AS goodsname,d.imgurl,a.iscomment FROM tb_order_goods AS a LEFT JOIN tb_goods AS b ON a.goodsid=b.id LEFT JOIN tb_products AS c ON a.productid=c.id LEFT JOIN tb_goods_spec AS d ON c.goodsspecid1=d.id WHERE a.orderid = ?', array($id));

        $this->smarty->assign('goodslist', $query->result());

        $this->smarty->view('order/commentlist.tpl');
    }

    /**
     * 评价订单
     */
    public function comment_one()
    {
        $package = wx_get_sign_package();
        $this->smarty->assign('appId', $package['appId']);
        $this->smarty->assign('timestamp', $package['timestamp']);
        $this->smarty->assign('nonceStr', $package['nonceStr']);
        $this->smarty->assign('signature', $package['signature']);

        $orderid = $this->input->get('orderid');
        $this->smarty->assign('orderid', $orderid);
        $goodsid = $this->input->get('goodsid');
        $this->smarty->assign('goodsid', $goodsid);

        $query = $this->db->query('SELECT a.orderid,a.goodsid,b.name AS goodsname,a.productid,a.spec,d.imgurl FROM tb_order_goods AS a LEFT JOIN tb_goods AS b ON a.goodsid=b.id LEFT JOIN tb_products AS c ON a.productid=c.id LEFT JOIN tb_goods_spec AS d ON c.goodsspecid1=d.id WHERE a.orderid = ? AND a.goodsid = ?', array($orderid, $goodsid));

        $this->smarty->assign('goods', $query->row());

        $this->smarty->view('order/commentone.tpl');
    }

    /**
     * 评价单一商品
     */
    public function comment_goods()
    {
        $user = $this->bag->get("user");
        $userid= intval($user->id);

        $orderid = $this->input->post('orderid');
        $goodsid = $this->input->post('goodsid');
        $starnums = $this->input->post('starnums');
        $content = $this->input->post('content');
        $imgdata = $this->input->post('imgdata', false);

        $status = '013002'; // 默认正常状态
        $pic_array = array();
        if($imgdata)
        {
            $pic_array = $this->save_comment_pics($imgdata);
            if(!$pic_array)
            {
                render_failed_json('图片保存失败');
                return;
            }
            $status = '013001'; // 有图片的话 待审核状态
        }

        $this->db->trans_start();
        $this->db->query('INSERT INTO tb_review (id, goodsid, orderid, userid, starnums, content, picurls, status) VALUES (?, ?, ?, ?, ?, ?, ?, ?)', array(trxid(), $goodsid, $orderid, $userid, $starnums, $content, json_encode($pic_array), $status));
        $this->db->query('UPDATE tb_order_goods SET iscomment=1 WHERE orderid=? AND goodsid=?', array($orderid, $goodsid));

        // 判断该订单内商品如果都已评论，将订单置为已评论状态
        $query = $this->db->query('SELECT id FROM tb_order_goods WHERE orderid=? AND iscomment=0 LIMIT 1', array($orderid));
        if($query->num_rows() == 0)
        {
            $this->db->query('UPDATE tb_order SET status=\'008007\' WHERE id=?', array($orderid));
        }
        $this->db->trans_complete();

        if($this->db->trans_status())
        {
            render_success_json();
        }
        else
        {
            render_failed_json('保存失败！');
        }
    }

    /**
     * 保存评论晒图
     * @param $imgdata 图片base64
     * @return array
     */
    private function save_comment_pics($imgdata){
        $result_array = array();
        $move_flag = true;

        $url_array = explode('#', $imgdata);
        foreach($url_array as $url)
        {
            $year = date("Y");
            $month = date("m");
            $disurl = '/cdisk/fs/aye/comment/'.$year.'/'.$month;
            mkdirex($disurl);

            if (preg_match('/^(data:\s*image\/(\w+);base64,)/', $url, $result)){
                $type = $result[2];
                $file_name = trxid();
                $new_file = $disurl."/".$file_name.".".$type;
                if(file_put_contents($new_file, base64_decode(str_replace($result[1], '', $url)))){
                    $dispath = '/comment/'.$year.'/'.$month."/".$file_name.".".$type;
                    array_push($result_array, $dispath);
                }else{
                    $move_flag = false;
                }
            }
        }

        if($move_flag)
        {
            return $result_array;
        }
        else
        {
            return array();
        }
    }

    /**
     * 申请售后
     */
    public function after_sales_list($id = 0)
    {
        $query = $this->db->query('SELECT a.orderid,a.goodsid,b.name AS goodsname,a.productid,a.spec,a.goodsnums,d.imgurl,a.status FROM tb_order_goods AS a LEFT JOIN tb_goods AS b ON a.goodsid=b.id LEFT JOIN tb_products AS c ON a.productid=c.id LEFT JOIN tb_goods_spec AS d ON c.goodsspecid1=d.id WHERE a.orderid = ?', array($id));

        $this->smarty->assign('goodslist', $query->result());

        $this->smarty->view('order/after_sales_list.tpl');
    }

    /**
     * 单一商品申请退换货
     */
    public function after_sales_one()
    {
        $orderid = $this->input->get('orderid');
        $this->smarty->assign('orderid', $orderid);
        $productid = $this->input->get('productid');
        $this->smarty->assign('productid', $productid);

        $query = $this->db->query('SELECT a.orderid,e.orderno,a.goodsid,b.name AS goodsname,a.productid,a.goodsnums,a.spec,d.imgurl FROM tb_order_goods AS a LEFT JOIN tb_goods AS b ON a.goodsid=b.id LEFT JOIN tb_products AS c ON a.productid=c.id LEFT JOIN tb_goods_spec AS d ON c.goodsspecid1=d.id LEFT JOIN tb_order AS e ON a.orderid=e.id WHERE a.orderid = ? AND a.productid = ?', array($orderid, $productid));

        $this->smarty->assign('goods', $query->row());

        $this->smarty->view('order/after_sales_one.tpl');
    }

    /**
     * 单一商品退换货 进度查询
     */
    public function after_sales_detail()
    {
        $user = $this->bag->get("user");
        $userid= intval($user->id);

        $orderid = $this->input->get('orderid');
        $this->smarty->assign('orderid', $orderid);
        $productid = $this->input->get('productid');
        $this->smarty->assign('productid', $productid);

        $query = $this->db->query('SELECT a.orderid,e.orderno,a.goodsid,b.name AS goodsname,a.productid,a.spec,d.imgurl FROM tb_order_goods AS a LEFT JOIN tb_goods AS b ON a.goodsid=b.id LEFT JOIN tb_products AS c ON a.productid=c.id LEFT JOIN tb_goods_spec AS d ON c.goodsspecid1=d.id LEFT JOIN tb_order AS e ON a.orderid=e.id WHERE a.orderid = ? AND a.productid = ?', array($orderid, $productid));
        $this->smarty->assign('goods', $query->row());

        $query = $this->db->query('SELECT a.nums,a.reason,a.expressno,a.tp,a.status AS rstatus,a.handlingidea,IFNULL(b.amount,0) AS ramount,IFNULL(b.commission,0) AS rcommission,b.paystatus FROM tb_order_returns AS a LEFT JOIN tb_order_refund AS b ON a.id=b.returnid WHERE a.userid=? AND a.orderid=? AND a.productid=?', array($userid, $orderid, $productid));
        $row = $query->row();
        $row->statusname = '';
        if ($row->rstatus == '025001')
        {
            $row->statusname = '待审核';
        }
        else if ($row->rstatus == '025002')
        {
            $row->statusname = '审核通过，您可以邮寄商品了。';
        }
        else if ($row->rstatus == '025003')
        {
            $row->statusname = '审核不通过，原因：'.$row->handlingidea;
        }
        else if ($row->rstatus == '025004')
        {
            if ($row->paystatus == '009001')
            {
                $row->statusname = '退款中';
            }
            else if ($row->paystatus == '009002')
            {
                $row->statusname = '退款完成';
            }
        }

        $this->smarty->assign('returninfo', $row);

        $this->smarty->view('order/after_sales_detail.tpl');
    }

    /**
     * 申请退换货
     */
    public function apply_after_sales()
    {
        $user = $this->bag->get("user");
        $userid= intval($user->id);

        $orderid = $this->input->post('orderid');
        $orderno = $this->input->post('orderno');
        $goodsid = $this->input->post('goodsid');
        $productid = $this->input->post('productid');
        $tp = $this->input->post('tp');
        $nums = $this->input->post('nums');
        $reason = $this->input->post('reason');

        $status = $tp == '026001' ? '020002' : '020003';

        $this->db->trans_start();

        $this->db->query('INSERT INTO tb_order_returns (id,userid,orderid,orderno,goodsid,productid,nums,reason,tp,status) VALUES (?,?,?,?,?,?,?,?,?,?)', array(trxid(), $userid, $orderid, $orderno, $goodsid, $productid, $nums, $reason, $tp, '025001'));

        $this->db->query('UPDATE tb_order_goods SET status=? WHERE orderid=? AND goodsid=? AND productid=?', array($status, $orderid, $goodsid, $productid));

        $this->db->trans_complete();

        if($this->db->trans_status())
        {
            render_success_json();
        }
        else
        {
            render_failed_json('保存失败！');
        }
    }

}