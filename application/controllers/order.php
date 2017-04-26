<?php  if ( ! defined('BASEPATH')) exit('No direct script access allowed');


//购物车控制器
class Order extends Home_Controller{

	public function __construct(){
		parent::__construct();
		$this->load->model('address_model');
		$this->load->model('goods_model');
	}

	#用户订单
	public function show_order(){
             var_dump(APP_ID);
		$this -> output -> enable_profiler(TRUE);
		$orderno = date('Ymd').substr(implode(NULL, array_map('ord', str_split(substr(uniqid(), 7, 13), 1))), 0, 8);
		var_dump($orderno);
                var_dump(time());
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
			
			$data['carts'] = $this->cart->contents();

			$this->load->view('order.html',$data);
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
        //先遍历购物车内的金额和商品，后续可以考虑将用户从购物车选择的物品放到redis
        $carts= $this->cart->contents();
        $goods_amount=($this->cart->total());
        $order_amount=($this->cart->total());
        var_dump($this->cart->total());
        
        // 生成16位唯一订单编号
        $order_sn= date('Ymd').substr(implode(NULL, array_map('ord', str_split(substr(uniqid(), 7, 13), 1))), 0, 8);
				
        $this->db->trans_start();
        $this->db->query('INSERT INTO ci_order (order_sn, user_id, address_id, order_status, postscripts, shipping_id, pay_id, goods_amount, order_amount, order_time) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)', array($order_sn,$user_id,$address_id,$order_status,$postscripts,$shipping_id,$pay_id,$goods_amount,$order_amount,$order_time));
 				        
        foreach($carts as $cart)
        {
        	$goods_attr='werw';
        	$goods_id=$cart['id'];
        	$good=$this->goods_model->get_goods($goods_id);
        	var_dump($good['goods_img']);
        	$this->db->query('INSERT INTO ci_order_goods (order_sn, goods_id, goods_name, goods_img, shop_price, goods_price, goods_number, goods_attr, subtotal) VALUES (?, ?, ?, ?, ?, ?, ?, ?,?)', array($order_sn,$cart['id'],$cart['name'],$good['goods_img'],$cart['price'],$cart['price'],$cart['qty'],$goods_attr,$cart['subtotal']));
 
 					//从购物车删除此id
 				  //$data['rowid'] = $cart['rowid'];
				//	$data['qty'] = 0;
					//$this->cart->update($data);
        }
        $this->db->trans_complete();

       
        if($this->db->trans_status())
        {
            echo json_encode(strval($order_sn));
        }
        else
        {
            echo json_encode('操作失败，请重新提交！');
        }
		
	}
	//获取固定状态的订单
	public function get_orders($stats){
		$this -> output -> enable_profiler(TRUE);
		 //var_dump($stats);
		 $user = $this->session->userdata('user');
     $user_id = strval($user['user_id']);
      //var_dump($user);
      if($stats=='ALL')
      	 $orders_query = $this->db->query('select *from ci_order where  user_id=?', array($user_id));
      else
			   $orders_query = $this->db->query('select *from ci_order where order_status=? and user_id=?', array($stats,$user_id));
		 
  	 $orders = $orders_query->result_array();
  	 // var_dump($orders);
  	 echo json_encode($orders);
  	 //$this->load->view('index.html',$orders);
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
