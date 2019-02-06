using HTTP
using JSON

NER_SERVICE_URL = "https://penelope.vub.be/spacy-api/named-entities"
SENTENCE = "Paris is a great place to host a Eurostat meeting even if you don't speak 100% French!"
#SENTENCE = "Toulouse est également une jolie ville pour un hackathon hébergé par l'INSEE"
MODEL = "en"

input = Dict("sentence" => SENTENCE, "model" => MODEL)

response = HTTP.post(NER_SERVICE_URL, ["Content-Type" => "application/json"], JSON.json(input))

println("Parsing named entities contained in:")
println()
println("\t'" * SENTENCE * "'")
println()

results = JSON.parse(String(response.body))

for ne in results["named_entities"]
    println("text: " * ne["text"] * " - entity: " * ne["ent"])
end