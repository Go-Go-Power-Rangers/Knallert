require 'net/http'
require 'json'
require 'uri'
require 'date'
require 'time'
require_relative 'methods.rb'
include CommonMethods

# --- REQUEST TO GITHUB ---
accessToken_github = "bearer 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"
repo_name = "Knallert"
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
# puts(res.body)

# extract variables from response
release_hash = JSON.parse(res.body)
latestRelease = release_hash.fetch("data").fetch("repository").fetch("latestRelease")
title = Date.parse(latestRelease.fetch("publishedAt")).strftime("%d-%m-%Y")
release_tag = latestRelease["tagName"]


# --- CALL METHOD(create_markdown_string) HERE ---
markdown_string = create_markdown_string(latestRelease, repo_name, release_tag)
puts("markdown_string: \n# #{title} #{markdown_string}")
markdown_string = "# #{title} #{markdown_string}"

# --- REQUESTS TO SLAB ---
accessToken_slab = "0qv5njxx9b0172cwywbxk03ovfagmc"
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
puts("\nSlab api response \n" + res.body)