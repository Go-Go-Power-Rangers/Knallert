### jeg ved faktisk ikke hvordan man skriver i ruby 


## haha

require 'net/http'
require 'json'
require 'uri'

accessToken = "bearer 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"

###
#FÅ LATEST RELEASE
query = " query {
    repository(owner: \"Go-Go-Power-Rangers\", name: \"Nicuh\") {
        latestRelease {
            name
            author
                {name}
            createdAt
            publishedAt
            description

        }
    }
}"


uri = URI("https://api.github.com/graphql")
res = Net::HTTP.start(uri.host, uri.port, use_ssl: true) do |http|
    req = Net::HTTP::Post.new(uri)
    req['Content-Type'] = "application/json"
    req['Authorization'] = accessToken
    # rrequest body
    req.body = JSON[{'query' => query}]
    puts(req.body)
    http.request(req)
end
puts(res.body)

release = res.body

accessToken = "qrwhyfib3ra0yqzvkf0tdfn7ns3p1e"

query = " mutation {
    syncPost(
        externalId: \"fz5hdg1f\"
        content: \"Test1, forbindelse d 18/08/22\ haha virker det?"
        format: HTML
        editUrl: \"https://github.com/Go-Go-Power-Rangers/Nicuh/releases/tag/v1.0.0\"
        readUrl: \"https://github.com/Go-Go-Power-Rangers/Nicuh/releases/tag/v1.0.0\"
    )
    {title, id}
}"

uri = URI("https://api.slab.com/v1/graphql")
res = Net::HTTP.start(uri.host, uri.port, use_ssl: true) do |http|
    req = Net::HTTP::Post.new(uri)
    req['Content-Type'] = "application/json"
    req['Authorization'] = accessToken
    # rrequest body
    req.body = JSON[{'query' => query}]
    puts(req.body)
    http.request(req)
end
puts(res.body)
