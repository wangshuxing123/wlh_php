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
		$user = $this->session->userdata('user');
		if (empty($user)){
			$this->load->view('login.html');
			}
		else{
			$data['address'] = $this->address_model->get_address($user['user_id']);
			$this->load->view('address_list.html',$data);
			}
		
	}
    #   增加地址页面
    public function add_address(){
        $user = $this->session->userdata('user');
        if (empty($user)){
            $this->load->view('login.html');
        }
        else{
            $query = $this->db->query('SELECT region_id, region_name FROM ci_region WHERE parent_id=?', array(0));
            $data['province']=$query->result_array();
            $this->load->view('address.html',$data);
        }
    }

    public function find_citys_by_province(){
        $provinceid = $this->input->post('provinceid',true);
        $query = $this->db->query('SELECT region_id id, region_name name FROM ci_region WHERE parent_id=?', array($provinceid));
        $data['success']=1;
        $data['data']=$query->result_array();
        echo  json_encode($data);
    }

	public function create_address(){
		#设置验证规则
		$user = $this->session->userdata('user');
		$this->form_validation->set_rules('acceptname','收货人姓名','trim|required');
		if ($this->form_validation->run() == false) {
			# 未通过验证
			$data['message'] = validation_errors(); 
			$data['wait'] = 3;
			$data['url'] = site_url('address/show_address');
			$this->load->view('message.html',$data);
		} else {
			# 通过验证
			$data['user_id'] =$user['user_id'];
			$data['consignee'] = $this->input->post('acceptname',true);
			$data['province'] = $this->input->post('province');
			$data['city'] = $this->input->post('city',true);
			$data['district'] = $this->input->post('region',true);
			$data['street'] = $this->input->post('addr',true);
			$data['mobile'] = $this->input->post('mobile');

			#调用model方法完成插入
			if ($this->address_model->add_address($data)){
				#插入ok
				$data['success'] = 1;
                $data['msg'] = "address/show_address";
			} else{
				#插入失败
                $data['success'] = -1;
                $data['msg'] = "添加失败！";
			}
			echo json_encode($data);
		}
		
	}
	#删除地址信息
	public function delete_address($rowid){
		if ($this->address_model->delete_address($rowid))
		redirect('address/show_address');
	}


}
