# frozen_string_literal: true

module MCP; end

Rails.autoloaders.main.tap do |autoloader|
  Dir.glob(Rails.root.join("app/mcp/*")).each do |file|
    next unless File.directory?(file)

    autoloader.push_dir(file, namespace: MCP)
  end
end
