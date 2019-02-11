module UI

export view, entitiesToTags, nerLink

# HTMLing
function view(tags::String)
    return(
    """
    <!DOCTYPE html>
    <html lang='en'>
      <head>
        <meta charset="UTF-8">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/materialize/1.0.0/css/materialize.min.css">
        <title>NER DEMO</title>
      </head>
      <body>
        <div class="container">
        """ * tags * """
        </div>
      </body>
    </html>
    """
    )
end

function entitiesToTags(entities)
    tags = "<ul class='collection with-header'>"
    for entity in entities
        tags *= "<li class='collection-item'>Entity: " * entity["text"] * " - type: " * entity["ent"] * "</li>"
    end
    tags *= "</ul>"
    return(tags)
end

function nerLink(path::String, language::String, sentence::String)
    return("<a href='"*path*"'>["*language*"] " * sentence * "</a>")
end

end