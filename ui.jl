module UI

export view, entitiesToTags

# HTMLing
function view(tags::String)
    return(
    """
    <!DOCTYPE html>
    <html lang='en'>
      <head>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/materialize/1.0.0/css/materialize.min.css">
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
    tags = "<ul class='collection with-header'>"
    for entity in entities
        tags *= "<li class='collection-item'>Text: " * entity["text"] * " - entity: " * entity["ent"] * "</li>"
    end
    tags *= "</ul>"
    return(tags)
end

end