class Agi  
  def bing(graph)
    graph[:nodes].each do |n|
      p n
    end
  end
end

data_bag = {
  nodes: [{
  id: '0',
  label: 'S',
  type: 'S',
  x: 1,
  y: 1,
  width: 100,
  height: 100,
  weight: 1,
  outgoings_id:['0_1'],
  incomings_id:[]
},{
  id: '1',
  label: 'G1',
  type: 'G',
  x: 1,
  y: 1,
  width: 100,
  height: 100,
  weight: 1,
  outgoings_id:['1_1','1_2'],
  incomings_id:['0_1']
},{
  id: '2',
  label: 'T1',
  type: 'T',
  x: 1,
  y: 1,
  width: 100,
  height: 100,
  weight: 1,
  outgoings_id:['2_1'],
  incomings_id:['1_1']
},{
  id: '3',
  label: 'T2',
  type: 'T',
  x: 1,
  y: 1,
  width: 100,
  height: 100,
  weight: 1,
  outgoings_id:['3_1'],
  incomings_id:['1_2']  
},{
  id: '4',
  label: 'E',
  type: 'E',
  x: 1,
  y: 1,
  width: 100,
  height: 100,
  weight: 1,
  outgoings_id:[],
  incomings_id:['2_1','3_1']
}],
  links: [{
  id: '0_1',
  source_id: '0',
  target_id: '1',
  label: 'f1',
  weight: 1
},{
  id:'1_1', 
  source_id: '1',
  target_id: '2',
  label: 'f2',
  weight: 1
},{
  id:'1_2',
  source_id: '1',
  target_id: '3',
  label: 'f3',
  weight: 1
},{
  id:'2_1',
  source_id: '2',
  target_id: '4',
  label: 'f4',
  weight: 1
},{
  id:'3_1',
  source_id: '3',
  target_id: '4',
  label: 'f5',
  weight: 1
}],
  options: {},
  host_id: ''
}

data_bag2 = {
  nodes: [{
  id: '0',
  label: '开始',
  type: 'S',
  x: 1,
  y: 1,
  width: 100,
  height: 100,
  weight: 1,
  outgoings_id:['0_1'],
  incomings_id:[]
},{
  id: '1',
  label: '查询帐户资金信息',
  type: 'T',
  x: 1,
  y: 1,
  width: 100,
  height: 100,
  weight: 1,
  outgoings_id:['1_1'],
  incomings_id:['0_1']
},{
  id: '2',
  label: '返回最新数据',
  type: 'T',
  x: 1,
  y: 1,
  width: 100,
  height: 100,
  weight: 1,
  outgoings_id:['2_1'],
  incomings_id:['1_1']
},{
  id: '3',
  label: '提交委托信息',
  type: 'G',
  x: 1,
  y: 1,
  width: 100,
  height: 100,
  weight: 1,
  outgoings_id:['3_1','3_2','3_3','3_4'],
  incomings_id:['2_1']  
},{
  id: '4',
  label: '止损高买',
  type: 'T',
  x: 1,
  y: 1,
  width: 100,
  height: 100,
  weight: 1,
  outgoings_id:['4_1'],
  incomings_id:['3_1']
},{
  id: '5',
  label: '止损低卖',
  type: 'T',
  x: 1,
  y: 1,
  width: 100,
  height: 100,
  weight: 1,
  outgoings_id:['5_1'],
  incomings_id:['3_2']
},{
  id: '6',
  label: '获利高卖',
  type: 'T',
  x: 1,
  y: 1,
  width: 100,
  height: 100,
  weight: 1,
  outgoings_id:['6_1'],
  incomings_id:['3_3']
},{
  id: '7',
  label: '获利低买',
  type: 'T',
  x: 1,
  y: 1,
  width: 100,
  height: 100,
  weight: 1,
  outgoings_id:['7_1'],
  incomings_id:['3_4']
},{
  id: '8',
  label: '是否开市',
  type: 'G',
  x: 1,
  y: 1,
  width: 100,
  height: 100,
  weight: 1,
  outgoings_id:['8_1','8_2'],
  incomings_id:['4_1','5_1','6_1','7_1']
},{
  id: '9',
  label: '是否签约',
  type: 'G',
  x: 1,
  y: 1,
  width: 100,
  height: 100,
  weight: 1,
  outgoings_id:['9_1','9_2'],
  incomings_id:['8_2']
},{
  id: '10',
  label: '委托笔数最大否',
  type: 'G',
  x: 1,
  y: 1,
  width: 100,
  height: 100,
  weight: 1,
  outgoings_id:['10_1','10_2'],
  incomings_id:['9_2']
},{
  id: '11',
  label: '提示错误信息',
  type: 'E',
  x: 1,
  y: 1,
  width: 100,
  height: 100,
  weight: 1,
  outgoings_id:[],
  incomings_id:['8_1','9_1','10_1']
},{
  id: '12',
  label: '委托成功',
  type: 'G',
  x: 1,
  y: 1,
  width: 100,
  height: 100,
  weight: 1,
  outgoings_id:['12_1','12_2'],
  incomings_id:['10_2']
},{
  id: '13',
  label: '是否在有效期',
  type: 'G',
  x: 1,
  y: 1,
  width: 100,
  height: 100,
  weight: 1,
  outgoings_id:['13_1','13_2','13_3'],
  incomings_id:['12_2']
},{
  id: '14',
  label: '满足撮合条件',
  type: 'G',
  x: 1,
  y: 1,
  width: 100,
  height: 100,
  weight: 1,
  outgoings_id:['14_1','14_2'],
  incomings_id:['13_3']
},{
  id: '15',
  label: '满足',
  type: 'G',
  x: 1,
  y: 1,
  width: 100,
  height: 100,
  weight: 1,
  outgoings_id:['15_1','15_2','15_3'],
  incomings_id:['14_2']
},{
  id: '16',
  label: '委托失效',
  type: 'G',
  x: 1,
  y: 1,
  width: 100,
  height: 100,
  weight: 1,
  outgoings_id:['16_1','16_2'],
  incomings_id:['13_1']
},{
  id: '17',
  label: '指定交易',
  type: 'E',
  x: 1,
  y: 1,
  width: 100,
  height: 100,
  weight: 1,
  outgoings_id:[],
  incomings_id:['15_1']
},{
  id: '18',
  label: '委托撤单',
  type: 'E',
  x: 1,
  y: 1,
  width: 100,
  height: 100,
  weight: 1,
  outgoings_id:[],
  incomings_id:['13_2']
},{
  id: '19',
  label: '明细查询',
  type: 'E',
  x: 1,
  y: 1,
  width: 100,
  height: 100,
  weight: 1,
  outgoings_id:[],
  incomings_id:['15_2','16_1']
},{
  id: '20',
  label: '委托查询',
  type: 'E',
  x: 1,
  y: 1,
  width: 100,
  height: 100,
  weight: 1,
  outgoings_id:[],
  incomings_id:['12_1','16_2','15_3']
},{
  id: '21',
  label: '结束',
  type: 'E',
  x: 1,
  y: 1,
  width: 100,
  height: 100,
  weight: 1,
  outgoings_id:[],
  incomings_id:['14_1']
}],
  links: [{
  id: '0_1',
  source_id: '0',
  target_id: '1',
  label: '',
  weight: 1
},{
  id:'1_1', 
  source_id: '1',
  target_id: '2',
  label: '',
  weight: 1
},{
  id:'2_1',
  source_id: '2',
  target_id: '3',
  label: '',
  weight: 1
},{
  id:'3_1',
  source_id: '3',
  target_id: '4',
  label: '',
  weight: 1
},{
  id:'3_2',
  source_id: '3',
  target_id: '5',
  label: '',
  weight: 1
},{
  id:'3_3',
  source_id: '3',
  target_id: '6',
  label: '',
  weight: 1
},{
  id:'3_4',
  source_id: '3',
  target_id: '7',
  label: '',
  weight: 1
},{
  id:'4_1',
  source_id: '4',
  target_id: '8',
  label: '',
  weight: 1
},{
  id:'5_1',
  source_id: '5',
  target_id: '8',
  label: '',
  weight: 1
},{
  id:'6_1',
  source_id: '6',
  target_id: '8',
  label: '',
  weight: 1
},{
  id:'7_1',
  source_id: '7',
  target_id: '8',
  label: '',
  weight: 1
},{
  id:'8_1',
  source_id: '8',
  target_id: '11',
  label: '',
  weight: 1
},{
  id:'8_2',
  source_id: '8',
  target_id: '9',
  label: '',
  weight: 1
},{
  id:'9_1',
  source_id: '9',
  target_id: '11',
  label: '',
  weight: 1
},{
  id:'9_2',
  source_id: '9',
  target_id: '10',
  label: '',
  weight: 1
},{
  id:'10_1',
  source_id: '10',
  target_id: '11',
  label: '',
  weight: 1
},{
  id:'10_2',
  source_id: '10',
  target_id: '12',
  label: '',
  weight: 1
},{
  id:'12_1',
  source_id: '12',
  target_id: '20',
  label: '',
  weight: 1
},{
  id:'12_2',
  source_id: '12',
  target_id: '13',
  label: '',
  weight: 1
},{
  id:'13_1',
  source_id: '13',
  target_id: '16',
  label: '',
  weight: 1
},{
  id:'13_2',
  source_id: '13',
  target_id: '18',
  label: '',
  weight: 1
},{
  id:'13_3',
  source_id: '13',
  target_id: '14',
  label: '',
  weight: 1
},{
  id:'14_1',
  source_id: '14',
  target_id: '21',
  label: '',
  weight: 1
},{
  id:'14_2',
  source_id: '14',
  target_id: '15',
  label: '',
  weight: 1
},{
  id:'15_1',
  source_id: '15',
  target_id: '17',
  label: '',
  weight: 1
},{
  id:'15_2',
  source_id: '15',
  target_id: '19',
  label: '',
  weight: 1
},{
  id:'15_3',
  source_id: '15',
  target_id: '20',
  label: '',
  weight: 1
},{
  id:'16_1',
  source_id: '16',
  target_id: '19',
  label: '',
  weight: 1
},{
  id:'16_2',
  source_id: '16',
  target_id: '20',
  label: '',
  weight: 1
}],
  options: {},
  host_id: ''
}


a = Agi.new
a.bing(data_bag)