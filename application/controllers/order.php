<?php  if ( ! defined('BASEPATH')) exit('No direct script access allowed');


//购物车控制器
class Order extends Home_Controller{

	public function __construct(){
		parent::__construct();
		$this->load->model('address_model');
		$this->load->model('goods_model');
        $this->load->driver('cache', array('adapter' => 'file'));
	}

	#从购物车>购买
	public function cart_order(){
		$this -> output -> enable_profiler(TRUE);
		#获取购物车数据
		$user = $this->session->userdata('user');
		
		if (empty($user)){
			$this->load->view('login.html');
			}
		else{
			$num=$this->address_model->get_mainNum($user['user_id']);
			if($num==1)
				$data['address'] = $this->address_model->get_mainAddress($user['user_id']);
			else
				$data['address'] = $this->address_model->get_firstAddress($user['user_id']);

			$data['carts'] =$this->cache->get("order_confirm_goods_" . $user['user_id']);
            var_dump(json_encode($data));
			$this->load->view('order_confirm.html',$data);
			}
		
	}
    #直接购买
    public function buy_now(){
        $this -> output -> enable_profiler(TRUE);
        //未登陆不可直接购买
        $user = $this->session->userdata('user');
        if (empty($user)){
            $this->load->view('login.html');
        }
        else{
            //获取收货地址
            $num=$this->address_model->get_mainNum($user['user_id']);
//            if($num==1)
//                $data['address'] = $this->address_model->get_mainAddress($user['user_id']);
//            else
//                $data['address'] = $this->address_model->get_firstAddress($user['user_id']);
            //获取提交商品信息
            $good['id'] = $this->input->post('goods_id');
            $good['name'] = $this->input->post('goods_name');
            $good['qty'] = 2;//wll$this->input->post('goods_nums');
            $good['price'] = 12.2;//$this->input->post('shop_price');
            $good['subtotal'] = floatval($good['price'])*intval($good['qty']);
            $arr= array();
            array_push($arr,$good);
            $data['goods']=$arr;
            $data['totalAmount']=floatval($good['price'])*intval($good['qty']);
            $this->cache->save("order_confirm_goods_".$user['user_id'], $data);
            var_dump( $this->cache->get("order_confirm_goods_".$user['user_id']));
            $this->load->view('order_confirm.html',$data);
        }

    }
	public function submit_order(){
        $user = $this->session->userdata('user');
        $user_id = strval($user['user_id']);

        $address_id = intval(11);//$this->input->post('addressid')
        $order_status=intval(1);
        $postscripts=strval('beizhu');//$this->input->post('postscripts')
        $shipping_id=1;
        $pay_id=1;
        $order_time=time();

        // 生成16位唯一订单编号
        $order_sn= date('Ymd').substr(implode(NULL, array_map('ord', str_split(substr(uniqid(), 7, 13), 1))), 0, 8);
        $goodslist = $this->cache->get('order_confirm_goods_'.$user_id);
        var_dump('wsx:'.json_encode($goodslist));
        var_dump($goodslist['totalAmount']);
        $this->db->trans_start();
        $this->db->query('INSERT INTO ci_order (order_sn, user_id, address_id, order_status, postscripts, shipping_id, pay_id, goods_amount, order_amount, order_time) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)', array($order_sn,$user_id,$address_id,$order_status,$postscripts,$shipping_id,$pay_id,$goodslist['totalAmount'],$goodslist['totalAmount'],$order_time));
        //遍历缓存中用户确认的商品
        foreach($goodslist['goods'] as $cart)
        {
        	$goods_attr='werw';
        	$goods_id=$cart['id'];
        	$good=$this->goods_model->get_goods($goods_id);
        	var_dump($good['goods_img']);
        	$this->db->query('INSERT INTO ci_order_goods (order_sn, goods_id, goods_name, goods_img, shop_price, goods_price, goods_number, goods_attr, subtotal) VALUES (?, ?, ?, ?, ?, ?, ?, ?,?)', array($order_sn,$good['goods_id'],$good['goods_name'],$good['goods_img'],$cart['price'],$cart['price'],$cart['qty'],$goods_attr,$cart['subtotal']));
 
 					//从购物车删除此id
 				  //$data['rowid'] = $cart['rowid'];
				//	$data['qty'] = 0;
					//$this->cart->update($data);
        }
        $this->db->trans_complete();
        if($this->db->trans_status())
        {
            $data["success"]=1;
            $data["data"]=strval($order_sn);
        }
        else
        {
            $data["success"]=-1;
            $data["data"]='操作失败，请重新提交！';
        }
        echo json_encode($data);
	}

    /**
     * 订单提交成功 马上付款
     */
    public function online_charge($id = 0)
    {
        $query = $this->db->query('SELECT id, orderno, realamount, status FROM tb_order WHERE order_sn=?', array($id));
        $data['order']=$query->row();
        $this->load->view('online_charge.html',$data);
    }
    /**
     * 立即支付
     */
    public function to_pay(){

        $user = $this->session->userdata('user');
        $userid = strval($user['user_id']);

        $openid = get_cookie('aye_openid');
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
     * 微信支付 接口
     * @param $out_trade_no
     * @param $body
     * @param $notify_url
     * @param $total_fee
     * @param string $openid
     * @return array
     */
    function wx_pay($orderid, $out_trade_no, $body, $notify_url, $total_fee, $trade_type, $openid='')
    {
        $_CI = &get_instance();
        $appid = $_CI->wxcpt->get_wx_appid();
        $mch_id = $_CI->wxcpt->get_wx_mchid();

        $param = array();
        $param['appid'] = $appid;
        $param['mch_id'] = $mch_id;  //商户号
        $param['device_info'] = 'WEB';
        $param['spbill_create_ip'] = $_SERVER['REMOTE_ADDR'];  //终端ip
        $param['trade_type'] = $trade_type;
        $param['product_id'] = $out_trade_no;
        $param['nonce_str'] = nonce_str();  //随机字符串
        if ($trade_type != 'NATIVE')
        {
            $param['openid'] = $openid;
        }
        $param['total_fee'] = $total_fee*100;  //实际金额
        $param['body'] = $body;
        $param['out_trade_no'] = $out_trade_no;
        $param['notify_url'] = $notify_url;
        $param['attach'] = $orderid;
        $param['sign'] = signval($param);

        $url = "https://api.mch.weixin.qq.com/pay/unifiedorder";
        $xml = array_to_xml($param);
        $resultXml = http_post_by_data($xml,$url);
        $result = xml_to_array($resultXml);

//        log_message('debug', 'pay_result:'.json_encode($result));

        $prepay_id = $result["prepay_id"];
        $code_url = '';
        if(array_key_exists('code_url', $result))
        {
            $code_url = $result["code_url"];
        }

        $data = array();
        $data['appId'] = $appid;
        $data["timeStamp"] = strval(time());
        $data["nonceStr"] = nonce_str();
        $data["package"] = 'prepay_id='.$prepay_id;
        $data["signType"] = "MD5";
        $data["paySign"] = signval($data);
        $data['orderid'] = $orderid;
        $data['orderno'] = strval($out_trade_no);
        $data['code_url'] = $code_url;

        return $data;
    }
    //获取固定状态的订单
	public function get_orders($stats){
		$this -> output -> enable_profiler(TRUE);
		 $user = $this->session->userdata('user');
         $user_id = strval($user['user_id']);
        if (empty($user)){
            $this->load->view('login.html');
        }
        else {
            if ($stats == 'ALL')
                $orders_query = $this->db->query('select *from ci_order where  user_id=?', array($user_id));
            else
                $orders_query = $this->db->query('select *from ci_order where order_status=? and user_id=?', array($stats, $user_id));
            $orders = $orders_query->result_array();
            echo json_encode($orders);
        }
	}
	
		//获取订单下商品
	public function get_goods($order_sn){
		$this -> output -> enable_profiler(TRUE);
		 //var_dump($stats);
		 $goods_query = $this->db->query('select * from ci_order_goods where order_sn=?', array($order_sn));
  	 $goods = $goods_query->result_array();
  	 // var_dump($orders);
  	 echo json_encode($goods);
  	 //$this->load->view('index.html',$orders);
	}
}
