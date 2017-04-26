<?php  if ( ! defined('BASEPATH')) exit('No direct script access allowed');


//购物车控制器
class Address extends Home_Controller{

	public function __construct(){
		parent::__construct();
		$this->load->model('address_model');
		$this->load->library('form_validation');
	}

	#显示订单
	public function show_address(){
		$this -> output -> enable_profiler(TRUE);
		#获取购物车数据
		$user = $this->session->userdata('user');
		if (empty($user)){
			$this->load->view('login.html');
			}
		else{
			$data['address'] = $this->address_model->get_address($user['user_id']);
			$this->load->view('address.html',$data);
			}
		
	}

	public function create_address(){
		#设置验证规则
		$user = $this->session->userdata('user');
		$this->form_validation->set_rules('consignee','收货人姓名','trim|required');
		var_dump($user);
		if ($this->form_validation->run() == false) {
			# 未通过验证
			$data['message'] = validation_errors(); 
			$data['wait'] = 3;
			$data['url'] = site_url('address/show_address');
			$this->load->view('message.html',$data);
		} else {
			# 通过验证
			$data['user_id'] =$user['user_id'];
			$data['consignee'] = $this->input->post('consignee',true);
			$data['province'] = $this->input->post('province');
			$data['city'] = $this->input->post('city',true);
			$data['district'] = $this->input->post('district',true);
			$data['street'] = $this->input->post('street',true);
			$data['mobile'] = $this->input->post('mobile');
			 var_dump($data);


			#调用model方法完成插入
			if ($this->address_model->add_address($data)){
				#插入ok
				$data['message'] = '添加成功'; 
				$data['wait'] = 2;
				$data['url'] = site_url('address/show_address');
				$this->load->view('message.html',$data);
			} else{
				#插入失败
				$data['message'] = '添加商品类别失败'; 
				$data['wait'] = 3;
				$data['url'] = site_url('address/show_address');
				$this->load->view('message.html',$data);
			}
		}
		
	}

	#删除购物车信息
	public function delete_address($rowid){
		if ($this->address_model->delete_address($rowid))
		redirect('address/show_address');
	}
}
