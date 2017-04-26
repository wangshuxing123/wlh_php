<?php  if ( ! defined('BASEPATH')) exit('No direct script access allowed');

//配送地址模型
class Address_model extends CI_Model{

	const TBL_ADDRESS = 'address'; //此处不需要加前缀

	#添加地址
	public function add_address($data){
		return $this->db->insert(self::TBL_ADDRESS,$data);
	}
	#查询用户id的地址
	public function get_address($user_id){
		$condition['user_id'] = $user_id;
		$query = $this->db->where($condition)->get(self::TBL_ADDRESS);
		return $query->result_array();
	}
	#查询用户id的m默认地址
	public function get_mainAddress($user_id){
		$condition['user_id'] = $user_id;
		$condition['default'] = '1';
		$query = $this->db->where($condition)->get(self::TBL_ADDRESS);
		return $query->row_array();
	}
	#查询用户id的默认地址个数
	public function get_mainNum($user_id){
		$condition['user_id'] = $user_id;
		$condition['default'] = '1';
		$query = $this->db->where($condition)->get(self::TBL_ADDRESS);
		return $query->num_rows();
	}
	#查询用户id的第一个地址
	public function get_firstAddress($user_id){
		$sql = "select * from ci_address where user_id = $user_id limit 1";
		$query = $this->db->query($sql);
		return $query->row_array();
	}
	#删除
   public function delete_address($addr_id){
      $condition['address_id'] = $addr_id;
      $query = $this->db->where($condition)->delete(self::TBL_ADDRESS);
     if ($query && $this->db->affected_rows() > 0) {
       return true;
      } else {
       return false;
      }
    }
}
