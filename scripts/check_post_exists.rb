require 'net/http'
require 'json'
require 'uri'
require 'date'
require_relative 'methods.rb'
include CommonMethods

accessToken = "0qv5njxx9b0172cwywbxk03ovfagmc"
topicID= "2w941vt0"

### The flow so far:
# 1. Check Slab for a post titled with currentDate, and either
# - 1a. Find nil, and create a new syncpost with currentDate as externalId
# - 1b. Find an existing post, extract the content with mads-json-dissection, 
#       merge it with the new content, and override the syncPost by calling it
#       again with the new merged content.
###
 
currentDate = DateTime.now().strftime('%d-%m-%Y').to_s
puts currentDate.gsub("T", " ").split(/ /)[0]


query = " query {
    search (
        query: \"#{currentDate}\"
        first: 100
        types: POST
    ) { 
        edges {
            node {
                ... on PostSearchResult {
                    post {
                        title, id, topics{
                            id
                        } 
                    }
                }
            }
        }
    }   
}"
uri = URI("https://api.slab.com/v1/graphql")
res = queryFunc(uri, accessToken, query)
json_res = JSON.parse(res.body)
#Dig out the different edges
edges = json_res.dig("data","search","edges")
posts = []
existing_post_ID = nil

#add each post to the array of posts
edges.each_with_index do |edge,i|
    #add post
    posts.append(edge.dig("node","post"))
    #save important attributes
    post_id = posts[i].fetch("id")
    topics = posts[i].fetch("topics")
    #check if topics exists
    if(topics != nil)
        #check each topic whether it's the right one
        topics.each do |topic|
            id = topic.dig("id")
            #break out of loop if the post with the right topic has been found
            if(id != nil && id == topicID)
                existing_post_ID = post_id
                break
            end
        end
    end
    #break if post is found
    if(existing_post_ID != nil)
        break
    end
end

puts existing_post_ID
