# https://supermarket.chef.io/cookbooks/lineinfile 0.0.3
# https://docs.chef.io/deprecations_namespace_collisions.html

resource_name 'lineinfile'
actions :run
default_action :run



# property :topic,      String, name_property: true
# property :partitions, Fixnum, default: 3
# property :replicas,   Fixnum, default: 3
# property :zookeeper,  String, default: "localhost:2181"


# property :backrefs, kind_of: String
property :backup,      String, default: 'no'
# property :create, kind_of: String
# #name_property: true,
property :dest,      String, name_property: true
# property :group, kind_of: String
# property :insertafter, kind_of: String
# property :insertbefore, kind_of: String
property :line,      String, required: true
# property :mode, kind_of: String
# property :others, kind_of: String
# property :owner, kind_of: String
property :regexp,      [String,Regexp], required: true
property :state,  String, default: 'present'
# property :validate, kind_of: String

action :run do
  Chef::Log.info "======> HELLO WORLD"
  Chef::Log.info "======> processing trying #{new_resource.dest}"
  file_path = "#{new_resource.dest}"
  the_line = "#{new_resource.line}"
  the_regexp = "#{new_resource.regexp}"

  regex = if the_regexp.is_a?(Regexp)
            the_regexp
          else
            Regexp.new(the_regexp)
          end
  Chef::Log.info "======> processing trying #{new_resource.regexp} to replace with #{new_resource.line}"

  # Do changes
  file = Chef::Util::FileEdit.new("#{new_resource.dest}")

  # https://www.rubydoc.info/gems/chef/Chef/Util/FileEdit
  # TODO  - support insert after / insertbefore
  #
  if new_resource.state == 'present'
    file.search_file_replace_line(regex, the_line )
    # TODO: ^ if not above
    file.insert_line_if_no_match(regex, the_line )
  end

  file.search_file_delete_line(regex) if new_resource.state == 'absent'

  file.write_file

  # TODO: what instead?
  #updated_by_last_action(true) if file.file_edited?

  # Remove backup file
  if new_resource.backup == 'no'
    ::File.delete(file_path + '.old') if ::File.exist?(file_path + '.old')
  end
end
