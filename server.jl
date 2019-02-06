using HTTP
using JSON
using Sockets

# HTMLing
function view(tags::String)
    return(
    """
    <!DOCTYPE html>
    <html lang='en'>
      <head>
        <title>NER DEMO</title>
      </head>
      <body>
        """ * tags * """
      </body>
    </html>
    """
    )
end

function entitiesToTags(entities)
    tags = ""
    for entity in entities
        tags *= "<div>Text: " * entity["text"] * " - entity: " * entity["ent"] * "</div>"
    end
    return(tags)
end

# Querying
function queryNERS(sentence::String, model::String)
    NER_SERVICE_URL = "https://penelope.vub.be/spacy-api/named-entities"
    input = Dict("sentence" => sentence, "model" => model)
    response = HTTP.post(NER_SERVICE_URL, ["Content-Type" => "application/json"], JSON.json(input))
    println("Parsing named entities contained in: '" * sentence * "'")
    println()
    results = JSON.parse(String(response.body))
    return(results)
end

# Handling
function hello(req::HTTP.Request)
    hello_html = view("<h1>Hello I3S!</h1>")
    return(HTTP.Response(200, hello_html))
end

function ner(req::HTTP.Request)
    results = queryNERS("Hello Paris", "en")
    ner_html = view(entitiesToTags(results["named_entities"]))
    return(HTTP.Response(200, ner_html))
end

# Routing
const ROUTER = HTTP.Router()
HTTP.@register(ROUTER, "GET", "/", hello)
HTTP.@register(ROUTER, "GET", "/ner-en", ner)

# Running
println("Starting server")
HTTP.serve(ROUTER, Sockets.localhost, 8000)