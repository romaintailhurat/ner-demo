include("ui.jl")

using HTTP
using JSON
using Sockets

using .UI: view, entitiesToTags

const ENGLISH_SENTENCE = "Paris is a great place to host a Eurostat meeting even if you don't speak 100% French!"
const FRENCH_SENTENCE = "Toulouse est également une jolie ville pour un hackathon hébergé par l'INSEE"
const ITALIAN_SENTENCE = "Spero ancora che andremo a vedere il Colosseo a Roma"

# Querying
function queryNERS(sentence::String, model::String)
    NER_SERVICE_URL = "https://penelope.vub.be/spacy-api/named-entities"
    input = Dict("sentence" => sentence, "model" => model)
    response = HTTP.post(NER_SERVICE_URL, ["Content-Type" => "application/json"], JSON.json(input))
    println("Parsing named entities contained in: '" * sentence * "'")
    results = JSON.parse(String(response.body))
    return(results)
end

# Handling
function hello(req::HTTP.Request)
    hello_html = view(
        """
        <h1>Hello I3S!</h1>
        <div> <a href='/ner-en'>English</a> </div>
        <div> <a href='/ner-fr'>French</a> </div>
        <div> <a href='/ner-it'>Italian</a> </div>
        """
        )
    return(HTTP.Response(200, hello_html))
end

function neren(req::HTTP.Request)
    results = queryNERS(ENGLISH_SENTENCE, "en")
    sentence_html = "<h2>" * ENGLISH_SENTENCE * "</h2>"
    ner_html = view(sentence_html * entitiesToTags(results["named_entities"]))
    return(HTTP.Response(200, ner_html))
end

function nerfr(req::HTTP.Request)
    results = queryNERS(FRENCH_SENTENCE, "fr")
    sentence_html = "<h2>" * FRENCH_SENTENCE * "</h2>"
    ner_html = view(sentence_html * entitiesToTags(results["named_entities"]))
    return(HTTP.Response(200, ner_html))
end

function nerit(req::HTTP.Request)
    results = queryNERS(ITALIAN_SENTENCE, "it")
    sentence_html = "<h2>" * ITALIAN_SENTENCE * "</h2>"
    ner_html = view(sentence_html * entitiesToTags(results["named_entities"]))
    return(HTTP.Response(200, ner_html))
end

# Routing
const ROUTER = HTTP.Router()
HTTP.@register(ROUTER, "GET", "/", hello)
HTTP.@register(ROUTER, "GET", "/ner-en", neren)
HTTP.@register(ROUTER, "GET", "/ner-fr", nerfr)
HTTP.@register(ROUTER, "GET", "/ner-it", nerit)

# Running
println("Starting server")
HTTP.serve(ROUTER, Sockets.localhost, 8000)