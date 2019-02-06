using HTTP
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


# Handling
function hello(req::HTTP.Request)
    hello_html = view("<h1>Hello I3S!</h1>")
    return(HTTP.Response(200, hello_html))
end

function ner(req::HTTP.Request)
    return(HTTP.Response(200, "ner"))
end

# Routing
const ROUTER = HTTP.Router()
HTTP.@register(ROUTER, "GET", "/", hello)
HTTP.@register(ROUTER, "GET", "/ner-en", ner)

# Running
println("Starting server")
HTTP.serve(ROUTER, Sockets.localhost, 8000)