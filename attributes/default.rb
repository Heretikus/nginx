


default['nginx']['user'] = ["www-data"]
default['nginx']['nginx_groups'] = ["games"]


default['nginx']['nginx_properties'] = [
    { regexp: '^(\s*)#\s*server_names_hash_bucket_size', line: "\1server_names_hash_bucket_size 64;" },
    { regexp: '.*sites-enabled.*', line: '    include /etc/nginx/sites-enabled/*;' }
]
