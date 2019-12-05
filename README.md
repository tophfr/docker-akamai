# Faster docker images for Akamai CLI.

I used the official docker image provided by Akamai in my Jenkins jobs, but:
 - downloading the 1.6G docker image takes too much time
 - as big as this image is, it does not even include the api-gateway plugin that I needed
 - finally, it is unexpectedly slow to start

So this repo aims to provide smaller and faster images available on [docker hub][dockerhubpage] based on [Alpine Linux][alpinehubpage] and using the last available release of [Akamai CLI][akamaicli].

## How to use it

First create your `~/.edgerc` file with your api keys.  
Then run:

    akamai() { docker run --rm -i $([ -t 0 ] && echo -t) -v "$PWD:$PWD" -w "$PWD" -v $HOME/.edgerc:/root/.edgerc "tophfr/akamai:${1:-all}" "${@:2}"; }
    
    akamai purge invalidate --help
    akamai api-gateway list-endpoints
    akamai pl lc
    akamai cps list
    ...

## TODO

 - fixing permissions on linux (ok with Docker for Mac)


  [akamaicli]: https://developer.akamai.com/cli "Akamai CLI"
  [dockerhubpage]: https://hub.docker.com/r/tophfr/akamai "Akamai CLI docker hub page"
  [alpinehubpage]: https://hub.docker.com/_/alpine/ "A minimal Docker image based on Alpine Linux with a complete package index and only 5 MB in size!"
