# NER Demonstration

This is a simple implementation of a Julia client querying a Named Entity Recognition REST service.

## NER Service

This demonstration use the NLP service offered by the [Penelope project](https://penelope.vub.be/), see the [components page](https://penelope.vub.be/components/).

It is based on the [SpaCy NLP package](https://spacy.io/).

## Running

The first two options need a proper Julia installation.

### CLI

Two options here, executing via terminal or via the Julia REPL.

```bash
julia ner-demo.jl
```


```julia
julia> include("ner-demo.jl")
```

### Server