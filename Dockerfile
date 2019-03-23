FROM julia:1.1.0-stretch
COPY AviAlgo/Manifest.toml AviAlgo/Project.toml /run/AviAlgo/
RUN julia --project=/run/AviAlgo -e "using Pkg; pkg\"instantiate\"; pkg\"precompile\""
COPY AviAlgo /run/AviAlgo
RUN cd /run/ \
 && julia --project=/run/AviAlgo -e "using AviAlgo;"
EXPOSE 9999
CMD cd /run/ \
 && julia --project=/run/AviAlgo -e "using AviAlgo; AviAlgo.start_algo_server()"
