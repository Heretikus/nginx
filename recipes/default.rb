#
# Cookbook Name:: sa-nginx
# Recipe:: default
#
# Copyright (c) 2018 The Authors, All Rights Reserved.



include_recipe 'sa-nginx::install_ubuntu' if platform?('ubuntu')
# include_recipe 'sa-python::install_other' if platform?('redhat', 'centos', 'fedora')



