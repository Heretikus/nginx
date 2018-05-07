apt_package 'Nginx| Get acl dependency (ansible unprivileged user operations magic)' do
  package_name  'acl'
  action        :upgrade
end

apt_repository 'Nginx | Add Ubuntu apt repository' do
    uri 'http://nginx.org/packages/ubuntu/'
    components ['nginx']
    distribution 'xenial'  # todo: specify right distribution
    key 'http://nginx.org/keys/nginx_signing.key'
end

# todo support debian

apt_package 'Nginx | Install (apt)' do
  package_name 'nginx'
  action       :upgrade
end

directory '/etc/nginx/sites-available' do
  owner 'root'
  group 'root'
  mode '0755'
  action :create
end

directory '/etc/nginx/sites-enabled' do
  owner 'root'
  group 'root'
  mode '0755'
  action :create
end

# todo: line in file

# - name: Nginx | Configure include sites-enabled
#   lineinfile: dest=/etc/nginx/nginx.conf regexp=".*sites-enabled.*" line="    include /etc/nginx/sites-enabled/*;" insertbefore="}" state=present
#   become: yes
#   tags:
#     - nginx


# - name: Nginx | Disable default site
# todo: learn how to output hints and lables

file '/etc/nginx/default.conf' do
  action :delete
  only_if { File.exist? '/etc/nginx/default.conf' }
end

file '/etc/nginx/conf.d/default.conf' do
  action :delete
  only_if { File.exist? '/etc/nginx/conf.d/default.conf' }
end


node['nginx']['nginx_properties'].each do |a_property|
  lineinfile '/etc/nginx/nginx.conf' do
    regexp a_property['regexp']
    line   a_property['line']
  end
end


  # - name: Nginx | Uncomment server_names_hash_bucket_size
  #   lineinfile: dest=/etc/nginx/nginx.conf regexp="^(\s*)#\s*server_names_hash_bucket_size" line="\1server_names_hash_bucket_size 64;" backrefs=yes
  #   become: yes
  #   tags:
  #     - nginx


    # - name: Nginx | Patch basic settings /etc/nginx/nginx.conf
    # lineinfile:
    #   dest: /etc/nginx/nginx.conf
    #   regexp: "{{item.regexp}}"
    #   line: "{{item.line}}"
    #   insertbefore: "{{item.insertbefore | default(omit)}}"
    #   insertafter: "{{item.insertafter | default(omit)}}"
    #   backrefs: "{{item.backrefs | default(omit)}}"
    # with_items: "{{nginx_conf_properties | default([])}}"
    # become: yes
    # tags:
    #  - nginx

#   - name: Nginx | Create snippets directory
directory '/etc/nginx/snippets' do
  owner 'root'
  group 'root'
  mode '0755'
  action :create
end

remote_directory "/etc/nginx/snippets" do
  source 'snippets'
  files_owner 'root'                                                                 
  files_group 'root'
  files_mode '0750'
  action :create
  recursive true                                                                      
end


node['nginx']['nginx_groups'].each do |grp|
  group grp do
    action :modify
    members node['nginx']['nginx_user']
    append true
  end
end


  # - name: Nginx | Add nginx user to additional groups, if needed
  #   user: name='nginx' groups="{{item}}" append=yes
  #   with_items: "{{nginx_groups}}"
  #   become: yes
  #   tags:
  #     - nginx


# - name: Nginx | custom log files workaround - allow nginx user to write files into /var/log/nginx but not read
#     acl:
#       path: /var/log/nginx
#       entity: nginx
#       etype: user
#       permissions: wx
#       state: present
#     become: yes
#     tags:
#       - nginx

#service 'nginx' do
#  supports :status => true, :restart => true, :reload => true
#  action [ :enable, :restart ]
#end

# todo skip above ^ if parameter docker_test is passed or defined
# after that uncomment
