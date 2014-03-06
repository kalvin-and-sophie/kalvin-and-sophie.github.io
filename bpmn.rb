# encoding: utf-8
$:.push File.expand_path('..',__FILE__)
require 'graph'
require 'bpmn_objects'

class Analitic  
  
  def initialize(graph)
    @cycles = []
    @lines = []
    @stack = []
    @paths = []
    
    @graph = graph
    @nodes = graph.nodes
    @flows = graph.flows
  end  

  def parser(mode)
    high_route_cover get_start_node
    case mode
    when :high
      #do nothing
    when :middle
      middle_flow_cover
    when :low
      low_node_cover
    end
    
    p_result 'path'
  end

  protected
  def high_route_cover(start_node)
    get_cycles(start_node)
    @stack.clear
    get_lines(start_node)
    get_paths
  end

  def middle_flow_cover
    flows_pool = @flows.clone
    return_paths = []
    
    loop do
      if flows_pool.length <= 0
        break
      end
      
      mvp_path = find_the_mvp_path(:flows_pool => flows_pool)

      if mvp_path != nil
        mvp_path.flow_seq(@graph).each do |f|
          flows_pool.delete(f)
        end
        return_paths.push mvp_path
      end
    end

    @paths = return_paths
  end
  
  def low_node_cover
    nodes_pool = @nodes.clone
    return_paths = []
    
    loop do
      if nodes_pool.length <= 0
        break
      end
      
      mvp_path = find_the_mvp_path(:nodes_pool => nodes_pool)
      if mvp_path != nil
        mvp_path.node_seq.each do |n|
          nodes_pool.delete(n)
        end
        return_paths.push mvp_path
      end
    end

    @paths = return_paths
  end
  
  def get_cycles(node)
    if @stack.include?(node)
      temp_stack = []
      temp_cycle = []
      temp_stack = @stack.clone

      #取环
      loop do
        temp_cycle.push temp_stack.last
        temp_stack.pop
        if  temp_stack.last == node
          temp_cycle.push node
          break
        end
      end
      @cycle = Cycle.new
      @cycle.node_seq = temp_cycle.reverse
          
      #取成环节点
      loop do
        if @stack.last.type == 'GatewayNode'
          @cycle.key_node = @stack.last
          @cycle.init_key_flow(@graph,node)
          @cycle.key_flow.blocked = true
          @stack.last.avaliable_count = @stack.last.avaliable_count - 1
          break
        else
          @stack.pop
        end
      end
  
      @cycles.push @cycle
    else
      @stack.push node

      case @stack.last.type
      when 'StartNode'
        node.status = 1 
        node = node.next_node(@graph)
        self.get_cycles(node)      
      when 'TaskNode'
        node.status = 1 
        node = node.next_node(@graph)
        self.get_cycles(node)
      when 'GatewayNode'
        node.status = 1 
        nodes = node.next_nodes(@graph)
        nodes.each do |n|
          self.get_cycles(n)
          while @stack.last != node do
            @stack.pop
          end
        end
      when 'EndNode'
        while @stack.last.type != 'GatewayNode' do
          @stack.pop
        end
      else
        puts 'error type' + @stack.last.type
      end
    end
  end  

  def get_lines(node)
    @stack.push node
    if node.type == 'GatewayNode' then
      node.avaliable_count = node.outgoings_id.length
    end
    
    case @stack.last.type
    when 'StartNode'
      node.status = 1 
      node = node.next_node(@graph)
      self.get_lines(node)      
    when 'TaskNode'
      node.status = 1 
      node = node.next_node(@graph)
      self.get_lines(node)
    when 'GatewayNode'
      node.status = 1 
      nodes = node.next_nodes(@graph)

      nodes.each do |n|
        node.avaliable_count = node.avaliable_count - 1
        self.get_lines(n)
      end
    when 'EndNode'
      @line = Line.new
      @line.node_seq = @stack.reverse.reverse
      @lines.push @line
      #p '完成一条line添加' + @line.node_string

      loop do        
        if @stack.length > 0 

          if @stack.last.type == 'GatewayNode'  and @stack.last.avaliable_count > 0 
            #p '当前gateway是[' + @stack.last.name + ']出口数是[' + @stack.last.avaliable_count.to_s + ']'
            break
          else
            @stack.pop
          end
        else
          break
        end
      end
      
      #p '当前栈为' + @stack.to_s
    else
      p 'error type' + @stack.last.type
    end
  end
  
  def get_paths
    
    @lines.each do |line|
      @paths.push line
      @cycles.each do |cycle|
        head = []
        tail = []

        if line.node_seq.include?(cycle.key_node)
          line.node_seq.each do |node|
            if node != cycle.key_node 
              head.push node
            else
              head.push cycle.key_node 
              break
            end
          end
          tail = line.node_seq - head

          @path = Path.new
          @path.node_seq = head + cycle.node_seq + tail
          @paths.push @path
        end
      end
    end
  end

  def p_result(type)
    case type
    when 'line'
      p '***** There is [' + @lines.length.to_s + '] lines *****'
      @lines.each do |path|
        p path.node_string
      end
    when 'cycle'
      p '***** There is [' + @cycles.length.to_s + '] cycles *****'
      @cycles.each do |path|
        p path.node_string
      end
    when 'path'
      p '***** There is [' + @paths.length.to_s + '] paths *****'
      @paths.each do |path|
        p path.node_string
      end
    end
    p '------------------------------'
  end
  
  def get_start_node
    x = @graph.nodes.select do |n|
      n.type == 'StartNode'
    end
    
    return x.first
  end
  
  def get_nodes_from_paths(paths)
  end
  
  def get_hit_result(pool,path)
    count = 0
    case pool.keys.first
    when :nodes_pool
      path.node_seq.uniq.each do |f_path|
        pool[:nodes_pool].each do |n_pool|
          if f_path.id == n_pool.id
            count = count + 1
          end
        end
      end
    when :flows_pool
      path.flow_seq(@graph).uniq.each do |f_path|
        pool[:flows_pool].each do |f_pool|
          p f_path.class
          if f_path.id == f_pool.id
              #p 'bingo'
            count = count + 1
          end
          #p f_pool.id
          #p f_path.id
        end
      end
    end
    return count
  end
    
  def find_the_mvp_path(pool)
    hit = 0
    max = 0
    mvp = ''
    
    @paths.each do |p| 
      hit = get_hit_result(pool,p)

      if hit != 0  
        if max < hit
          max = hit
          mvp = p
        elsif max == hit
          if mvp.node_seq.length > p.node_seq.length
            mvp = p
          end
        end
      end
    end

    @paths.delete(mvp)
    return mvp
  end
end

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
  incomings_id:['4_1','5_1','6_1','7_1','13_4']
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
  outgoings_id:['13_1','13_2','13_3','13_4'],
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
  id:'13_4',
  source_id: '13',
  target_id: '8',
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

graph = Graph.new(data_bag2)
analiticer = Analitic.new(graph)
analiticer.parser :middle