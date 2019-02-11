FROM julia:stretch
COPY build.jl server.jl ui.jl Manifest.toml Project.toml /app/
WORKDIR /app/
RUN julia build.jl
CMD julia server.jl