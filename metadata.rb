name 'sa-nginx'
maintainer 'Heretikus'
maintainer_email 'heretikus@gmail.com'
license 'all_rights'
description 'Installs/Configures sa-nginx'
long_description 'Installs/Configures sa-nginx'
version '0.1.0'

# If you upload to Supermarket you should set this so your cookbook
# gets a `View Issues` link
# issues_url 'https://github.com/<insert_org_here>/sa-nginx/issues' if respond_to?(:issues_url)

# If you upload to Supermarket you should set this so your cookbook
# gets a `View Source` link
# source_url 'https://github.com/<insert_org_here>/sa-nginx' if respond_to?(:source_url)


# OS list
%w{ ubuntu debian centos redhat fedora }.each do |os|
    supports os
  end