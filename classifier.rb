require "bundler/setup"
require "dotenv/load"
Bundler.require

require 'optparse'

# Require the ClassfierTool class
require "./tools/classifier_tool"

# Load the prompt template from a YAML file
prompt_template = Langchain::Prompt.load_from_path(
  file_path: "prompts/blog-post-classifier-prompt.yml"
)

# Run below to confirm which variables are required
prompt_template.input_variables
#=> ["blog_post"]

options = {}
OptionParser.new do |opts|
  opts.banner = "Usage: ruby classifier.rb [options]"

  opts.on("--file=FILE", "File to process") do |file|
    options[:file] = file
  end
end.parse!

if options[:file].nil?
  puts "Please provide a file path using --file=PATH"
  exit
end

file_path = options[:file]

if File.exist?(file_path)
  # Process the file
  puts "Processing file: #{file_path}"
  # Add your file processing logic here
else
  puts "File not found: #{file_path}"
end

unless File.extname(file_path).downcase == '.txt'
  puts "Error: File must be a .txt file"
  exit
end

# Output the prompt to be sent to the AI model
prompt = prompt_template.format(blog_post: [
  File.read(file_path)
])

# Instantiate the LLM to be used: OpenAI or any other Langchain::LLM::* class
llm = Langchain::LLM::OpenAI.new(
  api_key: ENV["OPENAI_API_KEY"],
  default_options: { chat_completion_model_name: "gpt-4o-mini" }
)

# Instantiate the assistant with the LLM and tools
assistant = Langchain::Assistant.new(
  llm: llm,
  tools: [
    ClassifierTool.new
  ]
)

# Add the prompt to the assistant and run it
assistant.add_message(content: prompt)
messages = assistant.run

puts("Classifications: #{messages.last.tool_calls}")
