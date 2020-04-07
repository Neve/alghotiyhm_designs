include DynamicArray

def test
  name= "Spartak"
  puts "Greetings Cesar"
  for i in 0 .. 5
   yield(name) if block_given?
  end
  puts "solute you"
end

test do |name|
puts name
puts "i'm the most powerfull gladiator hehe"
end



services = Array.new[
    {alias: 'all-servers', service_name: '*'},
    {alias: 'namenode', service_name: node[:hadoop][:namenode_service_name]},
    {alias: 'snamenode', service_name: node[:hadoop][:secondarynamenode_service_name]},
    {alias: 'slaves', service_name: node[:hadoop][:tasktracker_service_name]},
    {alias: 'jobtracker', service_name: node[:hadoop][:jobtracker_service_name]},
    {alias: 'nagios-server', service_name: node[:nagios][:nagios_service_name]},
    {alias: 'ganglia-server', service_name: node[:ganglia][:ganglia_service_name]},
    {alias: 'hbasemaster', service_name: node[:hbase][:master_service_name]},
    {alias: 'region-servers', service_name: node[:hbase][:region_service_name]},
    {alias: 'zookeeper-servers', service_name: node[:zookeeper][:zookeeper_service_name]},
    {alias: 'oozie-server', service_name: node[:oozie][:oozie_service_name]},
    {alias: 'hiveserver', service_name: node[:hive][:thrift_service_name]},
    {alias: 'templeton-server', service_name: node[:templeton][:service_name]},
]