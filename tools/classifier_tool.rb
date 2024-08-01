class ClassifierTool
  extend Langchain::ToolDefinition

  define_function :classify_topics, description: "Classify blog post by topics" do
    property :topics,
      type: "array",
      description: "List of topics to classify blog post into",
      required: true do
        item type: "string", enum: ["technology", "business", "health", "lifestyle", "politics", "sports", "entertainment"]
    end
  end
    
  define_function :classify_interests, description: "Classify blog post by interests" do
    property :interests,
      type: "array",
      description: "List of interests to classify blog post into",
      required: true do
        item type: "string", enum: ["fashion", "food", "travel", "music", "movies", "books", "art", "gaming"]
    end
  end
end