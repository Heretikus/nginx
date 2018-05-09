# https://supermarket.chef.io/cookbooks/lineinfile 0.0.3
# https://docs.chef.io/deprecations_namespace_collisions.html

resource_name 'lineinfile'
actions :run
default_action :run

property :dest,        String, name_property: true
property :line,        String
property :regexp,      [String,Regexp]
property :state,  String, default: 'present'

property :backrefs,    String, default: 'no'
property :backup,      String, default: 'no'
property :firstmatch,  String, default: 'no'
property :create,      String, default: 'no'
#
# property :group,       String
property :insertafter, String, default: 'EOF'
property :insertbefore,  String
#
# property :mode,        String
# property :others,      String
# property :owner,       String
# property :validate,    String
#


def present(path, regexp, line, ins_aft, ins_bef, create, backup, backrefs, firstmatch)
  regex = if regexp.is_a?(Regexp)
            regexp
          else
            Regexp.new(regexp)
          end
  Chef::Log.info "======> processing trying #{regexp} to replace with #{line}"

  # Do changes
  file = Chef::Util::FileEdit.new(path)

  # https://www.rubydoc.info/gems/chef/Chef/Util/FileEdit
  # TODO  - support insert after / insertbefore
  #

  file.search_file_replace_line(regex, line )
  # TODO: ^ if not above
  file.insert_line_if_no_match(regex, line )

  file.write_file

  # TODO: what instead?
  #updated_by_last_action(true) if file.file_edited?

  # Remove backup file
  if backup == 'no'
    ::File.delete(path + '.old') if ::File.exist?(path + '.old')
  end
end


def absent(path, regexp, line, backup)

  # Do changes
  file = Chef::Util::FileEdit.new(path)

  file.search_file_delete_line(regex) if new_resource.state == 'absent'

  file.write_file

  # TODO: what instead?
  #updated_by_last_action(true) if file.file_edited?

  # Remove backup file
  if new_resource.backup == 'no'
    ::File.delete(path + '.old') if ::File.exist?(path + '.old')
  end

end


action :run do

  def write_changes(b_lines, dest)
    open(dest, 'w') do |f|
      f.puts b_lines
    end
    return true
  end

  Chef::Log.info "======> HELLO WORLD"
  Chef::Log.info "======> processing trying #{new_resource.dest}"
  path = "#{new_resource.dest}"
  line = "#{new_resource.line}"
  regexp = "#{new_resource.regexp}"

  create = "#{new_resource.create}"
  backup = "#{new_resource.backup}"
  backrefs = "#{new_resource.backrefs}"
  firstmatch = "#{new_resource.firstmatch}"
  state = "#{new_resource.state}"

  ins_bef = "#{new_resource.insertbefore}"
  ins_aft = "#{new_resource.insertafter}"

  if ::File.directory?(path)
    raise "Given path is the directory"
  end

  if state == "present"
    if backrefs and not regexp
       raise "regexp= is required with backrefs=true"
    end

    if not line
      raise "line= is required with state=present"
    end

    if not ins_bef and not ins_aft
        ins_aft = "EOF"
    end

    present(path, regexp, line,
        ins_aft, ins_bef, create, backup, backrefs, firstmatch)

else
    if regexp == "" and line == ""
      raise "one of line= or regexp= is required with state=absent"
    end
    absent(path, regexp, line, backup)
end
end
