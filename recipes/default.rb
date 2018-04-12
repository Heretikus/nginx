#
# Cookbook Name:: sa-nginx
# Recipe:: default
#
# Copyright (c) 2018 The Authors, All Rights Reserved.



include_recipe 'sa-python::install_apt' if platform?('ubuntu')
include_recipe 'sa-python::install_yum' if platform?('redhat', 'centos', 'fedora')



execute "apt-add-repository" do
    command "apt-add-repository ppa:nginx/stable"
  end  

#executes apt-get update
execute "apt-get update" do
    command "apt-get update"
  end

  #install nginx
  apt_package "nginx" do
    action :install
  end