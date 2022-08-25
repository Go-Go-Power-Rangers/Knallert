require 'net/http'
require 'json'
require 'uri'
require_relative 'methods.rb'
include CommonMethods

# This script should take a post content and insert it the same way as original in MARKDOWN format

accessToken_slab = "0qv5njxx9b0172cwywbxk03ovfagmc"
query = " query {
    post (id: \"3k7ii9pq\") {
        content
    }
}"
uri = URI("https://api.slab.com/v1/graphql")
res = queryFunc(uri, accessToken_slab, query)
# puts("Slab api response \n" + res.body + "\n \n")
post_json = JSON.parse(res.body)
content = JSON.parse(post_json.fetch("data").fetch("post").fetch("content"))

markdown_string, post_title = create_markdown_from_slabjson(content)

# --- ADD NEW RELEASE HERE ---
accessToken_github = "bearer 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"
repo_name = "Nicuh"
query = " query {
    repository(owner: \"Go-Go-Power-Rangers\", name: \"#{repo_name}\") {
        latestRelease {
            name
            author
                {name}
            createdAt
            publishedAt
            description
            tagName
        }
    }
}"
uri = URI("https://api.github.com/graphql")
res = queryFunc(uri, accessToken_github, query)

# --- CALL METHOD(create_markdown_string) HERE ---
release_hash = JSON.parse(res.body)
release_new = release_hash.fetch("data").fetch("repository").fetch("latestRelease")
tag_name = release_new["tagName"]
markdown_string_new = create_markdown_string(release_new, repo_name, tag_name)

# --- OH YEAH, ITS ALL COMING TOGETHER ---
markdown_string = "#{post_title} #{markdown_string} #{markdown_string_new}"
puts "new markdown_string:\n#{markdown_string}"

# --- REQUEST TO UPDATE POST WITH NEW MARKDOWN STRING ---
query = " mutation {
    syncPost(
        externalId: \"9sbhb7oo\"
        content: \"#{markdown_string}\"
        format: MARKDOWN
        editUrl: \"https://\"
    )
    {title, id}
}"

uri = URI("https://api.slab.com/v1/graphql")

res = queryFunc(uri, accessToken_slab, query)
puts("\nSlab api response on succes\n" + res.body)

puts("Fishy him")