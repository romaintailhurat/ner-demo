include("ui.jl")

using Pkg; Pkg.activate(".")

using HTTP
using JSON
using Sockets

using .UI: view, entitiesToTags, nerLink

const ENGLISH_SENTENCE = "Paris is a great place to host a Eurostat meeting even if you don't speak 100% French!"
const FRENCH_SENTENCE = "Toulouse est également une jolie ville pour un hackathon hébergé par l'INSEE"
const ITALIAN_SENTENCE = "Spero ancora che andremo a vedere il Colosseo a Roma"
const WASHINGTON_SENTENCE = "Washington was a great president. Washington is where politics happens."

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
        <div> """ * nerLink("/ner-en", "English", ENGLISH_SENTENCE) * """ </div>
        <div> """ * nerLink("/ner-fr", "French", FRENCH_SENTENCE) * """ </div>
        <div> """ * nerLink("/ner-it", "Italian", ITALIAN_SENTENCE) * """ </div>
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

function washington(req::HTTP.Request)
    results = queryNERS(WASHINGTON_SENTENCE, "it")
    sentence_html = "<h2>" * WASHINGTON_SENTENCE * "</h2>"
    ner_html = view(sentence_html * entitiesToTags(results["named_entities"]))
    return(HTTP.Response(200, ner_html))
end

# Routing
const ROUTER = HTTP.Router()
HTTP.@register(ROUTER, "GET", "/", hello)
HTTP.@register(ROUTER, "GET", "/ner-en", neren)
HTTP.@register(ROUTER, "GET", "/ner-fr", nerfr)
HTTP.@register(ROUTER, "GET", "/ner-it", nerit)
HTTP.@register(ROUTER, "GET", "/washington", washington)

# Running
println("Starting server, listening on " * string(8000))
HTTP.serve(ROUTER, "0.0.0.0", 8000)