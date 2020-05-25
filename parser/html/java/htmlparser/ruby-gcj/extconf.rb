require 'mkmf'

# system dependencies
gcj  = with_config('gcj', '/usr/share/java/libgcj.jar')

# headers for JAXP
CONFIG['CC'] = 'g++'
with_cppflags('-xc++') do

  unless find_header('org/w3c/dom/Document.h', 'headers')
  
    `jar tf #{gcj}`.split.each do |file|
      next unless file =~ /\.class$/
      next unless file =~ /^(javax|org)\/(w3c|xml)/
      next if file.include? '$'
    
      dest = 'headers/' + file.sub(/\.class$/,'.h')
      name = file.sub(/\.class$/,'').gsub('/','.')
    
      next if File.exist? dest
    
      cmd = "gcjh -cp #{gcj} -o #{dest} #{name}"
      puts cmd
      break unless system cmd
      system "ruby -pi -e '$_.sub!(/namespace namespace$/," +
        "\"namespace namespace$\")' #{dest}"
      system "ruby -pi -e '$_.sub!(/::namespace::/," +
        "\"::namespace$::\")' #{dest}"
    end

    exit unless find_header('org/w3c/dom/Document.h', 'headers')
  end

  find_header 'nu/validator/htmlparser/dom/HtmlDocumentBuilder.h', 'headers'
end

# Java libraries
Config::CONFIG['CC'] = 'g++ -shared'
dir_config('nu-htmlparser', nil, 'lib')
have_library 'nu-htmlparser'
have_library 'nu-icu'
have_library 'nu-chardet'

# Ruby library
create_makefile 'nu/validator'
