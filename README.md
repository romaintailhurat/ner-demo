# NER Demonstration

This is a simple implementation of a Julia client querying a Named Entity Recognition REST service.

## NER Service

This demonstration use the NLP service offered by the [Penelope project](https://penelope.vub.be/), see the [components page](https://penelope.vub.be/components/).

It is based on the [SpaCy NLP package](https://spacy.io/) which offers various NER models and supports this [list of entity types](https://spacy.io/usage/linguistic-features#entity-types).

## Architecture

[As basic as client - service relationship goes](https://docs.google.com/presentation/d/1feYvHHJ7XQXTR9R3LzmL3c9-9rxJ0AbF75OBopHyYfo/edit?usp=sharing).

## Running

This demo is packaged has a docker container. Once the project code on your laptop, build the image:

```bash
docker build -t ner-demo .
```

then run it:

```bash
docker run -it -p 8000:8000 ner-demo:latest
```